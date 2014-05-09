function [eX,eY,eZ,gX,gY,gZ] = ii_calcerror_noabs(sx,tx,sy,ty)
%II_CALCERROR_NOABS Summary of this function goes here
%   Detailed explanation goes here

% Calculate Saccade Z
cf = (sx.^2) + (sy.^2);
sz = sqrt(cf);

% Calculate Target Z
cc = (tx.^2) + (ty.^2);
tz = sqrt(cc);

% Calculate Error (distance)
eX = tx - sx; % x error
eY = ty - sy; % y error

z = (eX.^2) + (eY.^2);
eZ = sqrt(z); % z error

% Calculate Gain
gX = sx./tx;
gY = sy./ty;
gZ = sz./tz;
end

