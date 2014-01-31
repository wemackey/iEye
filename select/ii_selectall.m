function ii_selectall()
%II_SELECTALL Summary of this function goes here
%   Detailed explanation goes here
ii_hideselections;
ii_cfg = evalin('base', 'ii_cfg');
sel = ii_cfg.sel;
sel(1:length(sel)) = 1;

cursel(1,1) = 1;
cursel(1,2) = length(sel);

ii_cfg.cursel = cursel;
ii_cfg.sel = sel;
putvar(ii_cfg);

ii_showselections;
end

