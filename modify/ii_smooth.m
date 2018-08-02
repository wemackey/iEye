function [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names, typ, degr)
%II_SMOOTH Smooth data from a channel
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg) smooths the X,Y channels
%   by a Gaussian of std dev 5 ms.
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names) smooths each
%   channel in chan_names (cell array of strings, or a single string)
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names,typ) smooths
%   using specified type (typ): one of
%   'moving','lowess','loess','sgolay','rlowess','rloess' (from smooth.m),
%   or 'Gaussian' (uses gaussian PDF). Uses default 'degree' 5.
%
%   [ii_data,ii_cfg] = ii_smooth(ii_data,ii_cfg,chan_names,typ,degr)
%   smooths by specified degree (degr), which is different for each type of
%   smoothing. For Gaussian, this is the standard deviation of gaussian.
%   For others, see smooth.m documentation
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

if nargin == 2
    prompt = {'Enter channel to smooth:', 'Type: (moving, lowess, loess, sgolay, rlowess, rloess)', 'Degree'};
    dlg_title = 'Smooth Data';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    chan_names = answer{1};
    typ = answer{2};
    degr = str2num(answer{3});
end

if nargin < 3
    chan_names = {'X','Y'};
end

if ~iscell(chan_names)
    chan_names = {chan_names};
end

if nargin < 4
    typ = 'Gaussian';
end

if nargin < 5
    degr = 5; % for gaussian
end

degr = ii_cfg.hz*degr/1000;
if ~strcmpi(typ,'Gaussian')
    degr = round(degr);
end


for cc = 1:length(chan_names)
    if ismember(chan_names{cc},fieldnames(ii_data))
        chan = ii_data.(chan_names{cc});
        
        
        if ismember(typ,{'moving', 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess'})
            smoothd = smooth(chan,degr,typ);
            
            
            
            
        elseif strcmpi(typ,'Gaussian')
            
            
            
            mykernel = normpdf(linspace(-50,50,101),0,degr);
            
            
            smoothd = conv(ii_data.(chan_names{cc}),mykernel,'same'); % tmpy = conv(et_rot_cueLocked(:,2,tt),mykernel,'same');
            
            clear mykernel;
            
        else
            
            error('iEye:ii_smooth:unrecognizedSmoothingOperation', 'Smoothing type %s not recognized',typ)
        end
        
        
        ii_data.(sprintf('%s_smooth',chan_names{cc})) = smoothd;
       
        ii_cfg.lchan{1}{end+1} = sprintf('%s_smooth',chan_names{cc});
        
        clear smoothd;
        
        ii_cfg.history{end+1} = sprintf('ii_smooth: chan %s, %s %d - %s',chan_names{cc},typ,degr,datestr(now,30));
        
    else
        
        error('iEye:ii_smooth:channelNotFound', 'Channel %s does not exist in ii_data',chan_names{cc})
    end
    
    
end




return


