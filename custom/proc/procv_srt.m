function procv_srt(r)
%PROCV_SRT Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%
% IMPORTANT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure ii_stats_vgs exists in workspace when starting to score a new
% participant.
% ii_stats_vgs = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        
        ii_stats_vgs = evalin('base','ii_stats_vgs');
                
        vel = ii_cfg.velocity;
        putvar(vel);
        
        % Create SRT
        ii_stats_vgs(r).srt = [];
        
        % Create response time selections
        ii_stats_vgs(r).srt_cursel = [];
        ii_stats_vgs(r).srt_sel = [];
        
        putvar(ii_stats_vgs,r);
        
        % Make our best guess selections
        % IMPORTANT: Threshold can be manually updated in order to improve
        % accuracy. Remember this threshold value if it works well, because
        % it can be used to find main sequence
        ii_selectempty;
        
        tx = evalin('base','TarX');
        ex = tx*0;
        sel = tx*0;
        sx = SplitVec(tx,'equal','first');
        si = find(tx(sx)-0);
        ex(sx(si)) = 1;
        
        f = find(ex==1);
        
        cursel(:,1) = f;
        cursel(:,2) = cursel(:,1) + 5;
        
        for i=1:(size(cursel,1))
            sel(cursel(i,1):cursel(i,2)) = 1;
        end
        
        ii_cfg.cursel = cursel;
        ii_cfg.sel = sel;
        
        putvar(ii_cfg);
        ii_replot;
        
        ii_selectuntil('vel',4,2,.1);
        
        % Open trial companion window
        % Make sure you are in trial mode and you are good to go
        tComp_vgs;
        
    case 'No'
        disp('Cancelled')
end
end

