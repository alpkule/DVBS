function  [outstream] = dvbs_rx(ss)

b=dvbs_shaping_filter; %Shaping filter coefficients (roll off, SPAN Symbols, Each symbol is represented by SPS samples)

% matched filter
o = upfirdn(ss,b,1,4);

%Thresholding
a=real(o);
a(a<0)=-1;
a(a>0)=1;
a(a==0)=randsrc; %assign +-1 with 0.5 probability
b=imag(o);
b(b<0)=-1;
b(b>0)=1;
b(b==0)=randsrc;  %assign +-1 with 0.5 probability

%Demapping
demapping(1:2:2*(length(a)))=a*(-1/2)+0.5;
demapping(2:2:2*(length(b)))=b*(-1/2)+0.5;

outstream=demapping(5:end-4);
%Output Strem is added '4 extra bits due to probably the filters
%figure(5);
%impz(b_matched);
