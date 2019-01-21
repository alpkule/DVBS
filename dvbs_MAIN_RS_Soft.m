
tic
bit_stream_length = 188*8*300;
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

[CONV_Bits_S, CONV_Bits_P, trellis] = dvbs_conv_code(RS_bits);

[d_symbols_S,Bits_Modulated_S] = dvbs_tx(CONV_Bits_S);

    
l=[];

for i=-4:6
% AWGN CHANNEL


    noise_S = dvbs_awgn(d_symbols_S,i, length(Bits_Modulated_S));
    
    t_S=Bits_Modulated_S+noise_S'; % Add noise to transmitted data
    
% RECEIVER

    [Bits_Demodulated_S]= dvbs_rx2(t_S); % Demodulate transmitted data

     DECODED_Bits_S=vitdec(Bits_Demodulated_S,trellis,10,'cont','soft',3);
    
    [RECEIVED_Bits_S]= rsDecoder(DECODED_Bits_S');

    l=[l;i,dvbs_ber(RECEIVED_Bits_S',bit_stream')];
end
figure(3)
hold on
plot(l(:,1),10*log10(l(:,2)));
hold on 
legendmat = [legendmat;  "Concatanated (Soft);"]
legend(legendmat);

toc