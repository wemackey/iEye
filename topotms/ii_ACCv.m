function ii_ACCv(run)
%II_ACCV Summary of this function goes here
%   Detailed explanation goes here


ii_view_channels('X,Y,TarX,TarY')

tx = evalin('base','TarX');
ty = evalin('base','TarY');
x = evalin('base','X');
y = evalin('base','Y');

putvar(tx,ty,x,y);
ex = tx*0;
sel = tx*0;
sx = SplitVec(tx,'equal','first');
si = find(tx(sx)-0);
ex(sx(si)) = 1;

f = find(ex==1);

cursel(:,1) = f+900;
cursel(:,2) = cursel(:,1) + 100;

for i=1:(size(cursel,1))
    sel(cursel(i,1):cursel(i,2)) = 1;
end

putvar(cursel,sel)
ii_showselections;

xPOS = evalin('base','xPOS');
yPOS = evalin('base','yPOS');
txPOS = evalin('base','txPOS');
tyPOS = evalin('base','tyPOS');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF SELECTIONS WERE CHANGED RUN BELOW %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsel = size(cursel);

if nsel(1) == 30
    for g = 1:nsel
        sel = x*0;
        qq = cursel(g,:);
        rng = qq(2) - qq(1);
        selstrt = qq(1);
        selend = qq(2);
        
        for z=1:rng
            sel(selstrt:selend) = 1;
        end
        
        xPOS(g,run) = mean(x(sel==1));
        yPOS(g,run) = mean(y(sel==1));
        txPOS(g,run) = mean(tx(sel==1));
        tyPOS(g,run) = mean(ty(sel==1));
        
        putvar(xPOS,yPOS,txPOS,tyPOS,run);
    end
else
    disp('Not enough selections');
end
end

