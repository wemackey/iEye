function procm_srt(r)
%PROCM_SRT Summary of this function goes here
%   Detailed explanation goes here

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
        ii_cfg = evalin('base','ii_cfg');
        
        ii_stats = evalin('base','ii_stats');
        
        
        vel = ii_cfg.velocity;
        putvar(vel);
        
        % Create SRT
        ii_stats(r).srt = [];
        
        % Create response time selections
        ii_stats(r).srt_cursel = [];
        ii_stats(r).srt_sel = [];
        
        putvar(ii_stats,r);
        
        % Make our best guess selections
        % IMPORTANT: Threshold can be manually updated in order to improve
        % accuracy. Remember this threshold value if it works well, because
        % it can be used to find main sequence
        ii_selectempty;
        
        ii_selectbyvalue('XDAT',1,4);
        ii_selectstretch(0,-750);
        ii_selectuntil('vel',4,2,.1);
        
        % Open trial companion window
        % Make sure you are in trial mode and you are good to go
        tComp;
        
    case 'No'
        disp('Cancelled')
end
end

