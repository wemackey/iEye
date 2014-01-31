function ii_pupilvelocity(p)
%II_PUPILVELOCITY Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Pupil Channel'};
    dlg_title = 'Pupil';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    p = answer{1};
end

basevars = evalin('base','who');

if ismember(x,basevars)
    if ismember(y,basevars)
        
        pupil = evalin('base',p);
        
        pupil = diff(pupil);
        
        pupil = abs(pupil);
        
        pupil = pupil.^2;
        
        vel = pupil + pupil;
        vel = sqrt(vel);
        
        putvar(vel);
        
        figure('Name','Velocity Channel','NumberTitle','off');
        plot(vel);
        
    else
        disp('Channel to does not exist in worksapce');
    end
else
    disp('Channel to does not exist in worksapce');
end

end

