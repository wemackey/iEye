function [ii_data,ii_cfg] = ii_invert(ii_data,ii_cfg,chan)
%II_INVERT Invert a channel (e.g., pix to cartesian coordinates)
%   Applies inversion to ii_data.(chan), returns ii_data and an updated
%   ii_cfg with full command history. 
%
% [ii_data,ii_cfg] = ii_invert(ii_data,ii_cfg,chan) inverts values in
% ii_data.(chan)
%
% Most useful when values already 'centered', by ii_rescale.

% Tommy Sprague, 8/17/2017

if nargin ~= 3
    prompt = {'Enter channel to invert:'};
    dlg_title = 'Invert Channel';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end


if ismember(chan,fieldnames(ii_data))
    ii_data.(chan) = -1*ii_data.(chan);

    ii_cfg.history{end+1} = sprintf('ii_invert %s %s',chan, datestr(now,30));
    
else
    error('iEye:ii_invert:channelNotFound', 'Channel %s does not exist in ii_data',chan)
end
end