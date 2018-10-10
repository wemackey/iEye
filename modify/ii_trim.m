function [ii_data,ii_cfg] = ii_trim(ii_data,ii_cfg,valid_epochs,epoch_chan)
%ii_trim Cleans data by removing samples with invalid epoch label
%   [ii_data,ii_cfg] = ii_trim(ii_data,ii_cfg,valid_epochs,epoch_chan) limits 
%   ii_data to only include samples marked as a member of valid_epochs based 
%   on values in epoch_chan.
%
% Inputs:
%   valid_epochs:  epoch values for valid samples in epoch_chan. if NaN,
%                  all samples are considered valid, and ii_data is returned 
%                  unmodified
%   epoch_chan:  channel name containing epoch label (string)
%
% Typically, this is used to remove 'junk' data from beginning/end of a
% behavioral file before trials start and after experiment is over. But,
% it's up to experimenter to VERIFY this!
% 
% T Sprague, 10/10/2018

if nargin < 3
    valid_epochs = NaN;
end

if nargin < 4
    epoch_chan = 'XDAT';
end

if isnan(valid_epochs)
    return;
else
    valid_idx = ismember(ii_data.(epoch_chan),valid_epochs);
    
    % if no valid samples found, throw an error
    if sum(valid_idx==1)==0
        error('iEye_ts:ii_trim:noValidEpochsFound','No valid epochs found');
    else
        
        % select only valid samples from each field of ii_data
        ii_data = structfun(@(f) f(valid_idx==1),ii_data,'UniformOutput',false);
        
        valid_str = sprintf('%i,',valid_epochs);
        valid_str = valid_str(1:end-1);
        
        % add history to ii_cfg
        ii_cfg.history{end+1} = sprintf('ii_trim - used channel %s to select epochs %s on %s ', epoch_chan, valid_str, datestr(now,30));

        
        ii_cfg.trim.(sprintf('orig_%s',epoch_chan)) = ii_data.(epoch_chan);
        ii_cfg.trim.valid_epochs = valid_epochs;
        
        
    end
    
end


return