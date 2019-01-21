clear;
clc;
tic
bit_stream_length = 100000*3;
bit_stream =randi([0,1],1,bit_stream_length);

legendmat=[];

%3.2.1

%TRANSMITTER - I will transmit same streams over both AWGN and non-AWGN
%channels
[coded_nP_stream, coded_P_stream, trellis] = dvbs_conv_code(bit_stream); % Add a convolutional code

[d_symbols_nP, Bits_Modulated_nP] = dvbs_tx(coded_nP_stream); % Transmit Non-Punctured Data
[d_symbols_P, Bits_Modulated_P] = dvbs_tx(coded_P_stream); % Transmit Punctured Data

%CONVOLUTIONAL CODE WITHOUT NOISE ( WITH PUNCTURED DATA)

% RECEIVER
[Punctured_Bits_DEModulated]=dvbs_rx(Bits_Modulated_P);

decoded_hard_P=vitdec(Punctured_Bits_DEModulated,trellis,2,'trunc','hard',[1 1 0 1]);

dvbs_ber(bit_stream,decoded_hard_P) %BER is 0 for no AWGN


% CONVOLUTIONAL CODE WITH AWGN ( P(unctured) & nP(non-punctured)  )


testStream = repmat([ 1 0 1  0 0 1  0 0 0  1 0 0  0 1 0 ],1,600000/15);


l=[];
for i=-4:6
    %GENERATE NOISE
    noise_nP= dvbs_awgn(d_symbols_nP,i, length(Bits_Modulated_nP));
    noise_P = dvbs_awgn(d_symbols_P,i, length(Bits_Modulated_P));

    %RECEIVE NOISY STREAMS
    [Received_Data_nP]= dvbs_rx(Bits_Modulated_nP+noise_nP);
    [Received_Data_P]= dvbs_rx(Bits_Modulated_P+noise_P);
    
    [Received_Data_S]=dvbs_rx2(Bits_Modulated_nP+noise_nP);

    %DECODE THE STREAMS
    decoded_hard_nP=vitdec(Received_Data_nP,trellis,10,'trunc','hard');
    decoded_soft = vitdec(Received_Data_S,trellis,10,'trunc','soft',3);
    decoded_hard_P=vitdec(Received_Data_P,trellis,10,'trunc','hard',[1 1 0 1]);

    l=[l;i,dvbs_ber(decoded_hard_P,bit_stream),dvbs_ber(decoded_hard_nP,bit_stream),...
        dvbs_ber(decoded_soft,bit_stream)];
end
figure(3)
hold on
plot(l(:,1),10*log10(l(:,2)));
hold on
plot(l(:,1),10*log10(l(:,3)));
hold on
plot(l(:,1),10*log10(l(:,4)));

legendmat = [legendmat;  "viterbi hard ( Puncuterd )"; "viterbi hard ( non-Puncuterd ) " ;" viterbi soft"];
legend(legendmat);
xlabel("Eb/N0");
ylabel("BER (dB)");
title("BER vs Eb/N0 for Convolutional Code");
toc