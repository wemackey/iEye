function ii_findsaccades(x,y,t,l)
%II_FINDSACCADES Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 4
    prompt = {'X Channel', 'Y Channel', 'Velocity Threshold', 'Length Threshold'};
    dlg_title = 'Saccade Finder';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    x = answer{1};
    y = answer{2};
    t = str2num(answer{3});
    l = str2num(answer{4});
end

basevars = evalin('base','who');
ii_cfg = evalin('base', 'ii_cfg');

if ismember(x,basevars)
    if ismember(y,basevars)
        
        ii_selectempty;
        
        % GET VELOCITY
        
        xv = evalin('base',x);
        yv = evalin('base',y);
        
        xvel = diff(xv);
        yvel = diff(yv);
        
        xvel = abs(xvel);
        yvel = abs(yvel);
        
        xvel = xvel.^2;
        yvel = yvel.^2;
        
        vel = xvel + yvel;
        vel = sqrt(vel);
        vel = [0; vel];
        
        ii_cfg.velocity = vel;
        putvar(ii_cfg,vel);
        
        % FIND SACCADES >= T
        
        ii_selectbyvalue('vel',6,t);
        
        % IGNORE SACCADES < L
        
        ii_cfg = evalin('base', 'ii_cfg');
        cursel = ii_cfg.cursel;
        sel = ii_cfg.sel * 0;
        
        dif = cursel(:,2) - cursel(:,1);
        
        ind = find(dif<l);
        
        cursel(ind,:) = [];
        
        for i=1:(size(cursel,1))
            sel(cursel(i,1):cursel(i,2)) = 1;
        end
        
        ii_cfg.cursel = cursel;
        ii_cfg.sel = sel;
        ii_cfg.saccades = cursel;
        putvar(ii_cfg);
        
        % SHOW SELECTIONS
        
        ii_showselections;
        
    else
        disp('Channel to does not exist in worksapce');
    end
else
    disp('Channel to does not exist in worksapce');
end
end

