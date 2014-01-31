function ii_selectrange(fst, lst)
%II_SELECTRANGE Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 2
    prompt = {'Start Sample', 'End Sample'};
    dlg_title = 'Select by Range';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    fst = str2num(answer{1});
    lst = str2num(answer{2});
end
ii_hideselections;
ii_selectempty;
ii_cfg = evalin('base', 'ii_cfg');
sel = ii_cfg.sel;
cursel = [];

cursel(:,1) = fst;
cursel(:,2) = lst;

for i=1:(size(cursel,1))
    sel(cursel(i,1):cursel(i,2)) = 1;
end

ii_cfg.cursel = cursel;
ii_cfg.sel = sel;
putvar(ii_cfg);

ii_showselections;
end

