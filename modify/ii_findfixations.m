function [ii_data,ii_cfg] = ii_findfixations(ii_data,ii_cfg,fix_chans,fix_method)
% II_FINDFIXATIONS - Once all saccades & blinks identified, label fixation
% intervals & create fixation-related channels
%
% fix_method: mean, median, mode?
%
% TCS 8/14/2017


% check whether ii_cfg.saccades & ii_cfg.blinks is defined
assert(isfield(ii_cfg,'saccades')); % TODO: add error message
assert(isfield(ii_cfg,'blinks'));


% invert ii_cfg.saccades selection
% TODO: ii_setselect('saccades'); % set sel to ii_cfg.('saccades');
[ii_data,ii_cfg] = ii_selectinverse(ii_data,ii_cfg);

% remove blinks


% turn this into cursel-type start/stop indices, save as ii_cfg.fixations



% generate ii_data.fix_chans{cc}_fix summary eye position traces for plotting



return