function [ ii_data, ii_cfg ] = ii_selectfixationsbytrial( ii_data, ii_cfg, epoch_chan, within_epochs, sel_mode, buffer_window,calibrate_targs,fix_channels )
%II_SELECTFIXATIONSBYTRIAL Selects those fixations within given epochs for
%each trial using one of several modes ('first', 'last', 'begin', 'all'). 
%   Used to select periods to 'calibrate' to for drift correction and
%   single-trial 'calibration'
%
%   for FIRST: select the first fixation that begins AFTER beginning of
%   epoch (and can continue past end)
%   for LAST:  select the last fixation that begins before END of epoch
%   for BEGIN: select the fixation from beginning of epoch to first new
%   fixation
%   for ALL:   select all fixations that begin during the epoch
%   for MODE:  select longest fixation among all
%   for NEAREST: select fixation that is nearest to that trial's
    %   coordinates ... (calibrate_targs) - either a cell array of
    %   strings, which points to the channels w/ this info (TarX,TarY..),
    %   or a trials x 2 matrix of coordinates, each row for each trial)
%
% added a 'buffer window' to prevent selection of premature saccades as
% fixations, especially for calibration (ms)
%
% TODO: buffer_window doesn't seem to use ms in practice - actually using
% samples, so for 500 Hz datasets doubles window length!
%
% Tommy Sprague, 8/16/2017
% - updated (TCS) 11/24/2017 to 


if nargin < 3 || isempty(epoch_chan)
     epoch_chan = 'XDAT';
end

if nargin < 6
    buffer_window = 0;
end

% only need coordinates to calibrate against if using 'nearest' mode
if nargin < 7
    calibrate_targs = {};
end

if nargin < 8
    fix_channels = {'X_fix','Y_fix'}; % where to use for alignment to calibration targets on 'nearest' mode
end

% buffer window input as ms: turn it into samples
buffer_window = 0.001*buffer_window*ii_cfg.hz;

% make sure channel exists...
if ~ismember(epoch_chan,fieldnames(ii_data))
    error('iEye:ii_selectfixationsbytrial:invalidEpochChannel', 'Channel %s not found',epoch_chan);
end


% check sel_mode is one of 'last','first','all'
if ~ismember(sel_mode,{'last','first','begin','all','mode','nearest'})
    error('iEye:ii_selectfixationsbytrial:invalidSelectionMode', 'Selection mode %s invalid: use one of first, last, begin, all, mode',sel_mode);
end

% make sure fixations have been computed
if ~ismember(fieldnames(ii_cfg),'fixations')
    error('iEye:ii_selectfixationsbytrial:missingFixations', 'Fixations not computed - run ii_findfixations prior to selecting fixations');
end

% and make sure trials have been defined
if ~ismember(fieldnames(ii_cfg),'trialvec')
    error('iEye:ii_selectfixationsbytrial:trialsNotDefined', 'Trials not defined - run ii_definetrials prior to selecting fixations per trial');
end

% clear selections
[ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg);

% make new selections
tu = unique(ii_cfg.trialvec(ii_cfg.trialvec~=0));

new_sel = ii_cfg.sel*0;

% TODO: epoch chan?
epoch_idx = ismember(ii_data.(epoch_chan),within_epochs);

% if necessary, create a vector of fixations - this will be useful for the
% 'all' mode, we can just AND this with epoch_idx and trial_idx and
% update_cursel
if any(strcmpi(sel_mode,{'all','mode'}))
    all_fixvec = 0*ii_cfg.sel;
    for ff = 1:size(ii_cfg.fixations)
        all_fixvec(ii_cfg.fixations(ff,1):ii_cfg.fixations(ff,2))=1;
    end
end



for tt = 1:length(tu)
    
    trial_idx = ii_cfg.trialvec==tu(tt);
    
    % a discontinuous selection is one for which there is more than one
    % onset OR more than one offset
    % quick check to make sure just one contiguous selection...
    if sum(diff(trial_idx & epoch_idx)==1) > 1 || sum(diff(trial_idx & epoch_idx)==-1) > 1 % this originally checked against 1, but this precludes a trial starting w/ first sample
        error('iEye:ii_selectfixationsbytrial:nonContiguousEpoch', 'On trial %i, epochs non-contiguous',tu(tt));
    end
    
    
    
    % if method is last_fixation, find within this trial, within
    % [correct_to_epochs], start of last fixation, select from there to end
    % of last correct_to_epoch.
    
    if strcmpi(sel_mode,'last') % used for drift correction, calibration
        

        
        epoch_begin = find(diff(trial_idx & epoch_idx)==1);
        epoch_end = find(diff(trial_idx & epoch_idx)==-1);
        last_fix_ind = find(ii_cfg.fixations(:,1)<(epoch_end-buffer_window),1,'last');
        
        last_fix_vec = zeros(size(new_sel));
        last_fix_vec(max(ii_cfg.fixations(last_fix_ind,1),epoch_begin):(epoch_end-buffer_window))=1;
        
        new_sel = new_sel|(last_fix_vec==1);
        
        clear last_fix_vec epoch_begin epoch_end last_fix_ind trial_idx;
        
        
    elseif strcmpi(sel_mode,'first')
               
        
        epoch_begin = find(diff(trial_idx & epoch_idx)==1);
        epoch_end = find(diff(trial_idx & epoch_idx)==-1);

        first_fix_ind = find(ii_cfg.fixations(:,1)>epoch_begin,1,'first');
        
        % select from beginning of this fixation to end of epoch or end of
        % that fixation, whichever is sooner
        first_fix_vec = zeros(size(new_sel));
        first_fix_vec(ii_cfg.fixations(first_fix_ind,1):min(epoch_end,ii_cfg.fixations(first_fix_ind,2)))=1;
        
        new_sel = new_sel|(first_fix_vec==1);
        
        clear first_fix_vec epoch_begin epoch_end first_fix_ind trial_idx;
        
        
        
    elseif strcmpi(sel_mode,'begin')
        % from beginning of epoch to end of that fixation 
        
        
        epoch_begin = find(diff(trial_idx & epoch_idx)==1);
        epoch_end = find(diff(trial_idx & epoch_idx)==-1);

        first_fix_ind = find(ii_cfg.fixations(:,1)>epoch_begin,1,'first');
        
        first_fix_vec = zeros(size(new_sel));
        first_fix_vec(epoch_begin:min(ii_cfg.fixations(first_fix_ind,1)-1,epoch_end))=1;
        
        new_sel = new_sel|(first_fix_vec==1);
        
        clear first_fix_vec epoch_begin epoch_end first_fix_ind trial_idx;
       
        
    elseif strcmpi(sel_mode,'all') % used for ??? (maybe multiple saccades?)
        
        % find all fixations that occur within interval 
        
        new_sel = epoch_idx==1 & trial_idx==1 & all_fixvec==1;
        
        
    
    % look for longest fixation within an epoch
    elseif strcmpi(sel_mode,'mode')
        
        
        % find all fixations during this epoch, trial
        this_fix = epoch_idx==1 & trial_idx==1 & all_fixvec==1;
        
        % figure out how long each is
        % (first, find out when they start/stop)
        fix_begin = find(diff([0;this_fix])== 1);
        fix_end   = find(diff([this_fix;0])==-1);
        
        % their duration is their end minus their beginning
        fix_dur = fix_end-fix_begin;
        
        % which one is longest?
        [~,fix_idx] = max(fix_dur);
        
        % add that fixation to the selection
        new_sel(fix_begin(fix_idx):fix_end(fix_idx)) = 1==1;
        
        clear this_fix fix_begin fix_end fix_dur fix_idx;
    
    
    elseif strcmpi(sel_mode,'nearest')
        
        % NOTE: this will use FixX, FixY channels!!!!
        
        if isempty(calibrate_targs)
            error('iEye:ii_selectfixationsbytrial:calibrateCoordsUndefined', 'When using mode "NEAREST", must define target locations for fixation selection');
        end
        
        if iscell(calibrate_targs)
            if length(calibrate_targs) ~= 2
                error('iEye:ii_selectfixationsbytrial:calibrateCoordsIllDefined', 'When cell provided for calibrate_coords, must name 2 channels defined in ii_data');
            end
        
            % extract coord on this trial (n_trials x 2) from these
            % channels
            
            this_targ = [ii_data.(calibrate_targs{1})(trial_idx==1 & epoch_idx==1) ii_data.(calibrate_targs{2})(trial_idx==1 & epoch_idx==1)]; 
            u_targs = unique(this_targ,'rows');
            
            % make sure there's only one unique value...if not, error?
            if size(u_targs,1) ~= 1
                warning('iEye:ii_selectfixationsbytrial:multipleTargLocs', 'TarX, TarY have multiple %i unique values during calibration epoch(s) on trial %i (1 expected)',size(u_targs,1),tt);
            end
            
            this_calib_targ = mode(this_targ,1);
            
            clear u_targs this_targ;
            
        elseif isnumeric(calibrate_targs)
            
            if size(calibrate_targs,1) ~= ii_cfg.numtrials
                error('iEye:ii_selectfixationsbytrial:calibrateCoordsIllDefined', 'Incorrect size for calibrate_coords: expected %i rows, found %i',ii_cfg.numtrials,size(calibrate_targs,1));
            end
            
            this_calib_targ = calibrate_targs(tt,:);
            
        end
        
        epoch_begin = find(diff(trial_idx & epoch_idx)==1);
        epoch_end = find(diff(trial_idx & epoch_idx)==-1);
        
        trial_epoch_idx = epoch_begin:epoch_end;
        
        
        % compute distance between fix_channels and this_calib_targ
        this_fix = [ii_data.(fix_channels{1})(trial_idx==1 & epoch_idx==1) ii_data.(fix_channels{2})(trial_idx==1 & epoch_idx==1)];
        this_dist = sqrt(sum((this_fix-this_calib_targ).^2,2));
        
        
        % select that point for that trial
        min_dist = min(this_dist);
        new_sel(trial_epoch_idx(this_dist==min_dist))=1==1;
    
        
        clear this_calib_targ epoch_begin epocH_end this_fix this_dist min_dist;
    
    
    end
    
    
    
    
end

% update cursel field of ii_cfg to match new selections
ii_cfg.sel = new_sel;
ii_cfg = ii_updatecursel(ii_cfg);


% ordinarily wouldn't put this in history, but because it's used for things
% like drift correction, etc, makes sense here
ii_cfg.history{end+1} = sprintf('ii_selectfixationsbytrial - selected epochs %s from chan %s with mode %s - %s',num2str(within_epochs),epoch_chan,sel_mode,datestr(now,30));



end

