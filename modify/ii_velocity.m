function [ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg,xchan,ychan)
% ii_velocity Calculates velocity of eye position given x, y channels
%   [ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg) computes velocity on
%   ii_data chans X_smooth and Y_smooth, if available, or defaults to X, Y.
%
%   [ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg,xchan,ychan) computes on
%   channels ii_data.(xchan) and .(ychan)
%
% xchan and ychan must be strings, and must be fields of ii_data
% ii_cfg.velocity will contain the instantaneous velocity euclidean 
% distance between paired samples) of defined channels
% 
% Example:
% load('exdata1.mat'); % smooth data first
% [ii_data,ii_cfg] = ii_blinkcorrect(ii_data,ii_cfg,{'X','Y'},'Pupil',1500,150,50);
% [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,{'X','Y'},'Gaussian',5);
% [ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg,'X_smooth','Y_smooth');
% figure;
% subplot(2,1,1);
% hold on;
% plot(ii_data.X_smooth,'-','LineWidth',1);
% plot(ii_data.Y_smooth,'-','LineWidth',1);
% xlabel('Samples');
% title('Smoothed data');
% subplot(2,1,2);
% plot(ii_cfg.velocity,'k-','LineWidth',1);
% xlabel('Samples');
% title('Velocity (s^{-1})');

% Updated 8/14/2017 TCS - uses ii_data; velocity saved in deg/s

if nargin == 2
    prompt = {'Channel 1 (X)', 'Channel 2 (Y)'};
    dlg_title = 'Velocity';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    xchan = answer{1};
    ychan = answer{2};
end


if ismember(xchan,fieldnames(ii_data)) && ismember(ychan,fieldnames(ii_data))
    
    ii_cfg.velocity = [0; sqrt(diff(ii_data.(xchan)).^2 + diff(ii_data.(ychan)).^2) ] * ii_cfg.hz;
    
    ii_cfg.history{end+1} = sprintf('ii_velocity (%s,%s) - %s ', xchan, ychan, datestr(now,30));
    
    % added 6/13/2018 - save velocity as a channel in ii_data
    ii_data.Velocity = ii_cfg.velocity;
    
else
    error('iEye:ii_smooth:channelNotFound', 'Channel %s or %s does not exist in ii_data',xchan,ychan)
end


end

