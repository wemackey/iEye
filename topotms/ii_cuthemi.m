function [rE,lE] = ii_cuthemi(h,v,m)
%II_CUTHEMI Summary of this function goes here
%   Detailed explanation goes here

totmat = h.*v;
putvar(totmat);

l = find(totmat==1);
r = find(totmat==2);

rE = m(l);
lE = m(r);

%putvar(rE,lE);
end

