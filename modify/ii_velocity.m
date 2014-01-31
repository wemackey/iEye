function [vel] = ii_velocity(x,y)
%II_VELOCITY Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 2
    prompt = {'Channel 1', 'Channel 2'};
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
        putvar(ii_cfg);
        
        figure('Name','Velocity Channel','NumberTitle','off');
        plot(vel);
        
    else
        disp('Channel to does not exist in worksapce');
    end
else
    disp('Channel to does not exist in worksapce');
end


end

