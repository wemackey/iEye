function ii_quadrant()
%II_QUADRANT Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%
%        |        %
%    4   |   1    %
%        |        %
%--------|--------%
%        |        %
%    3   |   2    %
%        |        %
%%%%%%%%%%%%%%%%%%%


ii_selectempty;
ii_selectbyvalue('XDAT',1,5);

sel = evalin('base','sel');
tarx = evalin('base','TarX');
tary = evalin('base','TarY');
oquad = evalin('base','quad');

vec_tx = tarx(sel==1);
vec_ty = tary(sel==1);

tx = SplitVec(vec_tx,'equal','firstval');
ty = SplitVec(vec_ty,'equal','firstval');

xpos = find(tx>0);
xneg = find(tx<0);
ypos = find(ty>0);
yneg = find(ty<0);

nquad = zeros(30,1);

for i = 1:length(tx)
    if (tx(i) > 0) && (ty(i) > 0)
        nquad(i) = 1;
    elseif (tx(i) > 0) && (ty(i) < 0)
        nquad(i) = 2;
    elseif (tx(i) < 0) && (ty(i) > 0)
        nquad(i) = 3;
    elseif (tx(i) < 0) && (ty(i) < 0)
        nquad(i) = 4;
    end
end
quad = [oquad nquad];
putvar(quad,xpos,xneg,ypos,yneg);
end

