clear;
clc;
tic
bit_stream_length = 1000000;
bit_stream =randi([0,1],1,bit_stream_length);
legendmat=[];

% 3.1 WITHOUT FEC
[d_k,xe] = dvbs_tx(bit_stream);

[g]=dvbs_rx(xe);

bit_error_rate=dvbs_ber(g,bit_stream);
%bit error rate is 0 for no AWGN


% Add AWGN to the signal for eb/n0=-4:8
k=[];
for i =0:6
    noise = dvbs_awgn(d_k,i, length(xe));
    [g2]= dvbs_rx(xe+noise);
    k=[k;i,dvbs_ber(g2,bit_stream), snr(xe,noise) ];
end

BERR=berawgn([0:6],'qam', 4);

figure(2);
semilogy(k(:,1),k(:,2),'*');
hold on
semilogy(k(:,1),BERR);
legendmat = [legendmat;  'no FEC';"theoretical"];
legend(legendmat);
title("BER vs Eb/N0");
xlabel("Eb/N0");
ylabel("Bit error rate (dB)");



toc