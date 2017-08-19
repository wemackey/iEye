function ii_autoscale(chan,chan2)
%Scale values of one channel to another
%   This function will scale the values of one channel to the min/max of
%   another channel
%
% DEPRECATED! Should always know screen parameters for adjustments, this is
% a non-reliable way to adjust coordinates. 

fprintf('WARNING!!!!! USE ii_rescale.m IF AT ALL POSSIBLE; USE KNOWN SCREEN PARAMETERS!!!!\n\n');

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
        
        dt = datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM');
        ii_cfg = evalin('base','ii_cfg');
        ii_cfg.history{end+1,1} = sprintf('Autoscaled %s to %s on %s ', chan, chan2, dt);
        putvar(ii_cfg);
        
    else
        disp('Channel to autoscale to does not exist in workspace');
    end
else
    disp('Channel to autoscale does not exist in worksapce');
end
end

