function ii_cfg = ii_updatecursel(ii_cfg)
% II_UPDATECURSEL - Updated ii_cfg.cursel to match ii_cfg.sel
%   Utility function, should never be called by users, only called within
%   pre/processing and GUI commands
%
% Tommy Sprague, 8/15/2017

startidx = find(diff([0; ii_cfg.sel])== 1);
endidx   = find(diff([ii_cfg.sel; 0])==-1);


ii_cfg.cursel = [startidx endidx];


return