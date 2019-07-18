function [ ii_params ] = ii_loadparams( params_fn )
%ii_loadparams Load pre/processing parameters
%   To use automated pre-processing function ii_preproc, must define a set
%   of params for each stage of pre/processing. If no params_fn given, then
%   default parameters will be loaded.
%
% Edit this function to update default parameters for your setup (or you
% could modify this to load a default_params.mat file - but seems easier to
% read putting it in a text file like this)
%
% TODO: add flags for whether or not to run each piece of preproc? maybe
% better in a 'flags' suffix of ii_preproc.m...

% Tommy Sprague, 8/21/2017


if nargin < 1
    
    % DEFAULT PARAMETER VALUES
    
    % epoch channel
    ii_params.epoch_chan = 'XDAT';
    
    % epochs to keep
    ii_params.valid_epochs = NaN; % if NaN, don't trim
    
    % stimulus display information
    ii_params.resolution = [1280 1024]; % Curtis lab, behavior room
    ii_params.ppd = 34.1445;            % Curtis lab, behavior room (pix/deg)
    
    % blink correction
    ii_params.blink_thresh = 1.5;    % PERCENTILE!!! 
    ii_params.blink_window = [150 50]; % before and after, ms
    
    % trial definition
    ii_params.trial_start_chan  = ii_params.epoch_chan;
    ii_params.trial_start_value = 1;
    ii_params.trial_end_chan    = ii_params.epoch_chan;
    ii_params.trial_end_value   = 8;
    
    % smoothing
    ii_params.smooth_type = 'Gaussian';
    ii_params.smooth_amt  = 5;
    
    % saccade detection
    ii_params.sacc_velocity_thresh = 30;    % deg/s
    ii_params.sacc_duration_thresh = 0.0075; % s
    ii_params.sacc_amplitude_thresh = 0.25; % deg
    
    
    % microsaccade detection
    ii_params.microsacc_velocity_thresh = 30;    % deg/s
    ii_params.microsacc_duration_thresh = 0.0075; % s
    ii_params.microsacc_amplitude_limit = 1.5; % deg; want to collect all ms less than this 
    
    % fixation detection (mode for computing fixations)
    ii_params.fixation_mode = 'mean';
    
    % drift correction
    ii_params.drift_epoch = [1 2];  % which epochs to use?
    ii_params.drift_fixation_mode  = 'mode'; % how to choose which fixation?
    ii_params.drift_select_mode    = 'fixation'; % use fixation, or mean over previous epoch?
    ii_params.drift_target = [0 0]; % where to correct to
    
    % calibrate to feedback stim
    ii_params.calibrate_epoch = 7;
    ii_params.calibrate_select_mode = 'last';
    ii_params.calibrate_window = 100; % ms, before end of epoch in case there are premature saccades
    ii_params.calibrate_target = {'TarX','TarY'}; % 4th arg to ii_calibratebytrial
    ii_params.calibrate_mode = 'scale'; % or rotate (for trial-wise); 'run' for run-wise
    ii_params.calibrate_limits = 2.5; % or [Inf]; - when final fixation during feedback further than this far from targ, don't calibrate (or, for run-wise, don't use for fitting)
    ii_params.calibrate_deg = 3; % for run-wise (not used for trial-wise)
    
    % plotting params
    ii_params.plot_epoch = [];
    ii_params.show_plots = 0; % whether figures are visible when ii_preproc is run (still saved out)
    
    
    % saccade extraction params
    ii_params.extract_sacc_mode_start = 'fixation';
    ii_params.extract_sacc_mode_end   = 'fixation';
    
    
else
    
    ii_params = load(params_fn);
    
    % handle case where saved as ii_params w/in file
    if ismember('ii_params',fieldnames(ii_params))
        ii_params = ii_params.ii_params;
    end
       
end


end

