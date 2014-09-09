function ii_findsaccades(x,y,t,l,c1,v1,c2,v2)
%II_FINDSACCADES Summary of this function goes here
%   Detailed explanation goes here

% if nargin ~= 4
%     prompt = {'X Channel', 'Y Channel', 'Velocity Threshold', 'Length Threshold'};
%     dlg_title = 'Saccade Finder';
%     num_lines = 1;
%     answer = inputdlg(prompt,dlg_title,num_lines);
%
%     x = answer{1};
%     y = answer{2};
%     t = str2num(answer{3});
%     l = str2num(answer{4});
% end

%%%%%%%%%% ADD DISTANCE BETWEEN!!!!

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
              
        xvel = xvel.^2;
        yvel = yvel.^2;
        
        vel = xvel + yvel;
        vel = sqrt(vel);
        vel = [0; vel];
        
        ii_cfg.velocity = vel;
        putvar(ii_cfg,vel);
        
        % FIND SACCADES >= T
        
        ii_selectbyvalue('vel',6,t);
%         ii_cfg = evalin('base', 'ii_cfg');
%         cursel = ii_cfg.cursel;      
%         cursel(:,2) = cursel(:,1)+2;
%         sel = ii_cfg.sel * 0;
%         
%         ii_cfg.cursel = cursel;
%         ii_cfg.sel = sel;
%         for i=1:(size(cursel,1))
%             sel(cursel(i,1):cursel(i,2)) = 1;
%         end
%         putvar(ii_cfg);
%         
%         ii_selectuntil('vel',3,2,t2);
        
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
        
        % ii_showselections;
        
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
                cursel(:,2) = cursel(:,2)+2;
                
                ii_cfg.cursel = cursel;
                ii_cfg.sel = csel;
                putvar(ii_cfg);
                
                % ii_showselections;
                
                % select 50 samples after the saccade as endpoint
                
                %         nsel(:,1) = cursel(:,2);
                %         nsel(:,2) = nsel(:,1) + 50;
                %
                %         cursel = nsel;
                %         sel = sel*0;
                %
                %         for i=1:(size(cursel,1))
                %             sel(cursel(i,1):cursel(i,2)) = 1;
                %         end
                %
                %         ii_cfg.cursel = cursel;
                %         ii_cfg.sel = sel;
                %         putvar(ii_cfg);
                %
                %         ii_showselections;
                
                % take mean?
            else
                disp('Channel does not exist')
            end
        else
            disp('Channel does not exist')
        end
        
        
    else
        disp('Channel to does not exist in worksapce');
    end
else
    disp('Channel to does not exist in worksapce');
end
end

