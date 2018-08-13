function [ii_data,ii_cfg] = ii_calibratebyrun(ii_data,ii_cfg, chan_names, calib_targets, poly_deg, fit_limit )
%II_CALIBRATEBYRUN Adjust gaze coords across a run so that gaze is best-matched,
%on average, to a known value at a known period of trial.
%   Differs from ii_calibratebytrial: fits a polynomial individually to
%   each channel to best match observed and desired coordiante and applies
%   transform to all timepoints across all trials. Typically trial-wise
%   drift correction is done before this step.
%
%   One selection expected per trial, and either channels, column indices
%   to ii_cfg.trialinfo, or n_trials length vectors, to which the full
%   trial timeseries is warped.
%   POLY_DEG is the degree of polynomial used for readjustment. By default,
%   cubic polynomial (degree = 3) is used. 
%   FIT_LIMIT is the maximum allowable error, in dva, between the selected
%   fixation and the calib_target on that trial, in euclidean distance, for
%   a trial to be included in the FIT step (estimating the recalibration
%   function). All trials will be adjusted based on the single run-wise
%   recalibration function. By default, inf, so all trials included.
%
% Note: it's helpful to have run driftcorrect before this so that
% 'fixation' values are set to 0,0, and so scaling doesn't substantially
%  alter mean fixation
%
% Channels defined in CHAN_NAMES are ASSUMED to have a corresponding
% fixation channel. (TODO: be robust to this...)
%
% Purpose of this version of calibration is to deal with somewhat
% substantial number of trials without a corrective saccade to visual
% target re-presentation during feedback, which previously resulted in
% 0-dva MGS error metrics for some subj.
%
% Initial version of this function used only target points & measured
% 'feedback' fixations to re-calibrate - but this could often result in a
% fixation shift (undoing drift correction) applied to entire timeseries.
% As a first pass at a solution, we'll add n_trials 0's to x & y to try to
% stabilize the fit (this is similar to the Mackey et al version).
%
% NOTE: does not scale velocity!!! this may take some work...
%
% 

% Tommy Sprague, 8/2/2018 



% make sure trials have been defined, and there's a selection for every
% trial
if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_calibratebyrun:noTrialsDefined', 'Trials not defined; run ii_definetrials.m first');
end

% TODO:
% as we loop over trials, if a selection is missing within a trial we won't adjust and will just output a warning

if sum(ii_cfg.sel)==0
    error('iEye:ii_calibratebyrun:noSelections', 'No timepoints selected! Try ii_selectfixationsbytrial');
end

% DEFAULT VALUES

% if no channels pre-defined, use X,Y
if nargin <3 || isempty(chan_names)
    chan_names = {'X','Y'};
end

% if no calib targets defined, assume TarX, TarY (will be checked below..)
if nargin < 4 || isempty(calib_targets)
    calib_targets = {'TarX','TarY'};
end

if nargin < 5 || isempty(poly_deg)
    poly_deg = 3;
end


% CLEAN INPUTS

if ~iscell(chan_names)
    chan_names = {chan_names};
end

% do channels exist?
for cc = 1:length(chan_names)
    if ~ismember(chan_names{cc},fieldnames(ii_data))
        error('iEye:ii_calibratebyrun:invalidChannel', 'Channel %s not found',chan_names{cc});
    end
end


if ~iscell(calib_targets) && ischar(calib_targets)
    calib_targets = {calib_targets};
end

if nargin < 6 || isempty(fit_limit)
    fit_limit = inf;
end

% make sure only a single number provided and it's positve (distance)
if length(fit_limit)~=1||fit_limit<0
    error('iEye:ii_calibratebyrun:invalidFitLimit','Fit inclusion limit specified in dva distance, so one single positive number required');
end

% check calibration targets 
% numeric inputs can be either indices into ii_cfg.trialinfo, or n_trials
% x n_channels values
if isnumeric(calib_targets)
    
    
    if numel(calib_targets)~=length(chan_names) && numel(calib_targets)~=(length(chan_names)*ii_cfg.numtrials)
        error('iEye:ii_calibratebyrun:invalidCalibTargets', 'For numeric calib_targets input, need either indices to ii_cfg.trialinfo columns, or one value per channel per row (n_trials x n_chans)');
    end
    
    % if there are n_chans numbers, make sure they're integers AND that
    % they're in range of ii_cfg.trialinfo AND that ii_cfg.trialinfo
    % exists...
    
    if numel(calib_targets)==length(chan_names)
        % this one requires trialinfo be present
        if ~ismember('trialinfo',fieldnames(ii_cfg))
            error('iEye:ii_calibratebyrun:invalidCalibTargets', 'For numeric calib_targets input, must have trialinfo installed (run ii_addtrialinfo)');
        end
        if max(calib_targets) > size(ii_cfg.trialinfo,2)
            error('iEye:ii_calibratebyrun:invalidCalibTargets', 'calib_targets out of range for ii_cfg.trialinfo (calib_targets: %s, trialinfo dims: %s)',num2str(calib_targets),num2str(size(ii_cfg.trialinfo)));
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
            error('iEye:ii_calibratebyrun:invalidCalibTargets', 'For cell array of strings as calib_targets input, all cells must match field names in ii_data');
        end
    elseif sum(cellfun(@length,calib_targets)==ii_cfg.numtrials)~=length(calib_targets)        
        % error: missing 
        error('iEye:ii_calibratebyrun:invalidCalibTargets', 'For cell array of numeric calib_targets input, all cells must have numtrials elements');        
    else
        % general error
        error('iEye:ii_calibratebyrun:invalidCalibTargets', 'Invalid cell array of calib_targets');
    end   
else
    % invalid input (not numeric, or a cell of chan names)
    error('iEye:ii_calibratebyrun:invalidCalibTargets', 'Invalid input for calibration targets. Must be cell array of strings matching length of chan_names, list of trialinfo column indices matching length of chan_names, matrix with number of columns matching length of chan_names, or cell with length(chan_names) entries, each with one row per trial');
    
end


% check if .calibrate field already present, warn that you may be
% double-calibrating
if ismember('calibrate',fieldnames(ii_cfg))
    warning('iEye:ii_calibratebyrun:alreadyCalibrated','CALIBRATE field already present in ii_cfg; will overwrite!');
end

% START PROCESSING!
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

% save record of how calibration was conducted
ii_cfg.calibrate.fcn = 'ii_calibratebyrun.m';
ii_cfg.calibrate.chan = chan_names; % channels input to ii_driftcorrect
ii_cfg.calibrate.amt = nan(ii_cfg.numtrials,length(chan_names)); % amount of adjustment in each channel per trial (computed via polyval)
ii_cfg.calibrate.err = nan(ii_cfg.numtrials,1); % pre-calibration distance between gaze & target
ii_cfg.calibrate.fit_limit = fit_limit;
ii_cfg.calibrate.adj = ones(ii_cfg.numtrials,1)==1; % whether adjustment was performed on this trial (for run-wise, all 1's!!!)
ii_cfg.calibrate.poly_deg = poly_deg;
ii_cfg.calibrate.poly_fun = nan(length(chan_names),poly_deg+1); % n_chans x poly_deg
ii_cfg.calibrate.resid = nan(ii_cfg.numtrials,length(chan_names));

% add indicator(s) for why a trial wasn't adjusted
ii_cfg.calibrate.excl_info = cell(ii_cfg.numtrials,1); % fill this in with information about why a trial was excluded
% codes:
% - 1: no selected timepoints
% - 2: at least one channel out of range


% look up the gaze coordinate on each trial

trial_coord = nan(ii_cfg.numtrials,length(chan_names)); % n_trials x x_chans

% FIRST: compute amount to adjust
for cc = 1:length(chan_names)
    for tt = 1:length(tu)
        %this_err = nan(length(chan_names),1);
    
        % get timepoints for this trial
        tr_idx = ii_cfg.trialvec==tu(tt);
        
        % make sure there's a selection within this trial
        if sum(ii_cfg.sel & tr_idx) > 0
            
            % compute gaze coord on this trial using chan_names_fix
            trial_coord(tt,cc) = nanmean(ii_data.(sprintf('%s_fix',chan_names{cc}))(tr_idx & ii_cfg.sel) );

        else
            
            warning('iEye:ii_calibratebytrial:noSelectedTimepoints','Trial %i: no selected timepoints; forgoing calibration\n',tu(tt));
            %adj_by = NaN;
            ii_cfg.calibrate.excl_info{tt}(end+1) = 1;
        end
        
        
    end
    
    
end

% save trial-by-trial error
ii_cfg.calibrate.err = sqrt( sum( (trial_coord - calibrate_to).^2 ,2) ); % sqrt(sum(this_err.^2));


% ok - now we have the calibration targets numerically defined, let's fit a
% function to the gaze coordinate on each trial to these positions

% which trials do we use to fit?
trials_to_use = ii_cfg.calibrate.err <= fit_limit; % TODO: also binary censor?

for cc = 1:length(chan_names)
    
    % to anchor the function to the origin (but not enforce a perfect
    % origin), we'll add a bunch of 0,0's to the data to be fit (same # as
    % trials used for fitting the recalibration function). This is
    % appoximately similar to the original Mackey et al version of
    % polynomial recalibration in the original iEye, but in this case we
    % 'know' the eye coordinate should be 0, and aren't allowing for the
    % pre-saccade coordinate to go into the fit function. I think this is a
    % fair and clean assumption given that we've done drift correction
    % already (a pre-requisite for running this function...)
    thisx = [trial_coord(trials_to_use,cc);  zeros(sum(trials_to_use),1)];
    thisy = [calibrate_to(trials_to_use,cc); zeros(sum(trials_to_use),1)];
    %poly_coeffs = polyfit(trial_coord(trials_to_use,cc),calibrate_to(trials_to_use,cc),poly_deg);
    poly_coeffs = polyfit(thisx,thisy,poly_deg);
    
    ii_cfg.calibrate.poly_fun(cc,:) = poly_coeffs;
    
    % update this (and child) channels using polyval        
    
    chans_to_adjust = { all_fields{ cellfun(@(x) any(x) && x(1)==1 , strfind(all_fields,chan_names{cc} )) } };
    for chidx = 1:length(chans_to_adjust)
        ii_data.(chans_to_adjust{chidx}) = polyval(poly_coeffs,ii_data.(chans_to_adjust{chidx}));
    end

    % to keep things consistent w/ ii_calibratebytrial, use ratio of target
    % to orig
    ii_cfg.calibrate.amt(:,cc) = polyval(poly_coeffs,trial_coord(:,cc))./trial_coord(:,cc);
    
    % also save residuals for each trial - after adjustment, how much error
    % left?
    ii_cfg.calibrate.resid(:,cc) = calibrate_to(:,cc) - polyval(poly_coeffs,trial_coord(:,cc));
    
    clear poly_coeffs chans_to_adjust thisx thisy;
end


return
