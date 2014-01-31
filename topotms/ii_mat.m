function ii_mat(v)
%II_MAT Summary of this function goes here
%   Detailed explanation goes here

vx = size(v);
V_Mat = ones(vx(1),vx(2));

x = find(v<=100);
V_Mat(x) = 0;
y = find(v>=900);
V_Mat(y) = 0;

putvar(V_Mat);

end

