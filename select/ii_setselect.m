function [ ii_data, ii_cfg ] = ii_setselect( ii_data, ii_cfg, selmode, varargin )
%II_SETSELECT Set previous selection as current (e.g., a trial, all
%fixations, all saccades, etc)
%   SELMODE is one of 'saccades', 'fixations', 'trial(s)'
%
% In progress
% Tommy Sprague, 8/16/2017


valid_selmodes = {'saccades','fixations','trial','trials'};


% check inputs, if 'trial' or 'trials', use trialnum as varargin{1}
if ~ismember(selmode,valid_selmodes)
    error('iEye:ii_setselect:invalidSelectionMode', 'Selection mode %s unrecognized, use one of saccades, fixations, trial(s)',selmode);
end


% select empty
[ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg);


switch selmode
    case {'trial','trials'}
        
        if length(varargin) < 1
            error('iEye:ii_setselect:missingTrialNum', 'No trial(s) defined');
        else
            which_trials = varargin{1};
            
            ii_cfg.sel = 0*ii_cfg.sel;
            ii_cfg.sel(ismember(ii_cfg.trialvec,which_trials)) = 1;
            
            
        end
        
        
    case 'saccades'
        
        % check that saccades field exists...
        
        
        ii_cfg.sel = 0*ii_cfg.sel;
        for ss = 1:size(ii_cfg.saccades,1)
            ii_cfg.sel(ii_cfg.saccades(ss,1):ii_cfg.saccades(ss,2)) = 1;
        end
        
        
        
    case 'fixations'
        
        % check that fixations field exists...
        
        ii_cfg.sel = 0*ii_cfg.sel;
        for ss = 1:size(ii_cfg.fixations,1)
            ii_cfg.sel(ii_cfg.fixations(ss,1):ii_cfg.fixations(ss,2)) = 1;
        end
        
end


% use ii_updatecursel to update cursel given current sel
[ii_cfg] = ii_updatecursel(ii_cfg);


end

