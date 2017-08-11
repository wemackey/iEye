function [ii_data,ii_cfg] = ii_rescale(ii_data,ii_cfg,chan,resolution,ppd,fixation)
%II_RESCALE Rescales a channel(s) (e.g., pix to dva)
%   Used for converting 'raw' gaze coordinates into the coordinate system
%   used to present stimuli. 
% REQUIRED:
%   CHAN: channel name, or list of channel names (cell), to adjust
%      default: {'X', 'Y'}
%   RESOLUTION: # pixels wide, high
%      default: [1280 1024] - should match order of channel names!!!
%   PPD: if a pixels per degree (ppd) ratio is provided with 'ppd'
%        parameter, all channels within CHAN are adjusted by this amount
%        after shifting by RESOLUTION/2 (in absence of fix_pos)
% OPTIONAL:
%   FIX_POS: position, in pixels, of fixation point (defaults to
%   resolution/2)
%   
% Tommy Sprague, 8/11/2017


narginchk(5,6);

if nargin < 5
    ppd = 34.1445;
    fprintf('WARNING: using default ppd value for behavioral room, PLEASE CHECK!\n');
end

if nargin < 6
    fixation = resolution/2;
end

if ~iscell(chan)
    chan = {chan};
end

for cc = 1:length(chan)
    
    ii_data.(chan{cc}) = (ii_data.(chan{cc})-fixation(cc))/ppd;
    
end

ii_cfg.history{end+1} = sprintf('ii_rescale %s %s',horzcat(chan{:}),datestr(now,30));

return