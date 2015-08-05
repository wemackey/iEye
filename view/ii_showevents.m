function ii_showevents(evt,val)
%II_SHOWEVENTS Summary of this function goes here
%   Detailed explanation goes here

hax = get(iEye,'CurrentAxes');
axes(hax);
axis manual

event_data = evalin('base',evt);

if ~isempty(val)
i = find(event_data==val);
event_data = event_data(i);
end

xd = SplitVec(event_data,'equal','first');
yh = ylim(hax);

x=[xd,xd];
y=[yh(1),yh(2)];
plot(x,y,'-.')

end

