function [ii_sess] = ii_combineruns(ii_trial,run_labels)
% ii_combineruns concatenates all trials within all run-wise scored
% datasets provided in ii_trial and adds label info, all returned as
% ii_expt
%
%   ii_combineruns(ii_trial), where ii_trial is a cell array of
%   scored runs (using ii_scoreMGS or similar) concatenates all trials.
%   Assumes that runs are numbers 1-n, where n is length(ii_trial). If
%   ii_trial is a struct, ii_sess is returned as ii_trial, and run is
%   labeled as 1.
%
%   ii_combineruns(ii_trial,run_labels) where run_labels is the same
%   length as ii_trial saves a label for each run such that ii_trial{i} is
%   labeled with run_labels(i).
%
% uses cat_struct.m (TCS)
%
% We assume that ii_trial.params is the same for all runs, so we only save
% the first one. 
%
% No ii_cfg input/output necessary - ii_cfg mostly links data from trials
% to ii_data, but that won't be necessary anymore, at least not here.
%
% Tommy Sprague, 6/12/2018

% add a few fields:
% - r_num - run number (from run_labels or index into ii_trial)
% - t_num - trial number (from ii_cfg)
% 

% make sure we're using the correct cat_struct
full_path = mfilename('fullpath');
util_path = sprintf('%s../util',full_path(1:find(full_path=='/',1,'last')));
addpath(util_path);

% if only a single run given, make it a cell array to make everything else
% easier
if ~iscell(ii_trial)
    ii_trial = {ii_trial};
end

if nargin < 3 || isempty(run_labels)
    run_labels = 1:length(ii_trial);
else
    % check to be sure length(run_labels) matches length(ii_trial)
    if length(run_labels)~=length(ii_trial)
        error('iEye:ii_combineruns:incompatibleLabels','Length of run labels must match number of runs provided');
    end
end

% initialize to an empty struct
ii_sess = struct();

% and initialize an empty set of run & trial indices
% (assume all runs are same size; not strictly true but that's ok below)
r_num = nan(size(ii_trial{1}.i_sacc,1)*length(ii_trial),1);
t_num = nan(size(ii_trial{1}.i_sacc,1)*length(ii_trial),1);

for rr = 1:length(ii_trial)
    ii_sess = cat_struct(ii_sess,ii_trial{rr},{'params'}); % don't need to concatenate params
    
    thisidx = size(ii_sess.i_sacc,1) - size(ii_trial{rr}.i_sacc,1) + (1:size(ii_trial{rr}.i_sacc,1));
    
    r_num(thisidx) = run_labels(rr);
    t_num(thisidx) = 1:size(ii_trial{rr}.i_sacc,1);
    clear thisidx;
end


ii_sess.params = ii_trial{1}.params;
ii_sess.r_num = r_num;
ii_sess.t_num = t_num;

return