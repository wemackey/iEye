function [ ii_data, ii_cfg ] = ii_calibratebytrial( ii_data, ii_cfg, chan_names, calib_targets, calib_mode )
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
%
% Note: it's helpful to have run driftcorrect before this so that
% 'fixation' values are set to 0,0, and so scaling doesn't substantially
%  alter mean fixation
%
% May also make a calibrateacrosstrials.m version which applies similar
% polynomial fitting/adjustment as previous versions of iEye
% (ii_calibrateto.m). This version attempts to fix each trial individually
% without regard for stability across positions over a run. 
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

% check calibration targets 
% 1. are they numeric?
if isnumeric(calib_targets)
    
    if numel(calib_targets)~=length(chan_names) && numel(calib_targets)~=(length(chan_names)*ii_cfg.numtrials)
        error('iEye:ii_calibratebytrial:invalidCalibTargets', 'For numeric calib_targets input, need either indices to ii_cfg.trialinfo columns, or one value per channel per row (n_trials x n_chans)');
    end
    
    % if there are n_chans numbers, make sure they're integers AND that
    % they're in range of ii_cfg.trialinfo AND that ii_cfg.trialinfo
    % exists...
    
    
else 
    
   % are they cells? if not (and if string), make a cell
   if ~iscell(calib_targs) && ischar(calib_targets)
       calib_targets = {calib_targets};
       
       %check that these channels are defined
       
   else
       % invalid input (not numeric, or a cell of chan names)
       error('iEye:ii_calibratebytrial:invalidCalibTargets', 'Invalid input for calibration targets. Must be cell array of strings matching length of chan_names, list of trialinfo column indices matching length of chan_names, matrix with number of columns matching length of chan_names, or cell with length(chan_names) entries, each with one row per trial');

       
   end
    
    
end


% check calib_mode is in expected list




end

