function [ nearest_coord, coord_idx, dist_to_coords ] = ii_nearestcoord( ii_data, ii_cfg, coords, which_chans, varargin )
%ii_nearestcoord Find which of several coordinates to which gaze is nearest
%   [nearest_coord] = ii_nearestcoord(ii_data,ii_cfg,coords) finds the element
%   of coords (cell array - equal number of elements as there are
%   selections in ii_cfg) that is nearest to gaze data from default
%   channels (X, Y; X_fix, Y_fix if available) during each selection
%
%   [nearest_coord] = ii_nearestcoord(ii_data,ii_cfg,coords,which_chans)
%   specifies which gaze channels to use (must be 2)
%
%   [nearest_coord] = ii_nearestcoord(..., 'nofixation') ignores fixation
%   channels if present (by default, if 'fix' version of channels exists, 
%   use those). 
%
%   [nearest_coord,coord_idx, dist_to_coords] = ii_nearestcoord(...) 
%   returns the index of the nearest coordinate within coords, and distance
%   to each coordinate specified. dist_to_coords will be a matrix
%   n_selections x max(numel(coords{:})), with nans where no coordinate
%   specified in coords.
%
% This functions is meant to be used after selecting epochs (e.g., after
% ii_selectfixatiosnbytrial) but before performing 'calibration' to these
% selections. Specifically, useful for when participants are performing a
% decision on targets, so it's not known where eye 'should' be on a given
% trial. coords{ss}{coord_idx(ss)} can be used to calibrate, and inserted
% into ii_cfg by ii_addtrialinfo
%
% NOTE: this function DOES NOT return ii_data, ii_cfg - while this is a
% departure from behavior of other preprocessing functions, it's unclear
% how/why ii_data, ii_cfg should be updated in a 'friendly' way. Will leave
% updating of trialinfo/coords/target channels to user (examples will be
% included in /examples)

% Tommy Sprague, 8/21/2017 (eclipse day)
%
% updated 4/3/2018 - now extracts trial number from ii_cfg.trialvec rather
% than assuming each selection is a consecutive trial


% must have 3 inputs, otherwise bail
if nargin < 3
    error('iEye:ii_nearestcoord:insufficientInputs','Not enough inputs: need ii_data, ii_cfg and list of coords');
end

% We can have more coords than selections, but not more selections than
% coords
if numel(coords) < size(ii_cfg.cursel,1)
    error('iEye:ii_nearestcoord:notEnoughCoords','Number of elements of coords (%i) is smaller than number of selections (%i)',numel(coords),size(cursel,1));
end


if nargin < 4 || isempty(which_chans)
    which_chans = {'X','Y'};
end

% if not requesting nofixation, and _fix channels are available, use them
if ~ismember(varargin,'nofixation')
    if ismember(sprintf('%s_fix',which_chans{1}),fieldnames(ii_data)) && ...
       ismember(sprintf('%s_fix',which_chans{2}),fieldnames(ii_data))

        which_chans{1} = sprintf('%s_fix',which_chans{1});
        which_chans{2} = sprintf('%s_fix',which_chans{2});
    end
end

% initialize variables - these will be size of coords! NaNs if no selection
% for that trial
nearest_coord = nan(numel(coords),2);
coord_idx = nan(numel(coords),1);
dist_to_coords = nan(numel(coords),max(cellfun(@numel,coords)));

% loop over selections
for ss = 1:size(ii_cfg.cursel,1)
    
    % 'fixation' position during selection (TODO: add median option?)
    this_fix = [ nanmean(ii_data.(which_chans{1})(ii_cfg.cursel(ss,1):ii_cfg.cursel(ss,2))),...
                 nanmean(ii_data.(which_chans{2})(ii_cfg.cursel(ss,1):ii_cfg.cursel(ss,2)))];
    
    % trial number for this selection (usually same as idx)
    this_trial = ii_cfg.trialvec(ii_cfg.cursel(ss,1));
             
    % distance for each element of coords{ss}
    this_dist = cellfun(@(c) sqrt((c(1)-this_fix(1)).^2+(c(2)-this_fix(2)).^2),  coords{this_trial});
    
    % find closest coord based on minimum distance (idx)
    [~,coord_idx(this_trial)] = min(this_dist);
    dist_to_coords(this_trial,1:length(this_dist)) = this_dist;
    
    nearest_coord(this_trial,:) = [coords{this_trial}{coord_idx(this_trial)}];
    
    clear this_fix this_dist;
    
end


end

