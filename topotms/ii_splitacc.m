function [pX,fX,tX,pY,fY,tY] = ii_splitacc(v,z)
%II_SPLITACC Summary of this function goes here
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
        x = x + 3;
    end
    
    x = 2;
    for i = 1:30
        fX(i,q) = v(x,q);
        x = x + 3;
    end
    
    x = 3;
    for i = 1:30
        tX(i,q) = v(x,q);
        x = x + 3;
    end
end

% putvar(pX,fX,tX);

% CREATE Y MATRICES
pY = [];
fY = [];
tY = [];

y = size(z);

for q = 1:y(2)
    x = 1;
    for i = 1:30
        pY(i,q) = z(x,q);
        x = x + 3;
    end
    
    x = 2;
    for i = 1:30
        fY(i,q) = z(x,q);
        x = x + 3;
    end
    
    x = 3;
    for i = 1:30
        tY(i,q) = z(x,q);
        x = x + 3;
    end
end

% putvar(pY,fY,tY);

end

