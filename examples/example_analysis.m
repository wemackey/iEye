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

ifg_fn = '~/Documents/MATLAB/toolboxes_dev/iEye_ts/examples/p_500hz.ifg';


ii_params = ii_loadparams; % load default set of analysis parameters, only change what we have to

ii_params.trial_end_value = 6;   % XDAT value for trial end
ii_params.drift_epoch = [1 2 3]; % XDAT values for drift correction
ii_params.calibrate_epoch = 5;   % XDAT value for when we calibrate (feedback stim)
ii_params.calibrate_select_mode = 'last'; % how do we select fixation with which to calibrate?
ii_params.blink_window = [200 200]; % how long before/after blink (ms) to drop?
ii_params.plot_epoch = [3 4 5];  % what epochs do we plot for preprocessing?
ii_params.calibrate_limits = [2.5]; % when amount of adj exceeds this, don't actually calibrate

ii_params.ppd = 31.8578; % for scanner, 1280 x 1024 - convert pix to DVA

% all files we want to load are exfmri_r??.mat - so let's list them (we
% know they're in the same directory as this script)
tmp = mfilename('fullpath'); tmp2 = strfind(tmp,filesep);
root = tmp(1:(tmp2(end)-1));

edf_prefix = 'exfmri';
edf_files = dir(fullfile(root,sprintf('%s*.edf',edf_prefix)));

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
fh_excl = ii_plotQC_exclusions(ii_sess,ii_cfg,which_excl);

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
fh_trial = ii_plotQC_alltrials(ii_sess,ii_cfg,which_excl);

% often, it's useful to save these out as pngs:
for ff = 1:length(fh_excl)
    fn2s = sprintf('%s/%s_QC_excl_%02.f.png',edf_files(1).folder,edf_prefix,ff);
    saveas(fh_excl(ff),fn2s);
end

for ff = 1:length(fh_trial)
    fn2s = sprintf('%s/%s_QC_trial_%02.f.png',edf_files(1).folder,edf_prefix,ff);
    saveas(fh_trial(ff),fn2s);
end

%% now some very basic analysis recipes 
%  (RT histogram, all traces, and distribution of endpoints, etc)
%  below can be considered examples for how to plot a few typical
%  single-subj analyses of eye position data. Notice that the bulk of the
%  work has been done already (mostly in ii_score, but also in preproc,
%  etc). This makes our job very easy - just sorting, subplotting, etc. We
%  don't have different conditions in this experiment, so I sorted one of
%  the analyses by 'run' - this could easily be a condition variable that's
%  embedded within ii_sess.trialinfo instead. All the same logic applies.
%  Feel free to borrow from these recipies when conducting your own
%  analyses.



% decide which trials we want to include for analyses:
% - drop any trials that fail the which_excl test
% - make sure we're not using trials with faster than 100 ms RT

% check trial exclusions
use_trial = ~cellfun( @any, cellfun( @(a) ismember(a, which_excl), ii_sess.excl_trial, 'UniformOutput',false));

% check RT
use_trial(ii_sess.i_sacc_rt < 0.1) = 0;

% see how many trials we're keeping
fprintf('Analyzing %0.03f%% of trials\n',mean(use_trial)*100);

% FIRST: plot RT histogram
figure;
histogram(ii_sess.i_sacc_rt(use_trial==1),10);
xlabel('Response time (s)');
xlim([0 0.7]); % 700 ms is longest allowed RT


% SECOND: plot all traces for primary, final saccade for each run
figure;
ru = unique(ii_sess.r_num); % get run #'s

for rr = 1:length(ru)
    subplot(1,length(ru),rr); hold on;
    
    % only grab trials we'll use
    thisidx = find(ii_sess.r_num==ru(rr) & use_trial==1);
    mycolors = lines(length(thisidx)); % color for each trial
    
    for tt = 1:length(thisidx)
        
        % plot trace(s) & endpoint(s)
        plot(ii_sess.i_sacc_trace{thisidx(tt)}(:,1),ii_sess.i_sacc_trace{thisidx(tt)}(:,2),'-','LineWidth',1.5,'Color',mycolors(tt,:));
        plot(ii_sess.i_sacc_raw(thisidx(tt),1),ii_sess.i_sacc_raw(thisidx(tt),2),'ko','MarkerFaceColor',mycolors(tt,:),'MarkerSize',5);
        if ~isempty(ii_sess.f_sacc_trace{thisidx(tt)})
            plot(ii_sess.f_sacc_trace{thisidx(tt)}(:,1),ii_sess.f_sacc_trace{thisidx(tt)}(:,2),'-','LineWidth',1.5,'Color',mycolors(tt,:));
            plot(ii_sess.f_sacc_raw(thisidx(tt),1),ii_sess.f_sacc_raw(thisidx(tt),2),'kd','MarkerFaceColor',mycolors(tt,:),'MarkerSize',5);
        end
        
        % plot target
        plot(ii_sess.targ(thisidx(tt),1),ii_sess.targ(thisidx(tt),2),'x','LineWidth',2,'MarkerSize',8,'Color',mycolors(tt,:));
    end
    plot(0,0,'ks','MarkerFaceColor','k','MarkerSize',5); % fixation point
    xlim([-15 15]); ylim([-15 15]);
    axis square off;

    title(sprintf('Run %i',ru(rr)));
end

% btw, a *very* fast way to do a quick approximation of the above, at least
% for one set of traces, is:
% cellfun(@(c) plot(c(:,1),c(:,2), ii_sess.i_sacc_trace{use_trial==1});

% THIRD: plot aligned initial and final saccade endpoints
figure;
to_plot = {'i_sacc','f_sacc'}; % what fields do we want to plot?

for pp = 1:length(to_plot)
    subplot(length(to_plot),1,pp);
    hold on;
    
    % use scatter because it gives us translucent datapoints (revert to
    % plot if necessary)
    
    % flip y for every other quadrant so that up is towards vertical
    % meridian, down is towards horizontal
    tmpy = ii_sess.(to_plot{pp})(use_trial==1,2);
    thisflipidx = sign(ii_sess.targ(use_trial==1,1))~=sign(ii_sess.targ(use_trial==1,2));
    tmpy(thisflipidx) = -1*tmpy(thisflipidx);
    
    %scatter(ii_sess.(to_plot{pp})(use_trial==1,1),ii_sess.(to_plot{pp})(use_trial==1,2),20,mycolors(pp,:),'filled','MarkerFaceAlpha',0.5);
    scatter(ii_sess.(to_plot{pp})(use_trial==1,1),tmpy,20,mycolors(pp,:),'filled','MarkerFaceAlpha',0.5);
    
    plot(0,0,'k+','MarkerSize',8,'MarkerFaceColor','k');
    plot(12,0,'kx','MarkerSize',8,'MarkerFaceColor','k');
    xlim([-2 15]);
    axis equal off;
    
    title(to_plot{pp},'Interpreter','none');
end

% FOURTH: align all trial timecouress and saccade traces and plot
% sometimes it's useful to plot a stacked set of saccade timecourses
% aligned towards the direction of the target. Here, I'll do that for the
% extracted traces and the full response timecourse, as two different
% subplots.

% start with just i_sacc_trace
figure;
subplot(3,1,[1 2]); hold on;
thisidx = find(use_trial==1);
for tt = 1:length(thisidx)
    [tmpth,tmpr] = cart2pol(ii_sess.i_sacc_trace{thisidx(tt)}(:,1),ii_sess.i_sacc_trace{thisidx(tt)}(:,2));
    
    % change th, keeping r the same, based on th of ii_sess.targ
    [adjth,~] = cart2pol(ii_sess.targ(thisidx(tt),1),ii_sess.targ(thisidx(tt),2));
    
    [aligned_x,aligned_y] = pol2cart(tmpth-adjth,tmpr);
    
    % if top left or bottom right quadrant, flip y
    if sign(ii_sess.targ(thisidx(tt),1))~=sign(ii_sess.targ(thisidx(tt),2))
        aligned_y = -1*aligned_y;
    end
    
    plot(aligned_x,aligned_y,'-','LineWidth',1,'Color',[0.2 0.2 0.2]);
    clear tmpth tmpr adjth aligned_x aligned_y;
end
% fixation point
plot(0,0,'+','MarkerSize',8,'MarkerFaceColor',mycolors(2,:),'Color',mycolors(2,:),'LineWidth',2);

% target location
plot(12,0,'d','Color',mycolors(1,:),'MarkerFaceColor',mycolors(1,:),'MarkerSize',8);
xlim([-2 15]); axis equal;
set(gca,'TickDir','out','XTick',0:6:12);
title('Aligned primary saccade trajectories');

% now, the aligned trace
xdat_to_plot = ii_sess.params.resp_epoch + [0 1]; % plot response & feedback epoch

subplot(3,1,3); hold on;

for tt = 1:length(thisidx)
    % similar to before, but now we're going to rotate X,Y channels
    [tmpth,tmpr] = cart2pol(ii_sess.X{thisidx(tt)},ii_sess.Y{thisidx(tt)});
    
    % change th, keeping r the same, based on th of ii_sess.targ
    [adjth,~] = cart2pol(ii_sess.targ(thisidx(tt),1),ii_sess.targ(thisidx(tt),2));
    
    [aligned_x,~] = pol2cart(tmpth-adjth,tmpr); % we're not using y here, just x
    
    aligned_x = aligned_x(ismember(ii_sess.XDAT{thisidx(tt)},xdat_to_plot));
    
    this_t = (1:length(aligned_x))/ii_cfg.hz;
    plot(this_t,aligned_x,'-','LineWidth',1,'Color',[0.2 0.2 0.2]);

    
end
xlabel('Time (s) after GO');
ylabel('Eye position (towards target)');
xlim([0 1.5]); ylim([-2 15]);
set(gca,'XTick',[0:0.7:1.4],'YTick',[0:6:12],'TickDir','out');