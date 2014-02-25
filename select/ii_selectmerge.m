function ii_selectmerge()
%II_SELECTMERGE Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base', 'ii_cfg');
old_sel = ii_cfg.sel;
tmp_sel = ii_cfg.tmp_sel;

sel = old_sel + tmp_sel;
ind = find(sel>0);
sel(ind) = 1;

ii_cfg.cursel = sortrows(ii_cfg.cursel);
ii_cfg.sel = sel;
putvar(ii_cfg);

ii_replot;
end

