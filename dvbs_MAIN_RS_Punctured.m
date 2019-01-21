
tic
bit_stream_length = 188*8*3000;
bit_stream =randi([0,1],bit_stream_length,1);
N = 255;  % Codeword length
M = 8;    % 2^M  RS(N,K) N=2^M-1
%Each input vector should be a length of M*K bits
K = 239;  % Message length
S = 188;  % Shortened length

rate=N/K;
gp = [1 118 52 103 31 104 126 187 232 17 56 183 49 100 81 44 79];
%gp = [1 59 13 104 189 68 209 30 8 163 65 41 229 98 50 36 59];

rsEncoder = comm.RSEncoder(N,K,gp,S);
rsEncoder.BitInput=true;
rsDecoder = comm.RSDecoder(N,K,gp,S);
rsDecoder.BitInput=true;

[RS_bits] = step(rsEncoder,bit_stream); % SR(255,188) Encoded data

[CONV_Bits_nP, CONV_Bits_P, trellis] = dvbs_conv_code(RS_bits);

[d_symbols_P,Bits_Modulated_P] = dvbs_tx(CONV_Bits_P);
    
l=[];

for i=-4:8
% AWGN CHANNEL


    noise1 = dvbs_awgn(d_symbols_P,i, length(Bits_Modulated_P));

    
    t_Punct=Bits_Modulated_P+noise1'; % Add noise to transmitted data
    
% RECEIVER

    [Bits_Demodulated_Punct]= dvbs_rx(t_Punct); % Demodulate transmitted data

     DECODED_Bits_hard_Punct=vitdec(Bits_Demodulated_Punct,trellis,10,'trunc','hard', [1 1 0 1]);

    
    [RECEIVED_Bits_Punct]= rsDecoder(DECODED_Bits_hard_Punct');

    l=[l;i,dvbs_ber(RECEIVED_Bits_Punct,bit_stream)];
end
figure(3)
hold on
plot(l(:,1),10*log10(l(:,2)));
hold on 
legendmat = [legendmat;  "Concatenated (puncuterd)"];
title("BER vs EbN0")
xlabel("EbN0");
ylabel("BER");
legend(legendmat);

toc