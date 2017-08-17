function [ ii_data, ii_cfg ] = ii_addtrialinfo( ii_data, ii_cfg, trial_info )
%II_ADDTRIALINFO Add additional information about each trial to ii_cfg
%structure, such as coords of other targets, condition labels, etc.
%   first dimension of trial_info must match ii_cfg.numtrials
%
% Tommy Sprague, 8/16/2017



% make sure trials defined in ii_cfg
% TODO: maybe allow for trial-less data? or define trials based on a timing
% variable?
if ~ismember('trialvec',fieldnames(ii_cfg))
    error('iEye:ii_addtrialinfo:trialsNotDefined', 'Trials not defined; please run ii_definetrials first');
end



% check trial_info
if size(trial_info,1) ~= ii_cfg.numtrials
    error('iEye:ii_addtrialinfo:incompatibleDims', 'First dimension of trial info (%i) does not match number of trials (%i)',size(trial_info,1),ii_cfg.numtrials);
end


ii_cfg.trialinfo = trial_info;


end

