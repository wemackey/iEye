function ii_findendpoints(x,y,t,l,c1,v1,c2,v2)
%Find saccade endpoints
%  This function will detect saccades, as defined by a set of parameters,
%  and then select the end points of those saccades.
%  Ex:
%  ii_findendpoints('X','Y',.07,5,'XDAT',4,'XDAT',6)

% ii_findsaccades
ii_findsaccades(x,y,t,l,c1,v1,c2,v2);

% get trial window we care about
basevars = evalin('base','who');

if ismember(c1,basevars)
    if ismember(c2,basevars)
        thechan = evalin('base',c1);
        thechan2 = evalin('base',c2);
        
        ii_cfg = evalin('base', 'ii_cfg');
        sel = ii_cfg.sel;
        cursel = [];
        tsel = sel*0;
        
        %         nchan = ii_cfg.nchan;
        %         lchan = textscan(ii_cfg.lchan,'%s','delimiter',',');
        %         schan = str2num(ii_cfg.hz);
        
        swhere = find(thechan == v1);
        ewhere = find(thechan2 == v2);
        
        tcursel(:,1) = SplitVec(swhere,'consecutive','firstval');
        tcursel(:,2) = SplitVec(ewhere,'consecutive','firstval');
        
        for i=1:(size(tcursel,1))
            tsel(tcursel(i,1):tcursel(i,2)) = 1;
        end
        
        % eliminate saccades outside this window
        
        csel = tsel + sel;
        csel = csel - 1;
        cwhere = find(csel==1);
        cursel(:,1) = SplitVec(cwhere,'consecutive','firstval');
        cursel(:,2) = SplitVec(cwhere,'consecutive','lastval');
        
        ii_cfg.cursel = cursel;
        ii_cfg.sel = csel;
        putvar(ii_cfg);
        
        ii_showselections;
        
        % select 50 samples after the saccade as endpoint
        
        nsel(:,1) = cursel(:,2);
        nsel(:,2) = nsel(:,1) + 50;
        
        cursel = nsel;
        sel = sel*0;
        
        for i=1:(size(cursel,1))
            sel(cursel(i,1):cursel(i,2)) = 1;
        end
        
        ii_cfg.cursel = cursel;
        ii_cfg.sel = sel;
        putvar(ii_cfg);
        
        ii_showselections;
        
        % take mean?
    else
        disp('Channel does not exist')
    end
else
    disp('Channel does not exist')
end


end

