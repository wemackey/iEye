function ii_velocity(x,y)
% Calculate eye-movement velocity using eye-tracker X and Y channels as
% input. This vector is automatically saved to ii_cfg.velocity

if nargin ~= 2
    prompt = {'Channel 1 (X)', 'Channel 2 (Y)'};
    dlg_title = 'Velocity';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    x = answer{1};
    y = answer{2};
end

basevars = evalin('base','who');
ii_cfg = evalin('base', 'ii_cfg');

if ismember(x,basevars)
    if ismember(y,basevars)
        
        xvel = evalin('base',x);
        yvel = evalin('base',y);
        
        xvel = diff(xvel);
        yvel = diff(yvel);
        
        xvel = abs(xvel);
        yvel = abs(yvel);
        
        xvel = xvel.^2;
        yvel = yvel.^2;
        
        vel = xvel + yvel;
        vel = sqrt(vel);
        vel = [0; vel];
        
        ii_cfg.velocity = vel;
        dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
        ii_cfg.history{end+1,1} = sprintf('Calculated velocity (%s,%s) on %s ', x, y, dt);
        putvar(ii_cfg);
        
%         % Plot results
%         figure('Name','Velocity Channel','NumberTitle','off');
%         plot(vel);
        
    else
        disp('Channel to does not exist in worksapce');
    end
else
    disp('Channel to does not exist in worksapce');
end


end

