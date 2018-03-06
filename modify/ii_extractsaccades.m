function [ ii_data, ii_cfg, ii_sacc ] = ii_extractsaccades( ii_data,ii_cfg,which_chans,startpoint_mode,endpoint_mode, epoch_chan )
%ii_extractsaccades After preprocessing, extract saccade properties
%   [ii_data,ii_cfg,ii_sacc] = ii_extractsaccades(ii_data,ii_cfg) extracts
%   properties of all saccades in ii_cfg.saccades using the
%   previous/following fixation to compute startpoint/endpoint and
%   amplitude for default channels X,Y. If fixations not available, uses 10
%   ms before/after saccade as start/endpoint
%
%   [ii_data,ii_cfg,ii_sacc] = ii_exctractsaccades(ii_data, ii_cfg,
%   which_chans) specifies the channels of interest. 
%
%   [ii_data,ii_cfg,ii_sacc] =
%   ii_extractsaccades(ii_data,ii_cfg,which_chans,startpoint_mode, endpoint_mode) uses
%   mode specified by each of startpoint_mode; endpoint_mode for scoring
%   start points/endpoints. if 'fixation', uses the previous/following
%   fixation positions (_fix channel values). If a channel lacks defined
%   fixations, uses 10 ms before/after saccade finished. If  mode is a
%   single number, takes up to that many ms before saccade onset/after
%   saccade offset as start/endpoint. If 2 numbers, uses range of those two
%   numbers, inclusive, before/after saccade as start/endpoint. 
%
%   epoch_chan is channel to use for looking up epochs; defaults to XDAT
%   
% ii_sacc will contain fields, each with one entry per saccade identified
% in ii_cfg. Peak velocity, starttime, endtime, and duration are computed 
% using ii_cfg.saccades. Only amplitude, startpoint, and endpoint are
% computed using the startpoint_mode and endpoint_mode. 
% 
%

% Examples: TODO

% Tommy Sprague, 8/19/2017
%


% make sure ii_sacc is saved!
if nargout~=3
end

if nargin < 3
    which_chans = {'X','Y'};
end

if length(which_chans)~=2   
    error('iEye:ii_exctractsaccades:invalidChannels','Must use 2 channels for saccade metric exctraction');
end

% check that the channels exist... [TODO]

% check for startpoint, endpoint mode
if nargin < 4
    
    % if fixations computed, use those
    if ismember('fixations',fieldnames(ii_cfg))
        startpoint_mode = 'fixation';
    else
    % otherwise, use 10 ms before/after saccade on/offset
        startpoint_mode = 10;
    end
end


if nargin < 5 
    if ismember('fixations', fieldnames(ii_cfg))
        endpoint_mode = 'fixation';
    else
        endpoint_mode = 10;
    end
end

if nargin < 6
    epoch_chan = 'XDAT';
end

% go from ms to samples
if isnumeric(startpoint_mode)
    startpoint_mode = ii_cfg.hz*startpoint_mode/1000;
elseif strcmpi(startpoint_mode,'fixation')
    if ~ismember('fixations',fieldnames(ii_cfg))
        error('iEye:ii_extractsaccades:fixationsNotDefined','Attempt to use fixations to define saccade start points, but fixations not defined in ii_cfg');
    end
end

if isnumeric(endpoint_mode)
    endpoint_mode = ii_cfg.hz*endpoint_mode/1000;
elseif strcmpi(endpoint_mode,'fixation')
    if ~ismember('fixations',fieldnames(ii_cfg))
        error('iEye:ii_extractsaccades:fixationsNotDefined','Attempt to use fixations to define saccade end points, but fixations not defined in ii_cfg');
    end
end


% make sure saccades have been defined...
if ~ismember('saccades',fieldnames(ii_cfg)) || isempty(ii_cfg.saccades)
    error('iEye:ii_extractsaccades:saccadesNotDefined','No saccades found in ii_cfg, run ii_findsaccades.m');
end

% create ii_sacc structure with fields:
% - ii_sacc.<chan>_start
% - ii_sacc.<chan>_end
% - ii_sacc.amplitude
% - ii_sacc.peakvelocity
% - ii_sacc.duration
% - ii_sacc.trial_start [if trials defined]
% - ii_sacc.trial_end
% - ii_sacc.t (time, in ms, from start to finish)
% - ii_sacc.idx (idx, into ii_data, of start/end)
% - ii_sacc.epoch_start
% - ii_sacc.epoch_end
% - ii_sacc.<chan>_trace (cell array; full timecourse of that channel from
%                         beginning to end of saccade)

n_sacc = size(ii_cfg.saccades,1);

% initialize relevant fields as nans
ii_sacc = struct;
ii_sacc.amplitude   = nan(n_sacc,1);
ii_sacc.peakvelocity= nan(n_sacc,1);
ii_sacc.duration    = nan(n_sacc,1);
ii_sacc.idx         = nan(n_sacc,2); % from beginning to end
ii_sacc.epoch_start = nan(n_sacc,1);
ii_sacc.epoch_end   = nan(n_sacc,1);



% if trial labels present, define them
if ismember('trialvec',fieldnames(ii_cfg))
    ii_sacc.trial_start = nan(n_sacc,1); % trial label at beginning of saccade
    ii_sacc.trial_end   = nan(n_sacc,1); % trial label at beginning of saccade
end


% TODO: most of this can be vectorized
% start by defining all 'easy' fields
for ss = 1:size(ii_cfg.saccades)
    
    % indices into ii_data channel vectors
    ii_sacc.idx(ss,:) = ii_cfg.saccades(ss,:);
    
    % epoch labels at beginning/end of saccade
    ii_sacc.epoch_start(ss) = ii_data.(epoch_chan)(ii_cfg.saccades(ss,1));
    ii_sacc.epoch_end(ss)   = ii_data.(epoch_chan)(ii_cfg.saccades(ss,2));
    
    % if trials defined, add those fields
    if ismember('trialvec',fieldnames(ii_cfg))
        
        ii_sacc.trial_start(ss) = ii_cfg.trialvec(ii_cfg.saccades(ss,1));
        ii_sacc.trial_end(ss)   = ii_cfg.trialvec(ii_cfg.saccades(ss,2));
        
    end
    
    % loop over channels
    for cc = 1:length(which_chans)
        
        if ss == 1
            ii_sacc.(sprintf('%s_start',which_chans{cc})) = nan(n_sacc,1);
            ii_sacc.(sprintf('%s_end',  which_chans{cc})) = nan(n_sacc,1);
            
            ii_sacc.(sprintf('%s_trace',which_chans{cc})) = cell(n_sacc,1);
        end
        
        % START
        % if mode is fixation
        if strcmpi('fixation',startpoint_mode)
            % last fixation before saccade start
            fixidx = find(ii_cfg.fixations(:,2)<ii_cfg.saccades(ss,1),1,'last');
            ii_sacc.(sprintf('%s_start',which_chans{cc}))(ss) = nanmean(ii_data.(sprintf('%s_fix',which_chans{cc}))(ii_cfg.fixations(fixidx,2)));
            clear fixidx;
        
        % if just a single number 
        elseif numel(startpoint_mode)==1
            fixidx = max(ii_cfg.saccades(ss,1)-startpoint_mode,1):(ii_cfg.saccades(ss,1)-1);
            ii_sacc.(sprintf('%s_start',which_chans{cc}))(ss) = nanmean(ii_data.(which_chans{cc})(fixidx));
            clear fixidx;
        % if two numbers
        elseif numel(startpoint_mode)==2
            fixidx = max(ii_cfg.saccades(ss,1)-max(startpoint_mode),1):(max(ii_cfg.saccades(ss,1)-min(startpoint_mode),1));
            ii_sacc.(sprintf('%s_start',which_chans{cc}))(ss) = nanmean(ii_data.(which_chans{cc})(fixidx));
            clear fixidx;
        end
        
        % END
        % if mode is fixation
        if strcmpi('fixation',endpoint_mode)
            % first fixation after saccade end
            fixidx = find(ii_cfg.fixations(:,1)>ii_cfg.saccades(ss,2),1,'first');
            ii_sacc.(sprintf('%s_end',which_chans{cc}))(ss) = nanmean(ii_data.(sprintf('%s_fix',which_chans{cc}))(ii_cfg.fixations(fixidx,1)));
            clear fixidx;
        
        % if just a single number 
        elseif numel(endpoint_mode)==1
            fixidx = (ii_cfg.saccades(ss,2)+1):min(ii_cfg.saccades(ss,2)+endpoint_mode,numel(ii_data.(which_chans{cc})));
            ii_sacc.(sprintf('%s_end',which_chans{cc}))(ss) = nanmean(ii_data.(which_chans{cc})(fixidx));
            clear fixidx;
        % if two numbers
        elseif numel(endpoint_mode)==2
            fixidx = min(ii_cfg.saccades(ss,2)+min(endpoint_mode),numel(ii_data.(which_chans{cc}))):(min(ii_cfg.saccades(ss,2)+max(endpoint_mode),numel(ii_data.(which_chans{cc}))));
            ii_sacc.(sprintf('%s_end',which_chans{cc}))(ss) = nanmean(ii_data.(which_chans{cc})(fixidx));
            clear fixidx;
        end
        
        % save out full trace of each channel
        ii_sacc.(sprintf('%s_trace',which_chans{cc})){ss} = ii_data.(which_chans{cc})(ii_cfg.saccades(ss,1):ii_cfg.saccades(ss,2));
        
    end
  
    % peak velocity
    ii_sacc.peakvelocity(ss) = max(ii_cfg.velocity(ii_cfg.saccades(ss,1):ii_cfg.saccades(ss,2)));
    
end
    
% convert idx to time (s, like duration threshold in ii_findsaccades)
ii_sacc.t = ii_sacc.idx / ii_cfg.hz;
ii_sacc.duration = ii_sacc.t(:,2)-ii_sacc.t(:,1);

% compute amplitude from start/end
ii_sacc.amplitude = sqrt(  (ii_sacc.(sprintf('%s_end',which_chans{1})) - ii_sacc.(sprintf('%s_start',which_chans{1}))).^2 + ...
    (ii_sacc.(sprintf('%s_end',which_chans{2})) - ii_sacc.(sprintf('%s_start',which_chans{2}))).^2);


end

