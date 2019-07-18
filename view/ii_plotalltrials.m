function [ f_han ] = ii_plotalltrials( ii_data,ii_cfg,which_chans,nrows,ncols,epoch_chan,epoch_nums, fig_visible )
%ii_plotalltrials Plots all trials within ii_data
%   ii_plotalltrials(ii_data,ii_cfg) plots all trials as subplots within a
%   new figure if trials have been defined using a default set of plotting
%   parameters (X, Y, X_fix, Y_fix)
%
%   ii_plotalltrials(ii_data,ii_cfg,which_chans) plots channel(s) specified
%   in which_chans (cell array of strings or string)
%
%   ii_plotalltrials(ii_data,ii_cfg,which_chans,nrows,ncols) plots into
%   specified subplots, continuing onto multiple figures as necessary
%
%   ii_plotalltrials(ii_data,ii_cfg,which_chans,nrows,ncols,0) plots into
%   an invisible figure(s), to avoid disruption when scripting
%
%   [f_han] = ii_plotalltrials(...) returns the handle(s) to figures
%   created during call to ii_plotalltrials
%
% Wrapper for ii_plottrial, will use 'condensed' format. Defaults to 4
% columns and as many rows as necessary to fit a run (max 10). Potentially
% in the future custom plotting options will be allowed.
%
% Figure(s) returned here could be used for culling of bad trials in
% GUI-like manner by a separate function which uses these figure handles.
%
% Example:
% load('exdata1.mat');
% ii_plotalltrials(ii_data,ii_cfg);
%
% TODO: specify which trials in a vector
%
% TODO: navigate w/ pageup/down between trials (and allow GUI, if specified
% in varargin - so that opening a single-trial view from the GUI gives
% buttons) https://www.mathworks.com/matlabcentral/answers/1450-gui-for-keyboard-pressed-representing-the-push-button

% Tommy Sprague, 8/17/2017


if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_plotalltrials:trialsNotDefined','Trials not defined; run ii_definetrials before plotting all trials. To plot timeseries, see ii_plottimeseries');
end

if nargin < 3 || isempty(which_chans)
    which_chans = {'X','Y','TarX','TarY'};
end

if ~iscell(which_chans)
    which_chans = {which_chans};
end

if nargin < 5 || isempty(ncols)
    ncols = 4;
end

if nargin < 4 || isempty(nrows)
    nrows = min(10,ceil(ii_cfg.numtrials/ncols));
end

if nargin < 6 || isempty(epoch_chan)
    epoch_chan = 'XDAT';
end

if nargin < 7 || isempty(epoch_nums)
    % default to 'all' 
    epoch_nums = [];
end

if nargin < 8 || isempty(fig_visible)
    fig_visible = 1;
end

% make sure which_chans exist
for cc = 1:length(which_chans)
    if ~ismember(which_chans{cc},fieldnames(ii_data))
        error('iEye:ii_plotalltrials:channelNotFound','Channel %s not found in ii_data',which_chans{cc});
    end
end


if ~isempty(strfind(ii_cfg.edf_file,'/'))
    fn_fortitle = ii_cfg.edf_file(strfind(ii_cfg.edf_file,'/')+1:end);
else
    fn_fortitle = ii_cfg.edf_file;
end

nfigs = ceil(ii_cfg.numtrials/(nrows*ncols));

trial_cnt = 1; rowidx = 1; colidx = 1; fig_cnt = 0;
f_han = [];
while trial_cnt <= ii_cfg.numtrials
    
    if rowidx==1 && colidx==1
        if fig_visible == 1
            f_han(end+1) = figure;
        else
            f_han(end+1) = figure('visible','off');
        end
        fig_cnt = fig_cnt + 1;
        if nfigs > 1
            set(gcf,'NumberTitle','off','Name',sprintf('%s - %i of %i',fn_fortitle,fig_cnt,nfigs));
        else
            set(gcf,'NumberTitle','off','Name',sprintf('%s',fn_fortitle));
        end
    end
    
    thisax = subplot(nrows,ncols,(rowidx-1)*ncols+colidx); 
    ii_plottrial(ii_data,ii_cfg,trial_cnt,{'X','Y','TarX','TarY'},thisax,'condensed',epoch_chan,epoch_nums);
    
    % TODO: add a uimenu w/ callback to plot a detailed version of selected
    % trial?

    % increment trial_cnt, colidx
    trial_cnt = trial_cnt+1;
    colidx = colidx+1;
    
    if colidx > ncols
        colidx = 1;
        rowidx = rowidx+1;
    end
    
    if rowidx > nrows
        rowidx = 1;
    end
    
end

% embiggen
set(f_han,'Position',0.75*get(0,'Screensize'),'Renderer','painters');

return

