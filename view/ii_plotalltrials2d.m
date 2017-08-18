function [ f_han ] = ii_plotalltrials2d( ii_data,ii_cfg,which_chans, varargin )
%ii_plotalltrials2d Plot of all trials, color-coded, in screen coords,
%overlaid
%   ii_plotalltrials2d(ii_data,ii_cfg) will overlay a plot of all trials,
%   each with a different color. if avaialble, fixations for each trial
%   will be drawn as filled circles in that trial's color
%
%   ii_plotalltrials2d(ii_data,ii_cfg,which_chans) specifies the exact
%   channels to use (must be cell array of 2 strings)
%
%   f_han = ii_plotalltrials2d(...) returns the figure handle for this plot
%
%   plotting options:
%       can add any/all of the below strings at end of arg list:
%       'nofixations' - does not plot fixations
%       'usesmooth' - uses which_chans{}_smooth for visualization; use this
%                     so that fix still works
%       'targlocs' - next argument should be target location on each trial
%       (matrix) TODO: verbose like in ii_calibratebytrial.m
%       'scalebar' - next argument should be size of scale bar, in
%                    which_chans units


% Tommy Sprague, 8/17/2017

% TODO: plotting constants up here




if nargin < 3
    which_chans = {'X','Y'};
end

if length(which_chans)~=2
    error('iEye:ii_plotalltrials2d:channelInputError','must provide 2 channels');
end



% open the figure, add a descriptive title
f_han = figure; hold on;
if ~isempty(strfind(ii_cfg.edf_file,'/'))
    fn_fortitle = ii_cfg.edf_file(strfind(ii_cfg.edf_file,'/')+1:end);
else
    fn_fortitle = ii_cfg.edf_file;
end
set(gcf,'NumberTitle','off','Name',fn_fortitle);

if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_plotalltrials2d:trialsNotDefined','must define trials (ii_definetrials.m)');
end


trial_colors = lines(ii_cfg.numtrials);

for tt = 1:ii_cfg.numtrials
    
    % if we want to plot smooth lines
    if ismember(varargin,'usesmooth')
        plot(ii_data.(sprintf('%s_smooth',which_chans{1}))(ii_cfg.tcursel(tt,1):ii_cfg.tcursel(tt,2)),...
             ii_data.(sprintf('%s_smooth',which_chans{2}))(ii_cfg.tcursel(tt,1):ii_cfg.tcursel(tt,2)),...
             '-','LineWidth',1.5,'Color',trial_colors(tt,:));
    
    % otherwise, use the regular values
    else
        plot(ii_data.(which_chans{1})(ii_cfg.tcursel(tt,1):ii_cfg.tcursel(tt,2)), ...
             ii_data.(which_chans{2})(ii_cfg.tcursel(tt,1):ii_cfg.tcursel(tt,2)), ...
             '-','LineWidth',1.5,'Color',trial_colors(tt,:));
    end
    
    % if we want to plot fixations (if available), do so as cirlces
    % TODO
    
end


% TODO: add target locations, if specified

% add fixation point at [0,0] (black plus)



% add scale bar, if requested


axis equal;
axis off;
end

