function  [outstream] = dvbs_rx2(ss)

b=dvbs_shaping_filter; %Shaping filter coefficients (roll off, SPAN Symbols, Each symbol is represented by SPS samples)

% matched filter
o = upfirdn(ss,b,1,4);

%Thresholding
a=real(o);
b=imag(o);
A=[a;b];
A=A(:)';

id=A>=-3 & A<-2;
B(id)=7;

id=A>=-2 & A<-1;
B(id)=6;

id=A>=-1 & A<-0.5;
B(id)=5;

id=A>=-0.5 & A<0;
B(id)=4;

id=A>=0 & A<0.5;
B(id)=3;

id=A>=0.5 & A<1;
B(id)=2;

id=A>=1 & A<2;
B(id)=1;

id=A>=2 & A<3;
B(id)=0;

outstream=B(5:end-4);
%Output Strem is added '4 extra bits due to probably the filters
