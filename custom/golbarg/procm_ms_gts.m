function procm_ms_gts(r)
% based on procm_ms

if nargin ~= 1
    prompt = {'Subject Run #'};
    dlg_title = 'Subject Run #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    r = str2num(answer{1});
end

% Let's ask just to make sure you aren't writing over data
rr = sprintf('Do you really want to score run # %s', num2str(r));
choice = questdlg(rr, ...
    'WARNING', ...
    'Yes','No','No');
switch choice
    case 'Yes'
        
        % Get config
        ii_velocity('X','Y');
        
        ii_cfg = evalin('base','ii_cfg');
        %ii_cfg = evalin('caller','ii_cfg');
        
        ii_stats = evalin('base','ii_stats');
        %ii_stats = evalin('caller','ii_stats');
        
        vel = ii_cfg.velocity;
        putvar(vel);
        
        % Create MS variables
        ii_stats(r).ms_duration = [];
        ii_stats(r).ms_peak_velocity = [];
        ii_stats(r).ms_avg_velocity = [];
        
        % Create response time selections
        ii_stats(r).ms_cursel = [];
        ii_stats(r).ms_sel = [];
        
        putvar(ii_stats,r);
        
        % Make our best guess selections
        % IMPORTANT: Threshold can be manually updated in order to improve
        % accuracy. Remember this threshold value if it works well, because
        % it can be used to find main sequence
        ii_selectempty;
        
        ii_selectbyvalue('XDAT',4,29);
        
        ii_selectstretch(0,-2400);
        ii_selectuntil('vel',4,2,.1); % 0.01
        
        ii_cfg = evalin('base','ii_cfg'); % get new selection values
        %ii_cfg = evalin('caller','ii_cfg');
        
        cursel(:,1) = ii_cfg.cursel(:,2);
        cursel(:,2) = ii_cfg.cursel(:,2)+2;
        
        ii_cfg.cursel = cursel;
        ii_cfg.sel = ii_cfg.sel*0;
        
        putvar(ii_cfg); 
        
        ii_selectuntil('vel',4,2,.1); % 0.01
        
        % Open trial companion window
        % Make sure you are in trial mode and you are good to go
        %tComp;
        
        % SMASH AND GRAB
        
        ii_cfg = evalin('base','ii_cfg');
        ii_stats = evalin('base','ii_stats');
        r = evalin('base','r');
        vel = evalin('base','vel');
        sel = ii_cfg.sel;
        
        b = find(sel==1);
        split1 = SplitVec(b,'consecutive','firstval');
        split2 = SplitVec(b,'consecutive','lastval');
        
        cursel(:,1) = split1;
        cursel(:,2) = split2;
        
        % Make sure there are 30 selections
        
        nsel = size(cursel);
        
        %if nsel(1) == 10
            
            pvel = zeros(10,1);
            avel = zeros(10,1);
            
            for g = 1:nsel
                sel =sel*0;
                qq = cursel(g,:);
                rng = qq(2) - qq(1);
                selstrt = qq(1);
                selend = qq(2);
                
                for z=1:rng
                    sel(selstrt:selend) = 1;
                end
                
                avel(g) = mean(vel(sel==1));
                pvel(g) = max(vel(sel==1));
                
            end
            
            nDuration = cursel(:,2) - cursel(:,1);
            ii_stats(r).ms_duration = nDuration;
            ii_stats(r).ms_peak_velocity = pvel;
            ii_stats(r).ms_avg_velocity = avel;
            ii_stats(r).ms_cursel = cursel;
            ii_stats(r).ms_sel = sel;
            putvar(ii_stats);
            disp('Calculation successful. Remember to save your data!');
        %else
        %    error('ERROR: Not enough selections!');
        %end
        
    case 'No'
        disp('Cancelled')
end
end

