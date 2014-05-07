function [pX,fX,tX,pY,fY,tY] = ii_split_acc_vgs(v,z,tv,tz)
%II_SPLIT_ACC_VGS Summary of this function goes here
%   Detailed explanation goes here

% P = PRIMARY SACCADE
% F = FINAL SACCADE
% T = TARGET SACCADE

% CREATE X MATRICES
pX = [];
fX = [];
tX = [];

y = size(v);

for q = 1:y(2)
    x = 1;
    for i = 1:30
        pX(i,q) = v(x,q);
        x = x + 2;
    end
    
    x = 2;
    for i = 1:30
        fX(i,q) = v(x,q);
        x = x + 2;
    end
    
    x = 2;
    for i = 1:30
        tX(i,q) = tv(x,q);
        x = x + 2;
    end
end

% CREATE Y MATRICES
pY = [];
fY = [];
tY = [];

y = size(z);

for q = 1:y(2)
    x = 1;
    for i = 1:30
        pY(i,q) = z(x,q);
        x = x + 2;
    end
    
    x = 2;
    for i = 1:30
        fY(i,q) = z(x,q);
        x = x + 2;
    end
    
    x = 2;
    for i = 1:30
        tY(i,q) = tz(x,q);
        x = x + 2;
    end
end

end

