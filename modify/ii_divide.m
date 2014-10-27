function [idiv] = ii_divide(c1,c2)
%Divide channels
%   This function will modify one channel by dividing it by the values from
%   another channel.

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
        
        idiv = chan / chan2;
        
        assignin('base',c1,iadd);
        ii_replot;
        
    else
        disp('Channel does not exist in workspace');
    end
else
    disp('Channel does not exist in worksapce');
end
end

