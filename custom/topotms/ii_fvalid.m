function [vZ] = ii_fvalid(v,z)
%II_FVALID Summary of this function goes here
%   Detailed explanation goes here

x = find(v>0);
vZ = z(x);

%putvar(vZ);
end

