function [ii_data,ii_cfg] = ii_findmicrosaccades(ii_data,ii_cfg,xchan,ychan,vel_thresh,dur_thresh,amp_limit)
%ii_findmicrosaccades Detect microsaccades in eye movement traces given eye velocity
%   This function will detect and select microsaccades based on a particular set
%   of criteria: peak velocity, duration, amplitude all above some
%   thresholds
%
%   [ii_data,ii_cfg] = ii_findmicrosaccades(ii_data,ii_cfg) will use default
%   channels of 'X' and 'Y' for computing amplitude, and default
%   thresholds for velocity, duration and amplitude (30, 0.0075, 0.25)
%
%   [ii_data,ii_cfg] = ii_findmicrosaccades(ii_data,ii_cfg,xchan,ychan) will use
%   channel names specified by xchan, ychan (each str) for
%   detecting/thresholding amplitude
%
%   [ii_data,ii_cfg] = ii_findmicrosaccades(ii_data,ii_cfg,xchan,ychan,vel_thresh, dur_thresh,amp_limit)
%   will use specified thresholds for velocity (deg/s), duration (s), and
%   amplitude (deg)
%
% microsaccades identified with velocity, duration, or amplitude below the given
% thresholds will be culled. Duration and Amplitude thresholds are
% optional; if given as [], will not cull based on these parameters.
%
% ii_cfg will contain a .microsaccades field, which is the beginning/end of each
% saccade (in samples), and microsaccades will be selected after this function.
%
% Example:
% [ii_data,ii_cfg] = ii_findmicrosaccades(ii_data,ii_cfg,'X_smooth','Y_smooth',30,.0075,0.25); 
%   



% if nargin ~= 4
%     prompt = {'X Channel', 'Y Channel', 'Velocity Threshold', 'Length Threshold'};
%     dlg_title = 'Saccade Finder';
%     num_lines = 1;
%     answer = inputdlg(prompt,dlg_title,num_lines);
%
%     x = answer{1};
%     y = answer{2};
%     t = str2num(answer{3});
%     l = str2num(answer{4});
% end

% updated TCS 8/14/2017 - requires ii_velocity already been run, uses
% xchan/ychan only for ensuring sufficient distance between
% startpoint/endpoint
% for now, runs on entire time series - does not limit to particular
% epochs. at end of this function, microsaccades will be 'selected' by iEye -
% then, a separate function can be used to identify fixation periods
% between eye movements, and to extract information/metrics about the
% microsaccades themselves. [at least for now]. ii_cfg will have relevant info.


% fill in default values
if nargin <3
    xchan = 'X';
end

if nargin < 4
    ychan = 'Y';
end

if nargin < 5
    vel_thresh = 30; % deg/s
end

if nargin < 6
    dur_thresh = 0.0075; % s
end

if nargin < 7
    amp_limit = 1.5;   % deg
end

if isempty(dur_thresh)
    dur_thresh = 0;
end

if isempty(amp_limit)
    amp_limit = 0;
end

% make sure relevant channels exist
if ~ismember(xchan,fieldnames(ii_data))
    error('iEye:ii_findmicrosaccades:channelNotFound', 'Channel %s does not exist in ii_data',xchan)
end

if ~ismember(ychan,fieldnames(ii_data))
    error('iEye:ii_findmicrosaccades:channelNotFound', 'Channel %s does not exist in ii_data',ychan)
end

if ~ismember('velocity',fieldnames(ii_cfg))
    error('iEye:ii_findmicrosaccades:velocityNotComputed', 'Velocity has not yet been computed. Use ii_velocity before running ii_findmicrosaccades.')
end


% by this point, all variables accounted for...

[ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg);

% FIND microsaccades >= T

[ii_data,ii_cfg] = ii_selectbyvalue(ii_data,ii_cfg,ii_cfg.velocity,'greaterthanequalto',vel_thresh);


% compute saccade duration
microsacc_dur = (ii_cfg.cursel(:,2)-ii_cfg.cursel(:,1))/ii_cfg.hz;



% compute saccade amplitude
microsacc_amp = sqrt((ii_data.(xchan)(ii_cfg.cursel(:,1))-ii_data.(xchan)(ii_cfg.cursel(:,2))).^2 + (ii_data.(ychan)(ii_cfg.cursel(:,1))-ii_data.(ychan)(ii_cfg.cursel(:,2))).^2);


microsacc_keep = microsacc_dur >= dur_thresh & microsacc_amp <= amp_limit;

ii_cfg.cursel = ii_cfg.cursel(microsacc_keep,:);
ii_cfg.sel = 0*ii_cfg.sel;
for ii = 1:size(ii_cfg.cursel,1)
    ii_cfg.sel(ii_cfg.cursel(ii,1):ii_cfg.cursel(ii,2)) = 1;
end

ii_cfg.microsaccades = ii_cfg.cursel;


ii_cfg.history{end+1} = sprintf('ii_findmicrosaccades - dur, vel, amp thresh: %d, %d, %d, chans %s, %s - %s',dur_thresh, vel_thresh, amp_limit, xchan, ychan,datestr(now,30));



end

