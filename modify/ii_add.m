function [iadd] = ii_add(c1,c2)
%Add two channels together
%   This function will modify one channel by adding another channel to it

if nargin ~= 2
    prompt = {'Modify Channel:', 'By Adding Channel:'};
    dlg_title = 'Calibrate To';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    c1 = answer{1};
    c2 = answer{2};
end

basevars = evalin('base','who');

if ismember(c1,basevars)
    if ismember(c2,basevars)
        chan = evalin('base',c1);
        chan2 = evalin('base',c2);
        
        iadd = chan + chan2;
        
        assignin('base',c1,iadd);
        ii_replot;
        
        dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
        ii_cfg = evalin('base','ii_cfg');
        ii_cfg.history{end+1,1} = sprintf('Added %s to %s on %s ', c1, c2, dt);
        putvar(ii_cfg);
        
    else
        disp('Channel does not exist in workspace');
    end
else
    disp('Channel does not exist in worksapce');
end
end


