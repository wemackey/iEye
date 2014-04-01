function ii_showselections()
%II_SHOWSELECTIONS Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base','ii_cfg');
sel = ii_cfg.sel;
cursel = [];

hax = get(iEye,'CurrentAxes');
axes(hax);
axis manual
h = findobj('type', 'rectangle');
hp = findobj('type', 'patch');
delete(h);
delete(hp);

cwhere = find(sel==1);
cursel(:,1) = SplitVec(cwhere,'consecutive','firstval');
cursel(:,2) = SplitVec(cwhere,'consecutive','lastval');

for i=1:(size(cursel,1))
    c1 = cursel(i,1);
    c2 = cursel(i,2);
    if c2 > c1
        x = c1;
        w = cursel(i,2) - cursel(i,1);
    else
        x = c2;
        w = cursel(i,1) - cursel(i,2);
    end
    ty = ylim(hax);
    y = ty(1);
    h = ty(2) - ty(1);
    % x = x * (schan./1000);
    % y = y * (schan./1000);
    % h = h;
    % w = w * (schan./1000);
    
    rectangle('Position', [x y w h], 'LineWidth', 2, 'Curvature', [0], 'EdgeColor', 'r', 'LineStyle', '-');
    p = patch([x x+w x+w x x],[y y y+h y+h y],'r','linewidth',1); % draw box around selected region
    set(p,'FaceAlpha',0.15);
end

ii_cfg.cursel = cursel;
putvar(ii_cfg);

end

