function ii_selectbyvalue(c, cond, cval)
%II_SELECTBYVALUE Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 3
    prompt = {'Channel', sprintf('Condition: \n(1) is \n(2) is not \n(3) less than \n(4) greater than \n(5) less than or equal to \n(6) greater than or equal to'), 'Value'};
    dlg_title = 'Select by Value';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    c = answer{1};
    cond = str2num(answer{2});
    cval = str2num(answer{3});
end
ii_hideselections;
ii_selectempty;
basevars = evalin('base','who');

if ismember(c,basevars)
    thechan = evalin('base',c);
    ii_cfg = evalin('base', 'ii_cfg');
    sel = ii_cfg.sel;
    
    switch cond
        case 1
            cwhere = find(thechan == cval);
        case 2
            cwhere = find(thechan ~= cval);
        case 3
            cwhere = find(thechan < cval);
        case 4
            cwhere = find(thechan > cval);
        case 5
            cwhere = find(thechan <= cval);
        case 6
            cwhere = find(thechan >= cval);
        otherwise
            disp('Invalid condition');
    end
    
    cursel(:,1) = SplitVec(cwhere,'consecutive','firstval');
    cursel(:,2) = SplitVec(cwhere,'consecutive','lastval');
    
    for i = 1:length(cursel)
        dif = cursel(i,2) - cursel(i,1);
        if dif < 2
            cursel(i,2) = cursel(i,2) + 1;
        else
        end
    end
    
    for i=1:(size(cursel,1))
        sel(cursel(i,1):cursel(i,2)) = 1;
    end
    
    ii_cfg.cursel = cursel;
    ii_cfg.sel = sel;
    putvar(ii_cfg);
    
    ii_showselections;
    
else
    disp('Channel does not exist')
end

end

