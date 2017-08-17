function [ii_data,ii_cfg] = ii_findfixations(ii_data,ii_cfg,fix_chans,fix_method)
% II_FINDFIXATIONS - Once all saccades & blinks identified, label fixation
% intervals & create fixation-related channels
%
% fix_method: mean, median, mode?
%
% TCS 8/14/2017


% check whether ii_cfg.saccades & ii_cfg.blinks is defined
assert(isfield(ii_cfg,'saccades')); % TODO: add error message
assert(isfield(ii_cfg,'blink'));

if ~iscell(fix_chans)
    fix_chans = {fix_chans};
end

if ischar(fix_method) % maybe nanmean/nanmedian?
    if strcmpi(fix_method,'mean')
        fix_fcn = @(x) mean(x);
    elseif strcmpi(fix_method,'median')
        fix_fcn = @(x) median(x);
    else
        error('iEye:ii_findfixations:unrecognizedMethod', 'Method %s for summarizing fixations not recognized',fix_method)
    end
elseif isa(fix_method,'function_handle')
    fix_fcn = fix_method;
else
    error('iEye:ii_findfixations:unrecognizedMethod', 'FIX_METHOD must be one of MEAN, MEDIAN, or a function handle')
end


% invert ii_cfg.saccades selection
[ii_data,ii_cfg] = ii_setselect(ii_data,ii_cfg,'saccades'); % set sel to ii_cfg.('saccades');
[ii_data,ii_cfg] = ii_selectinverse(ii_data,ii_cfg);

% remove blinks
ii_cfg.sel(ii_cfg.blinkvec==1) = 0; 


% turn this into cursel-type start/stop indices, save as ii_cfg.fixations
ii_cfg = ii_updatecursel(ii_cfg);
ii_cfg.fixations = ii_cfg.cursel;


% generate ii_data.fix_chans{cc}_fix summary eye position traces for plotting
for cc = 1:length(fix_chans)
    
    new_chan_name = sprintf('%s_fix',fix_chans{cc});
    ii_data.(new_chan_name) = nan(size(ii_data.(fix_chans{cc})));
    
    % add channel to ii_cfg.lchan [[NOTE: why double inside cell array?
    % important later?]]
    ii_cfg.lchan{1}{end+1} = new_chan_name;
    
    for ff = 1:size(ii_cfg.cursel,1)
        
        fix_idx = ii_cfg.cursel(ff,1):ii_cfg.cursel(ff,2);
        ii_data.(new_chan_name)(fix_idx) = fix_fcn(ii_data.(fix_chans{cc})(fix_idx) ) ;
        
        clear fix_idx;
    end
    
    clear new_chan_name;
    
end

new_chan_str = sprintf('%s_fix ',fix_chans{:});
ii_cfg.history{end+1} = sprintf('ii_findfixations - created channels %s, method %s - %s',new_chan_str,fix_method,datestr(now,30));

return