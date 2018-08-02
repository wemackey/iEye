function [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names, smooth_method, smooth_amt)
%II_SMOOTH Smooth data from a channel
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg) smooths the X,Y channels
%   by a Gaussian of std dev 5 ms.
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names) smooths each
%   channel in chan_names (cell array of strings, or a single string)
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names,smooth_method) smooths
%   using specified type (smooth_method): one of
%   'moving','lowess','loess','sgolay','rlowess','rloess' (from smooth.m),
%   or 'Gaussian' (uses gaussian PDF). Uses default 'amount' 5.
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names,smooth_method,smooth_amt)
%   smooths by specified temporal extent (smooth_amt), which is different for each type of
%   smoothing. For Gaussian, this is the standard deviation of gaussian.
%   For others, see smooth.m documentation. Units of ms (converted to
%   samples within script)
%
% ii_data will contain new channel(s) suffixed with _smooth containing the
% results fo the smoothing operation; no data is overwritten (unless smooth
% channels already exist).
%
% Typically, smoothed channel(s) will only be used for computing velocity 
% traces when identifying saccades or elegant visualization; where possible,
% 'raw' gaze data will be used for all quantification
%
% Typically, other pre-processing would be performed prior to this, such as
% blink-correction. For simplicity, example below does not include this
% step (see example in ii_blinkcorrect.m)
%
% Example:
% load('exdata1.mat'); 
% [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,{'X','Y'},'Gaussian',15);
% figure; hold on;
% plot(ii_data.X,'--');plot(ii_data.Y,'--');
% plot(ii_data.X_smooth,'-');plot(ii_data.Y_smooth,'-');
% xlabel('Samples');
% title('Unsmoothed (dashed) vs smoothed (solid) X, Y');


% Modified by TCS 8/14/2017
% Further modified TCS 8/2/2018 - no remaining GUI options, ensured dynamic
% filter window size based on sampling rate & smooth_amt; refactored
% variable names

% default values
if nargin < 3
    chan_names = {'X','Y'};
end

if ~iscell(chan_names)
    chan_names = {chan_names};
end

if nargin < 4
    smooth_method = 'Gaussian';
end

if nargin < 5
    smooth_amt = 5; % for gaussian (ms std dev)
end

% convert to samples
smooth_amt = ii_cfg.hz*smooth_amt/1000;
if ~strcmpi(smooth_method,'Gaussian')
    smooth_amt = round(smooth_amt);
end


for cc = 1:length(chan_names)
    if ismember(chan_names{cc},fieldnames(ii_data))
        chan = ii_data.(chan_names{cc});
        
        
        if ismember(smooth_method,{'moving', 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess'})
            smoothd = smooth(chan,smooth_amt,smooth_method);
            
        elseif strcmpi(smooth_method,'Gaussian')
            
            % in samples: only convolve w/ function that's 3x smooth_amt
            % wide (from center) - this should minimize additional 'nans'
            % when smoothing kernel overlaps with a blink or a censored
            % period
            mykernel = normpdf((-3*ceil(smooth_amt)):(3*ceil(smooth_amt)),0,smooth_amt);
            
            smoothd = conv(ii_data.(chan_names{cc}),mykernel,'same'); % tmpy = conv(et_rot_cueLocked(:,2,tt),mykernel,'same');
            
            clear mykernel;
            
        else
            
            error('iEye:ii_smooth:unrecognizedSmoothingOperation', 'Smoothing method %s not recognized',smooth_method)
        end
        
        
        ii_data.(sprintf('%s_smooth',chan_names{cc})) = smoothd;
       
        ii_cfg.lchan{1}{end+1} = sprintf('%s_smooth',chan_names{cc});
        
        clear smoothd;
        
        ii_cfg.history{end+1} = sprintf('ii_smooth: chan %s, %s %d - %s',chan_names{cc},smooth_method,smooth_amt,datestr(now,30));
        
    else
        
        error('iEye:ii_smooth:channelNotFound', 'Channel %s does not exist in ii_data',chan_names{cc})
    end
    
    
end




return


