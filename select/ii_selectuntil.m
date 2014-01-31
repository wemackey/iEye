function ii_selectuntil(c, cond, edge, cval)
%II_SELECTUNTIL Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 4
    prompt = {'Channel', sprintf('Until Condition: \n(1) is \n(2) is not \n(3) less than \n(4) greater than \n(5) less than or equal to \n(6) greater than or equal to'), sprintf('Edge: \n(1) Prior \n(2) Following'),'Value'};
    dlg_title = 'Select Until';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    c = answer{1};
    cond = str2num(answer{2});
    edge = str2num(answer{3});
    cval = str2num(answer{4});
end
ii_hideselections;
basevars = evalin('base','who');

if ismember(c,basevars)
    thechan = evalin('base',c);
    ii_cfg = evalin('base', 'ii_cfg');
    cursel = ii_cfg.cursel;
    sel = ii_cfg.sel;
    x = evalin('base',c);
    xs = size(x);
    
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
    
    if edge == 1
        
        vec = SplitVec(cwhere,'consecutive','lastval');
        for g = 1:size(cursel,1)
            if g == 1
                z = vec(vec<cursel(g,1) & vec<1);
                if z > 0
                    cursel(g,1) = z(1);
                end
            else
                z = vec(vec<cursel(g,1) & vec>cursel(g-1,2));
                if z > 0
                    cursel(g,1) = z(1);
                end
            end
        end
        
    elseif edge == 2
        
        vec = SplitVec(cwhere,'consecutive','firstval');
        for g = 1:size(cursel,1)
            if g == size(cursel,1)
                z = vec(vec>cursel(g,2) & vec<xs(1));
                if z > 0
                    cursel(g,2) = z(1);
                end
            else
                z = vec(vec>cursel(g,2) & vec<cursel(g+1,1));
                if z > 0
                    cursel(g,2) = z(1);
                end
            end
        end
    else
        disp('Invalid edge condition');
    end
    
    for z=1:(size(cursel,1))
        sel(cursel(z,1):cursel(z,2)) = 1;
    end
    
    ii_cfg.cursel = cursel;
    ii_cfg.sel = sel;
    putvar(ii_cfg);
    ii_showselections;
    
else
    disp('Channel does not exist')
end

end

