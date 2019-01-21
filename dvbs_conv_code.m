function [codedData,puncturedData, t] = dvbs_conv_code (data)

% G1=171  = 0111 1001
% G2=133  = 0101 1011
% k/n = 1/2 (input bits vs output bits)


% Trellis=poly2trellis (ConstraintLength, CodeGenerator)
% Constraint Length is a 1-by-k
% k-by-n matrix of octal numbers that specifies the n output connections 
% for each of the encoder's k input bit streams.
% t is returned to use at the receiver stage

trellis=poly2trellis(7,[171,133]);
    codedData = convenc(data,trellis);
    puncturedData = convenc(data,trellis,[1 1 0 1]);

t=trellis;