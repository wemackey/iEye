function [ isub ] = ii_subtract( c1,c2 )
%II_SUBTRACT Summary of this function goes here
%   Detailed explanation goes here

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
        
        isub = chan - chan2;
        
        assignin('base',c1,iadd);
        ii_replot;
        
    else
        disp('Channel does not exist in workspace');
    end
else
    disp('Channel does not exist in worksapce');
end

end

