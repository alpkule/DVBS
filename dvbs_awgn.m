
%This function produces AWGN of a certain power as a function of Eb/N0

function [noise] = awgn_transmission (symbols_D, ebno, noise_length)

% noise power sigma_n
 b=dvbs_shaping_filter;
 M=4;
 ebn0_nodB=10^(ebno/10);
 sigma2D=var((symbols_D));
 sigma_niq2 =( (sum(abs(impz(b)).^2)*sigma2D)/(ebn0_nodB*2*log2(M)) );
 
 nI = sqrt(sigma_niq2)*randn(1, noise_length);
 nQ=nI;
 noise=[nI + j*nQ];%.*((randi([0, 1],1,noise_length))*2-1);
 