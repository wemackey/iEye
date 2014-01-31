function ii_selectempty()
%II_SELECTEMPTY Summary of this function goes here
%   Detailed explanation goes here
ii_cfg = evalin('base', 'ii_cfg');
sel = ii_cfg.sel;
sel = sel*0;

cursel = [];

ii_cfg.cursel = cursel;
ii_cfg.sel = sel;
putvar(ii_cfg);

ii_hideselections;
end

