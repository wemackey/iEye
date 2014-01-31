function ii_selectstretch(pri, fol)
%II_SELECTSTRETCH Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base', 'ii_cfg');
cursel = ii_cfg.cursel;
sel = ii_cfg.sel;
sel = sel*0;
ii_hideselections;

if length(cursel) < 1
    disp('No selections made for stretch');
else
    if nargin ~= 2
        prompt = {'Prior Edge Stretch', 'Following Edge Stretch'};
        dlg_title = 'Select by Stretch';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        
        pri = str2num(answer{1});
        fol = str2num(answer{2});
    end
    
    cursel(:,1) = cursel(:,1) - pri;
    cursel(:,2) = cursel(:,2) + fol;
    
    for z=1:(size(cursel,1))
        sel(cursel(z,1):cursel(z,2)) = 1;
    end
    
    ii_cfg.cursel = cursel;
    ii_cfg.sel = sel;
    putvar(ii_cfg);
    ii_showselections;
end
end
