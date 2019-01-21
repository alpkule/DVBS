
function [D,o] = dvbs_tx(data)

%2.1.1 INFORMATION GENERATION 
useful_bits=[data]*2-1;
%useful_bits=[ 1 1 0 0 1 0 0 1 1 1 0 0 1 0 0 1 1 1 0 0 1 0 0 1 1 1 0 0 1 0 0 1 1 1 0 0 1 0 0 1]*2-1;


Ns= 5; %Samples per symbol
Te= 10; %Sampling period
Ts= Ns*Te; %Symbol period



%4-ARY CHANNEL SYMBOL GENERATOR
M=4;
%Rc %bit rate
%Rs=Rc/log2(M)%Symbol rate
Rc=(Ts^-1)*log2(M);
Rs=Ts^-1;
%stream duration
s_duration = Ns*Te*Rc;


%mapping
A=useful_bits(1:2:end);
B=useful_bits(2:2:end);
D=((A)*(-1) + j*(B)*(-1)); 
%x_diracs=kron(D,[1 zeros(1,Ns-1)]);

%input bit stream is shaped by SRRC
b=dvbs_shaping_filter; %Shaping filter coefficients (roll off, SPAN Symbols, Each symbol is represented by SPS samples)

x_e=upfirdn(D,b,4);

% fvtool(b, 'Analysis', 'impulse')
% plot_lims = [-2 2];
% figure(1)
% plot(real(D), imag(D), 'o');
% xlim(plot_lims);
% ylim(plot_lims);
% title('QPSK constellation without noise');
% xlabel('real part');
% ylabel('imaginary part');
o=x_e;


% hold on
% stem (xx)




