function [ ii_data, ii_cfg ] = ii_driftcorrect( ii_data, ii_cfg, chan_names, correct_mode, target_coords )
%II_DRIFTCORRECT Realign timeseries of each trial to specified coords,
%relative to measured signal in specified channel during selections (1/trial)
%   Due to tracker/gaze drift through a session, translate coords for each
%   trial so that gaze during a specified epoch is defined as
%   target_coords. Typically, identify fixations (before this function),
%   then find last fixation before relevant trial events start and
%   translate entire time series such that gaze is 0,0 during that epoch. 
%
% CORRECT_MODE: one of 'fixation' (assuming fixaitons have been
% computed), 'raw', or 'smooth' (assuming data has been smoothed & saved
% as smooth channels)

% work in progress
% Tommy Sprague, 8/16/2017



if nargin < 3
    chan_names = {'X','Y'}; % or FixX, FixY? 
end

if ~iscell(chan_names)
    chan_names = {chan_names};
end


% perhaps we should check that the correct_to_epochs are sequential? that
% may not be appropriate, though, so I'll just hope users know that...


% if fixations have been computed, assume we want to align to the last
% fixation before end of specified epoch(s)
if nargin < 4 || isempty(correct_mode)
    if ismember('fixations',fieldnames(ii_cfg))
        correct_mode = 'fixation';
    else
        correct_mode = 'epoch_mean';
    end
end

if strcmpi(correct_mode,'fixation')
    if ~ismember('fixations',fieldnames(ii_cfg))
        error('iEye:ii_driftcorrect:missingFixations', 'Fixations not computed - run ii_findfixations to use fixations when drift correcting');
    end
end

% check that trials have been defined
if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_driftcorrect:missingTrials', 'Trials not defined - run ii_definetrials to use ii_driftcorrect');
end
% TODO: presumably we could do this all via selections? drift-correct all
% timepoints between selections based on selections?


% TODO: can allow for n_trials sets of coords, but that's a bit complicated
% for now...
if nargin < 6 || isempty(target_coords)
    target_coords = zeros(1,length(chan_names));
end


tu = unique(ii_cfg.trialvec(ii_cfg.trialvec~=0));
numsel = size(ii_cfg.cursel,1);


% now we make adjustments [in future, we'll allow for selections to already
% exist, then will just do below]
%
% ~~~~ NOTE: below is something we'll add in the future - for now, need to
%       account for trials w/ no selections in typical MGS expt... ~~~~~~~
% if same number of selections as unique non-zero values in trialvec,
% assume that we want to correct all of trialvec given values in
% cursel(tt,:). otherwise, correct from beginning of selection to beginning
% of next selection (not ideal for trial-based analyses)

% need this to find relevant channels to adjust (remove XDAT, never adjust
% that...)
all_fields = fieldnames(ii_data);
all_fields = {all_fields{~strcmpi(all_fields,'XDAT')}};

ii_cfg.drift.chan = chan_names; % channels input to ii_driftcorrect
ii_cfg.drift.mode = correct_mode;
ii_cfg.drift.amt = nan(length(tu),length(chan_names));

for cc = 1:length(chan_names)
    
    % get all channels we want to apply adjustment to
    
    chans_to_adjust = { all_fields{ cellfun(@(x) any(x) && x(1)==1 , strfind(all_fields,chan_names{cc} )) } };
    
    
        
    % LOOP OVER SELECTIONS
    % - figure out which trial is selected, select full trial timecourse,
    %   adjust as prescribed. leave trials with no selections as NaN for
    %   ii_cfg.drift.amt
    
    
    
    for sel_idx = 1:size(ii_cfg.cursel,1)
        
        % look up trial # at start of selection (this should be
        % fine...)
        which_trial = ii_cfg.trialvec(ii_cfg.cursel(sel_idx,1));
        
        tr_idx = ii_cfg.trialvec==which_trial;%tu(tt);
        
        % if mode is fixation-mean - use which_chans_fix, otherwise,
        % average of which_chans
        % also - correct all chanels which_chans*
        
        if strcmpi(correct_mode,'fixation')
            adj_by = nanmean(ii_data.(sprintf('%s_fix',chan_names{cc}))(ii_cfg.cursel(sel_idx,1):ii_cfg.cursel(sel_idx,2)))-target_coords(cc);
        elseif strcmpi(correct_mode,'smooth')
            adj_by = nanmean(ii_data.(sprintf('%s_smooth',chan_names{cc}))(ii_cfg.cursel(sel_idx,1):ii_cfg.cursel(sel_idx,2)))-target_coords(cc);
        else
            adj_by = nanmean(ii_data.(chan_names{cc})(ii_cfg.cursel(sel_idx,1):ii_cfg.cursel(sel_idx,2)))-target_coords(cc);
        end
        
        % apply adjustment to entire trial
        for ca = 1:length(chans_to_adjust)
            ii_data.(chans_to_adjust{ca})(tr_idx) = ii_data.(chans_to_adjust{ca})(tr_idx)-adj_by;
        end
        
        ii_cfg.drift.amt(which_trial,cc) = adj_by;
        
        
        clear adj_by tr_idx;
        
    end
    
    
    
    
end

chan_str = sprintf('%s ',chan_names{:});
ii_cfg.history{end+1} = sprintf('ii_driftcorrect - chans %s, mode %s, to target coords [%s] - %s',chan_str,correct_mode,num2str(target_coords), datestr(now,30)  );


end

