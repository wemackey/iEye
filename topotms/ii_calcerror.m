function [eX,eY,eZ,tZ,sZ,gZ,theta] = ii_calcerror(tx,fx,ty,fy)
%II_CALCERROR Summary of this function goes here
%   Detailed explanation goes here

% Calc Z for target location
cc = (tx.^2) + (ty.^2);
tZ = sqrt(cc);

% Calc Z for target location
cf = (fx.^2) + (fy.^2);
sZ = sqrt(cf);

% Calc error
eX = fx - tx; % x error
eY = fy - ty; % y error

z = (eX.^2) + (eY.^2);
eZ = sqrt(z); % z error

% Calc gain
gZ = sZ./tZ;

% Calc theta
zc = (tZ.^2) + (sZ.^2);
zZ = sqrt(zc); % 3rd side of triangle

% for i = 1:30
%     for f = 1:10
%     a(1:3,1) = [tx(f,i);ty(f,i),0];
%     a(1:3,2) = [fx(f,i);fy(f,i),0];
%     theta = ii_theta(a);
%     end
% end

cA = ((tZ.^2) + (sZ.^2) - (zZ.^2))./(2.*tZ.*sZ);
theta = cos(cA);
theta = theta.^-1;
putvar(cA);
end

