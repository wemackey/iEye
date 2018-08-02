% Generic script for pre-processing memory-guided saccade data using
% updated iEye_ts.
%
% NOTE: see example_analysis.m and ii_preproc.m! this is DEPRECATED
% (TCS 8/2/2018)
%
% For preprocessing saccade data (specifically, memory-guided saccade
% data), we do:
% 01. setup iEye and import our file
% 02. rescale the data given our known screen resolution, viewing distance,
% etc (pixels per degree is required)
% 03. invert the y-channel, which is measured in screen coords (+ is down)
% 04. identify and remove blinks
% 04b (not yet implemented) clean gaze channels if bad values found
% 05. use the 'XDAT' (epoch) channel to define trials
% 06. compute smoothed versions of gaze channels using a Gaussian kernel
% 07. use smoothed gaze channels to compute velocity
% 08. use velocity channel to find saccades, and filter those saccades based
% on distance, velocity, and duration thresholds
% 09. identify periods of stable fixation between saccades
% 10. select stable fixations during pre-target epoch (used to drift
% correct)
% 11. use stable fixations to drift correct to known fixation coord (0,0)
% to account for signal drift over runs in eyetracking data
% 12. add behavioral data to iEye data struct (ii_cfg)
% 13. select stable fixation at end of feedback stimulus
% 14. use this fixation to further calibrate gaze data to known target
% position. 
% 15. plot all individual trials for QC purposes, save a figure
% 16. save the data (will contain ii_data, ii_cfg - the important variables
% containing full preprocessed time-series with appropriate labels, etc)
%
% At the end of this script, ii_data and ii_cfg will be ready to use for
% scoring saccades. User will still need to identify which saccades are
% relevant (using other iEye functions), and compare those to known
% positions (note that, with ii_calibratebytrial, this is much easier).
% Several new channels are created: X_smooth, Y_smooth, X_fix, Y_fix, as
% well as a bunch of 'selection' channels in ii_cfg (trialvec, tsel,
% saccades, blinks). This pair of data structures can/should be used with
% the new ii_plot* functions: ii_plottrial, ii_plotalltrials, and
% ii_plotalltrials2d (among others on their way). 
%
% This script is a rough approximation of what's in ii_preproc.m, which
% applies this procedure to a given file, eventually, w/ some
% verbose argument parsing... 
%
% NOTE: this is just a template, which will work for the data examples
% included in iEye. all thresholds, epochs, and especially trialinfo will
% need to be customized to each experiment

% based off script used by GH
% Tommy Sprague, 8/18/2017


edf_fn = 'examples/exdata1.edf';
mat_fn = 'examples/exdata1_trialinfo.mat';



% initialize iEye - make sure paths are correct, etc
ii_init;

% import data
[ii_data,ii_cfg] = ii_import_edf(edf_fn,'examples/p_1000hz.ifg',[edf_fn(1:end-3) 'mat']);

% Show only the channels we care about at the moment
%ii_view_channels('X,Y,TarX,TarY,XDAT');

% rescale X, Y based on screen info
[ii_data,ii_cfg] = ii_rescale(ii_data,ii_cfg,{'X','Y'},[1280 1024],34.1445);



% Invert Y channel (the eye-tracker spits out flipped Y values)
[ii_data,ii_cfg] = ii_invert(ii_data,ii_cfg,'Y');

% Correct for blinks

% trying a different threshold - 150 samples before, 50 after
[ii_data, ii_cfg] = ii_blinkcorrect(ii_data,ii_cfg,{'X','Y'},'Pupil',1500,150,50); % maybe 50, 50? %altering this 6/1/2017 from 1800 in both x/y 


% split into individual trials (so that individual-trial corrections can be
% applied)
[ii_data,ii_cfg] = ii_definetrial(ii_data,ii_cfg,'XDAT',1,'XDAT',8); % CHECK THIS!


% Smooth data
[ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,{'X','Y'},'Gaussian',5);


% compute velocity using the smoothed data
[ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg,'X_smooth','Y_smooth');


% below - need to document still....

% look for saccades [[NOTE: potentially do this twice? once for macro, once
% for micro?]]
[ii_data,ii_cfg] = ii_findsaccades(ii_data,ii_cfg,'X_smooth','Y_smooth',30,.0075,0.25); 



% find fixation epochs (between saccades and blinks)
% [create X_fix, Y_fix channels? these could be overlaid with 'raw' data as
% 'stable' eye positions
[ii_data,ii_cfg] = ii_findfixations(ii_data,ii_cfg,{'X','Y'},'mean');



% select the last fixation of pre-target epochs
[ii_data,ii_cfg] = ii_selectfixationsbytrial( ii_data, ii_cfg, 'XDAT', [1 2], 'mode' );

% use those selections to drift-correct each trial (either using the
% fixation value, which may include timepoints past end of epoch, or using
% 'raw' or 'smoothed' data on each channel)
%[ii_data,ii_cfg] = ii_driftcorrect(ii_data,ii_cfg,{'X','Y'},[1 2],'last_fixation',[0 0]);
[ii_data,ii_cfg] = ii_driftcorrect(ii_data,ii_cfg,{'X','Y'},'fixation',[0 0]);
% NOTE: in example data, trial 20 still not perfect - maybe use 'mode'
% fixation in selectfixationsbytrial? 


% add trial info [not explicitly necessary if simple experiment, TarX &
% TarY fields used as before]
%
% trial_info should be n_trials x n_params/features - can be indexed in
% some data processing commands below. can be cell or array. 

mydata = load(mat_fn);

% Col1: queried X
% Col2: queried Y
% Col3: non-queried X
% Col4: non-queried Y
% Col5: priority condition
trial_info = horzcat(mydata.stimulus.targCoords{:});
cond = [];
for bb = 1:length(mydata.task{1}.block)
    cond = [cond; mydata.task{1}.block(bb).parameter.conditionAndQueriedTarget.'];
end
trial_info = [trial_info cond];
clear mydata;
[ii_data,ii_cfg] = ii_addtrialinfo(ii_data,ii_cfg,trial_info);



% 'target correct' or 'calibrate' (which name is better?)
% adjust timeseries on a trial so that gaze at specified epoch (quantified
% w/ specified method, like driftcorrect) is at known coords (either given
% by a channel or a pair of cols in ii_cfg.trialinfo

% first, select relevant epochs (should be one selection per trial)
[ii_data,ii_cfg] = ii_selectfixationsbytrial(ii_data,ii_cfg,'XDAT',7,'last',100); % 

% then, calibrate by trial
% ii_calibratebytrial.m
[ii_data,ii_cfg] = ii_calibratebytrial(ii_data,ii_cfg,{'X','Y'},{'TarX','TarY'},'scale');


% plot all these - make sure they're good
f_all = ii_plotalltrials(ii_data,ii_cfg);

% save the figures for our records
if length(f_all)>1
    for ff = 1:lenght(f_all)
        saveas(f_all,sprintf('%s_iEye_preproc_%02.f.png',ii_cfg.edf_file(1:end-4),ff),'png');
    end
else
    saveas(f_all,sprintf('%s_iEye_preproc.png',ii_cfg.edf_file(1:end-4)),'png');
end

% save ii_data,ii_cfg in _preproc.mat file
ii_savedata(ii_data,ii_cfg,sprintf('%s_iEye_preproc.mat',ii_cfg.edf_file(1:end-4)));


