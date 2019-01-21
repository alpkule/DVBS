% 1st run dvbs_MAIN_RS_Nonpunctured 
legendmat = [legendmat;  "RS viterbi hard & non-puncuterd & interleaving"]

tic

Bit_Stream_Length = 188*8*1000;
DLY=12*11*17*8; %Delay is N*(N-1)*J (J=17*8 ; N=12)

Bit_Stream =randi([0,1],Bit_Stream_Length-(DLY),1);
Bit_Stream=[Bit_Stream;zeros(DLY,1)];

N = 255;  % Codeword length
M = 8;    % 2^M  RS(N,K) N=2^M-1

%Each input vector should be a length of M*K bits
K = 239;  % Message length
S = 188;  % Shortened length

rate=N/K;
%gp = [1 118 52 103 31 104 126 187 232 17 56 183 49 100 81 44 79];
gp = [1 59 13 104 189 68 209 30 8 163 65 41 229 98 50 36 59];

rsEncoder = comm.RSEncoder(N,K,gp,S);
rsEncoder.BitInput=true;
rsDecoder = comm.RSDecoder(N,K,gp,S);
rsDecoder.BitInput=true;


[RS_Bits] = step(rsEncoder,Bit_Stream); % RS(255,188) Encoded data

[RS_Bits_Convint]=convintrlv(RS_Bits,12,17*8); %interleaving

[CONV_Bits, CONV_Bits_Punctured, trellis] = dvbs_conv_code(RS_Bits_Convint); %convolutional code

[D_Symbols,Bits_Modulated] = dvbs_tx(CONV_Bits); % transmit data to channel

    
l=[];

for i=-4:6
% AWGN CHANNEL
    Noise1 = dvbs_awgn(D_Symbols,i, length(Bits_Modulated));
    
    t=Bits_Modulated+Noise1'; % Add noise to transmitted data
    
% RECEIVER

    [Bits_Demodulated]= dvbs_rx(t); % Demodulate transmitted data

    DECODED_Bits=vitdec(Bits_Demodulated,trellis,10,'trunc','hard');
        
    [DECODED_Bits_Convdeint] = convdeintrlv(DECODED_Bits,12,17*8); %Deinterleaving
    
    [RECEIVED_Bits]= step(rsDecoder,DECODED_Bits_Convdeint'); % REED SOLOMON Decoder
    
    Y=circshift(RECEIVED_Bits(DLY+1:length(RECEIVED_Bits)),1408); % Montecarlo simulations show that ouuput bits are shifted 1408 bits
    
    X=Bit_Stream(1:Bit_Stream_Length-DLY);
    l=[l;i,dvbs_ber(Y,X)];
end
 figure(3)
 hold on
 plot(l(:,1),10*log10(l(:,2)));
 hold on 
 legend(legendmat);

toc