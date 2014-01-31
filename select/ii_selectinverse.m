function ii_selectinverse()
%II_SELECTINVERSE Summary of this function goes here
%   Detailed explanation goes here

ii_cfg = evalin('base', 'ii_cfg');
cursel = ii_cfg.cursel;
ii_hideselections;

if length(cursel) < 1
    disp('No selections made');
else
    sel = ii_cfg.sel;
    cursel = [ ];
    
    sel(sel==1) = 2;
    sel(sel==0) = 1;
    sel(sel==2) = 0;
    
    b = find(sel==1);
    putvar(b);
    split1 = SplitVec(b,'consecutive','first');
    split2 = SplitVec(b,'consecutive','last');
    
    cursel(:,1) = split1;
    cursel(:,2) = split2;
    
    ii_cfg.cursel = cursel;
    ii_cfg.sel = sel;
    putvar(ii_cfg);
    ii_showselections;
end

end

