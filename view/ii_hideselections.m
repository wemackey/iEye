function ii_hideselections()
%II_HIDESELECTIONS Summary of this function goes here
%   Detailed explanation goes here

hax = get(iEye,'CurrentAxes');
axes(hax);
h = findobj('type', 'rectangle');
hp = findobj('type', 'patch');
delete(h);
delete(hp);
end

