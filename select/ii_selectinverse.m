function [ii_data,ii_cfg] = ii_selectinverse(ii_data,ii_cfg)
%II_SELECTINVERSE Select those points unselected, and de-select the points
%that were selected
% If no selections made, full timeseries will be selected

sel = ii_cfg.sel;


sel = ~(sel==1);

startidx = find(diff([0; sel])== 1);
endidx   = find(diff([sel; 0])==-1);

ii_cfg.sel = sel;
ii_cfg.cursel = [startidx endidx];



end

