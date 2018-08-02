function [ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg)
%II_SELECTEMPTY Ensures 'selection' is empty
%   Maintains conventions of ii_data, ii_cfg arguments
%
% Updated TCS 8/14/2017 for iEye refactor

sel = ii_cfg.sel;
sel = sel*0;

cursel = [];

ii_cfg.cursel = cursel;
ii_cfg.sel = sel;


%ii_hideselections;
end

