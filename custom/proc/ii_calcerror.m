function [eX,eY,eZ,gX,gY,gZ] = ii_calcerror(sx,tx,sy,ty)
%II_CALCERROR Summary of this function goes here
%   sx = saccade x, tx = target x, sy = sccade y, ty = target y

% Calculate Saccade Z
cf = (sx.^2) + (sy.^2);
sz = sqrt(cf);

% Calculate Target Z
cc = (tx.^2) + (ty.^2);
tz = sqrt(cc);

% Calculate Error (distance)
eX = abs(tx - sx); % x error
eY = abs(ty - sy); % y error

z = (eX.^2) + (eY.^2);
eZ = sqrt(z); % z error

% Calculate Gain
gX = sx./tx;
gY = sy./ty;
gZ = sz./tz;
end

