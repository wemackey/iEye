function ii_SRTv(run)
%II_SRTV Summary of this function goes here
%   Detailed explanation goes here

ii_view_channels('X,Y,TarX,TarY')
ii_velocity('X','Y');

tx = evalin('base','TarX');
ex = tx*0;
sel = tx*0;
sx = SplitVec(tx,'equal','first');
si = find(tx(sx)-0);
ex(sx(si)) = 1;

f = find(ex==1);

cursel(:,1) = f;
cursel(:,2) = cursel(:,1) + 5;

for i=1:(size(cursel,1))
    sel(cursel(i,1):cursel(i,2)) = 1;
end

putvar(cursel,sel)
ii_showselections;

ii_selectuntil('vel',4,2,.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF SELECTIONS WERE CHANGED, RERUN BELOW %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cursel = evalin('base','cursel');
SRTv = evalin('base','SRTv');
SRT = cursel(:,2) - cursel(:,1);
SRTv(:,run) = SRT;

putvar(SRT,SRTv,run);
end

