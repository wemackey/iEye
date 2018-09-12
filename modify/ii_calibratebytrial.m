function [ ii_data, ii_cfg ] = ii_calibratebytrial( ii_data, ii_cfg, chan_names, calib_targets, calib_mode, adj_limit )
%II_CALIBRATEBYTRIAL Adjust gaze coords so that gaze is a known value at a
%known period of trial.
%   One selection expected per trial, and either channels, column indices
%   to ii_cfg.trialinfo, or n_trials length vectors, to which the full
%   trial timeseries is warped.
%   CALIB_MODE can be one of: 'rotate' or 'scale' - if rotate, chan_names
%   MUST be both X & Y; if scale, can be either one or both channels. [like
%   ii_driftcorrect.m, we also adjust all 'child' channels - those which
%   begin with chan_names{cc}_]
%   - scale: multiply channel values by
%     desired_chan_value/actual_chan_value independently
%   - rotate: convert to r, th, scale r and rotate th to achieve desired
%     coords
%   ADJ_LIMIT is the maximum allowable error, in dva, between the selected
%   fixation and the calib_target on that trial, in euclidean distance, so
%   this must be just one number. By default, set to inf, but this will
%   allow for CRAZY adjustments - always check carefully!
%
% Note: it's helpful to have run driftcorrect before this so that
% 'fixation' values are set to 0,0, and so scaling doesn't substantially
%  alter mean fixation
%
% See also ii_calibratebyrun.m version which applies similar
% polynomial fitting/adjustment as previous versions of iEye
% (ii_calibrateto.m). This version attempts to fix each trial individually
% without regard for stability across positions over a run. 
%
% NOTE: does not scale velocity!!! this may take some work...
%
% Updated 6/13/2018 - now uses absolute distance threshold for deciding
% whether to calibrate or not. If distance between input fixation and
% target is > adj_limits, do not calibrate.
% - saves out calibrate.amt: amount of scaling applied (factor used for
%   dividing/multiplying) to each channel
% - also saves out calibrate.err: euclidean distance between target point
%   and fixation (1 number)
% 

% Tommy Sprague, 8/16/2017 


% make sure trials have been defined, and there's a selection for every
% trial
if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_calibratebytrial:noTrialsDefined', 'Trials not defined; run ii_definetrials.m first');
end

% TODO:
% as we loop over trials, if a selection is missing within a trial we won't adjust and will just output a warning

if sum(ii_cfg.sel)==0
    error('iEye:ii_calibratebytrial:noSelections', 'No timepoints selected! Try ii_selectfixationsbytrial');
end


if ~iscell(chan_names)
    chan_names = {chan_names};
end

% CLEAN INPUTS

% do channels exist?
for cc = 1:length(chan_names)
    if ~ismember(chan_names{cc},fieldnames(ii_data))
        error('iEye:ii_calibratebytrial:invalidChannel', 'Channel %s not found',chan_names{cc});
    end
end


if ~iscell(calib_targets) && ischar(calib_targets)
    calib_targets = {calib_targets};
end

if nargin < 6 || isempty(adj_limit)
    adj_limit = inf;
end

% make sure only a single number provided and it's positve (distance)
if length(adj_limit)~=1||adj_limit<0
    error('iEye:ii_calibratebytrial:invalidAdjLimit','Adjustment limits specified in dva distance, so one single positive number required');
end

% check calibration targets 
% numeric inputs can be either indices into ii_cfg.trialinfo, or n_trials
% x n_channels values
if isnumeric(calib_targets)
    
    
    if numel(calib_targets)~=length(chan_names) && numel(calib_targets)~=(length(chan_names)*ii_cfg.numtrials)
        error('iEye:ii_calibratebytrial:invalidCalibTargets', 'For numeric calib_targets input, need either indices to ii_cfg.trialinfo columns, or one value per channel per row (n_trials x n_chans)');
    end
    
    % if there are n_chans numbers, make sure they're integers AND that
    % they're in range of ii_cfg.trialinfo AND that ii_cfg.trialinfo
    % exists...
    
    if numel(calib_targets)==length(chan_names)
        % this one requires trialinfo be present
        if ~ismember('trialinfo',fieldnames(ii_cfg))
            error('iEye:ii_calibratebytrial:invalidCalibTargets', 'For numeric calib_targets input, must have trialinfo installed (run ii_addtrialinfo)');
        end
        if max(calib_targets) > size(ii_cfg.trialinfo,2)
            error('iEye:ii_calibratebytrial:invalidCalibTargets', 'calib_targets out of range for ii_cfg.trialinfo (calib_targets: %s, trialinfo dims: %s)',num2str(calib_targets),num2str(size(ii_cfg.trialinfo)));
        end
    end
    
    if numel(calib_targets)==(length(chan_names)*ii_cfg.numtrials)
        % these are harder to check... (I think have to make sure not
        % zero?)
    end
    
% cell inputs can either be all strings, or cell of vectors each n_trials
% long
elseif iscell(calib_targets) 
    if sum(cellfun(@ischar,calib_targets))==length(calib_targets)        
        if sum(ismember(calib_targets,fieldnames(ii_data)))~=length(calib_targets)
            error('iEye:ii_calibratebytrial:invalidCalibTargets', 'For cell array of strings as calib_targets input, all cells must match field names in ii_data');
        end
    elseif sum(cellfun(@length,calib_targets)==ii_cfg.numtrials)~=length(calib_targets)        
        % error: missing 
        error('iEye:ii_calibratebytrial:invalidCalibTargets', 'For cell array of numeric calib_targets input, all cells must have numtrials elements');        
    else
        % general error
        error('iEye:ii_calibratebytrial:invalidCalibTargets', 'Invalid cell array of calib_targets');
    end   
else
    % invalid input (not numeric, or a cell of chan names)
    error('iEye:ii_calibratebytrial:invalidCalibTargets', 'Invalid input for calibration targets. Must be cell array of strings matching length of chan_names, list of trialinfo column indices matching length of chan_names, matrix with number of columns matching length of chan_names, or cell with length(chan_names) entries, each with one row per trial');
    
end


% check calib_mode is in expected list
if ~ismember(calib_mode,{'scale','rotate'})
    error('iEye:ii_calibratebytrial:invalidCalibMode', 'Calibration mode %s invalid, expected to be scale or rotate',calib_mode);
end


% check if .calibrate field already present, warn that you may be
% double-calibrating
if ismember('calibrate',fieldnames(ii_cfg))
    warning('iEye:ii_calibratebytrial:alreadyCalibrated','CALIBRATE field already present in ii_cfg; will overwrite!');
end


tu = unique(ii_cfg.trialvec(ii_cfg.trialvec~=0));


% get coords to calibrate to
calibrate_to = nan(ii_cfg.numtrials,length(chan_names));

% if cell, could either be strings or numerics
if iscell(calib_targets)
    % if each element of calib_targets is a string:
    if sum(cellfun(@ischar,calib_targets))==length(calib_targets)
        
        for cc = 1:length(calib_targets)
            for tt = 1:length(tu)
                
                tr_idx = ii_cfg.trialvec==tu(tt);
                
                calibrate_to(tt,cc) = mean(ii_data.(calib_targets{cc})(ii_cfg.sel&tr_idx));
                
            end
        end
    % if each cell is numeric & a vector (checked above)
    elseif sum(cellfun(@isnumeric,calib_targets))==length(calib_targets)
       
        for cc = 1:length(calib_targets)
            calibrate_to(:,cc) = calib_targets{cc};
        end
    end

% if there are just indices into ii_cfg.trialinfo or a matrix of coords
elseif isnumeric(calib_targets)
    % if just indices
    if numel(calib_targets)==length(chan_names)
        
        for cc = 1:length(calib_targets)
            calibrate_to(:,cc) = ii_cfg.trialinfo(:,calib_targets(cc));
        end
        
    % if all trial calibration targets
    elseif size(calib_targets,1)==ii_cfg.numtrials && size(calib_targets,2)==length(chan_names)
        calibrate_to = calib_targets;
    end
end

all_fields = fieldnames(ii_data);
all_fields = {all_fields{~strcmpi(all_fields,'XDAT')}};

ii_cfg.calibrate.fcn = 'ii_calibratebytrial.m';
ii_cfg.calibrate.chan = chan_names; % channels input to ii_driftcorrect
ii_cfg.calibrate.mode = calib_mode;
ii_cfg.calibrate.amt = nan(ii_cfg.numtrials,length(chan_names));
ii_cfg.calibrate.err = nan(ii_cfg.numtrials,1);
ii_cfg.calibrate.adj_limits = adj_limit;
ii_cfg.calibrate.adj = zeros(ii_cfg.numtrials,1)==1; % whether adjustment was performed on this trial

% add indicator(s) for why a trial wasn't adjusted
ii_cfg.calibrate.excl_info = cell(ii_cfg.numtrials,1); % fill this in with information about why a trial was excluded
% codes:
% - 1: no selected timepoints
% - 2: at least one channel out of range


if strcmpi(calib_mode,'scale')

    
    % FIRST: compute amount to adjust    
    for tt = 1:length(tu)
        this_err = nan(length(chan_names),1);
        
        for cc = 1:length(chan_names)
            
            % get timepoints for this trial
            tr_idx = ii_cfg.trialvec==tu(tt);
            
            % make sure there's a selection within this trial
            if sum(ii_cfg.sel & tr_idx) > 0
                
                % for this channel, compute ratio of measured chan_pos to
                % expected chan_pos (calibrate_to), will divide each
                % chans_to_adjust within trial by this value
                adj_by = nanmean(ii_data.(sprintf('%s_fix',chan_names{cc}))(tr_idx & ii_cfg.sel) )/calibrate_to(tt,cc);
                
                % difference fix - targ
                this_err(cc) = nanmean(ii_data.(sprintf('%s_fix',chan_names{cc}))(tr_idx & ii_cfg.sel) ) - calibrate_to(tt,cc); 
                
            else
                
                warning('iEye:ii_calibratebytrial:noSelectedTimepoints','Trial %i: no selected timepoints; forgoing calibration\n',tu(tt));
                adj_by = NaN;
                ii_cfg.calibrate.excl_info{tt}(end+1) = 1;
            end
            
            % save the ratio used for calibration
            % (NOTE: still save, even if we don't actually apply this!!!)
            ii_cfg.calibrate.amt(tt,cc) = adj_by;
            
            
            clear adj_by;
        end
        
        ii_cfg.calibrate.err(tt) = sqrt(sum(this_err.^2));
        clear this_err;
    
    end
    
    % THEN, MAKE SURE THOSE ARE IN 'NORMAL' RANGE (for ALL channels), and
    % adjust if necessary
    
    for cc = 1:length(chan_names)
    
        % get all channels we want to apply adjustment to (e.g., X_smooth,
        % X_fix if adjusting X. Will also implement "child" channels in
        % ii_cfg...
        chans_to_adjust = { all_fields{ cellfun(@(x) any(x) && x(1)==1 , strfind(all_fields,chan_names{cc} )) } };

        for tt = 1:length(tu)
            
            % get timepoints for this trial
            tr_idx = ii_cfg.trialvec==tu(tt);
            
                % only perform adjustment if ALL channels are within spec
                if ii_cfg.calibrate.err(tt) <= adj_limit && ii_cfg.calibrate.err(tt) > eps % only calibrate if within distnace, but > 0 
                
                % only perform adjustment if, across channels, the error is
                % within spec (ii_cfg.calibrate.err(tt) <= adj_limits)
                    for ca = 1:length(chans_to_adjust)
                        % adjust entire trial (scale) so that selection is
                        % equal to calibrate_to
                        ii_data.(chans_to_adjust{ca})(tr_idx)=ii_data.(chans_to_adjust{ca})(tr_idx)./ii_cfg.calibrate.amt(tt,cc);
                    end
                    
                    ii_cfg.calibrate.adj(tt) = 1==1;
                   
                else
                    if ii_cfg.calibrate.err(tt) >= adj_limit
                        ii_cfg.calibrate.excl_info{tt}(end+1)=2;
                    else
                        ii_cfg.calibrate.excl_info{tt}(end+1)=3; % no adj after feedback
                    end
                end
    
        end
    
    end
    
    
elseif strcmpi(calib_mode,'rotate')
% if rotate, check that there's a xchannel and a ychannel, and assign
% appropriately
    error('iEye:ii_calibratebytrial:unsupportedCalibMode','Sorry, rotate mode not supported quite yet - stay tuned!');
        
end

end