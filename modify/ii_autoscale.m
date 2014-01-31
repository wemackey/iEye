function ii_autoscale(chan,chan2)
%II_AUTOSCALE Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 2
    prompt = {'Enter channel to autoscale:', 'Enter channel to autoscale to:'};
    dlg_title = 'Autoscale To';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    chan = answer{1};
    chan2 = answer{2};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    if ismember(chan2,basevars)
        c1 = evalin('base',chan);
        c2 = evalin('base',chan2);
        
        c1 = c1 - mean(c1);
        c1 = (c1-min(c1(:))) ./ (max(c1(:)-min(c1(:))));
        c1 = c1.*2;
        c1 = c1 - mean(c1);
        c1 = c1.*max(c2);
        
        disp('Autoscale saved');
        assignin('base',chan,c1);
        ii_replot;
        
        figure;
        plot(c1);
        hold all;
        plot(c2);
        
    else
        disp('Channel to autoscale to does not exist in workspace');
    end
else
    disp('Channel to autoscale does not exist in worksapce');
end

end

