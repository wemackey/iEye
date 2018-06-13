% example_analysis.m
%
% example analysis script for example fMRI dataset (exfmri*.edf)
%
% Here's an example data analysis script that walks from raw EDFs for a
% single-item WM task conducted in the scanner (12 s delay interval)
% through preprocessing, saccade extraction, MGS scoring, QC plotting, and
% some basic analyses/plots
%
% Tommy Sprague, 6/12/2018 - subj CC from MGSMap (sess 1, runs 1-3)


% very first thing we want to do is define all parameters for processing
% (see ii_loadparams.m for default values)

ifg_fn = '/Volumes/tommy/Documents/MATLAB/toolboxes_dev/iEye_ts/examples/p_500hz.ifg';


ii_params = ii_loadparams; % load default set of analysis parameters, only change what we have to

ii_params.trial_end_value = 6;   % XDAT value for trial end
ii_params.drift_epoch = [1 2 3]; % XDAT values for drift correction
ii_params.calibrate_epoch = 5;   % XDAT value for when we calibrate (feedback stim)
ii_params.calibrate_select_mode = 'nearest'; % how do we select fixation with which to calibrate?
ii_params.blink_window = [200 200]; % how long before/after blink (ms) to drop?
ii_params.plot_epoch = [3 4 5];  % what epochs do we plot for preprocessing?
ii_params.calibrate_limits = [0.75 1.333]; % when amount of adj exceeds this, don't actually calibrate

ii_params.ppd = 31.8578; % for scanner, 1280 x 1024 - convert pix to DVA

% all files we want to load are exfmri_r??.mat - so let's list them (we
% know they're in the same directory as this script)
tmp = mfilename('fullpath'); tmp2 = strfind(tmp,filesep);
root = tmp(1:(tmp2(end)-1));

edf_files = dir(fullfile(root,'exfmri*.edf'));

% create empty cell array of all our trial data for combination later on
ii_trial = cell(length(edf_files),1);

for ff = 1:length(edf_files)
    
    % what is the output filename?
    preproc_fn = sprintf('%s/%s_preproc.mat',edf_files(ff).folder,edf_files(ff).name(1:(end-4)));
    
    
    % run preprocessing!
    [ii_data, ii_cfg, ii_sacc] = ii_preproc(fullfile(edf_files(ff).folder,edf_files(ff).name),ifg_fn,preproc_fn,ii_params);
    
    if ff == 1
        % plot some features of the data
        % (check out the docs for each of these; lots of options...)
        ii_plottimeseries(ii_data,ii_cfg); % pltos the full timeseries
        
        ii_plotalltrials(ii_data,ii_cfg); % plots each trial individually
        
        ii_plotalltrials2d(ii_data,ii_cfg); % plots all trials, in 2d, overlaid on one another w/ fixations
    end
    
    % score trials
    % default parameters should work fine - but see docs for other
    % arguments you can/should give when possible
    [ii_trial{ff},ii_cfg] = ii_scoreMGS(ii_data,ii_cfg,ii_sacc); 
    
end

ii_sess = ii_combineruns(ii_trial);

%% look at the processed data, make sure it looks ok

% based on what criteria shoudl we exclude trials?
which_excl = [11 13 20 21];

% first, plot an exclusion report over all runs
% - this will open a few figures. first one will be a 'dot plot', which
%   shows all exclusion criteria exceeded for a given trial by plotting a dot
%   above that criterion. if any dot for a trial is red, we're going to throw that
%   trial away. if black, we'll ignore that criterion for now.
% - second, plots a summary graph, showing % of trials excluded due to each
%   criterion, and how many overall will be excluded. If plotting
%   run-concatenated data, also show how this varies across runs
ii_plotQC_exclusions(ii_sess,ii_cfg,which_excl);

% second, plot every trial, scored - this will overlay the primary saccade
% (purple), final saccade (if one; green) on the raw channel traces for
% each trial. the trial # indicator will indicate whether we shoudl
% consider the trial carefully: if italics, at least one exclusion
% criterion reached. If red, we exclude trial based on a criterion. After
% the trial number, there are several letters indicating which, if any,
% exclusion criteria were passed, and an asterisk says whether that one was
% used to exclude. 
% - d: drift correction
% - c: calibration
% - fb: fixation break
% - ei: iniital saccade error
% - xi: no initial saccade detected within response window
% - bi: bad initial saccade (duration/amplitude outside range)
% Also plotted is the response window (vertical gray lines) and the target
% position (horizontal dashed lines)
ii_plotQC_alltrials(ii_sess,ii_cfg,which_excl);