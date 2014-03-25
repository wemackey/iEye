function procm_srt()
%PROCM_SRT Summary of this function goes here
%   Detailed explanation goes here

% Specify run #
% BE SURE TO UPDATE THIS OR YOU WILL OVERWRITE DATA
r = 1;

% Let's ask just to make sure you aren't writing over data
rr = sprintf('Do you really want to score run # %s', num2str(r));
choice = questdlg(rr, ...
    'WARNING', ...
    'Yes','No','No');
switch choice
    case 'Yes'     
        
        % Get config
        ii_cfg = evalin('base','ii_cfg');
        velocity = ii_cfg.velocity;
        
        % SRT
        ii_stats(r).srt = [];
        
        % Store response time selections
        ii_stats(r).srt_cursel = [];
        ii_stats(r).srt_sel = [];
        
        % Make our best guess selections
        
        
        % Open trial companion window
        % Make sure you are in trial mode and you are good to go
        tComp;
    case 'No'
        disp('Cancelled')
end
end

