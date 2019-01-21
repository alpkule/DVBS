function [o]=dvbs_ber(s1,s2)

o = sum(xor(s1,s2))/length(s2);
