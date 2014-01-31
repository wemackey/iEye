function ii_selecthold()
%II_SELECTHOLD Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base', 'ii_cfg');
old_sel = ii_cfg.sel;
tmp_sel = old_sel;
sel = old_sel*0;

ii_cfg.tmp_sel = tmp_sel;
ii_cfg.sel = sel;
putvar(ii_cfg);
ii_selectempty();
end

