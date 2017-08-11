function [ii_data,ii_cfg] = ii_invert(ii_data,ii_cfg,chan)
%II_INVERT Invert a channel (e.g., pix to cartesian coordinates)
%   Applies inversion to ii_data.(chan), returns ii_data and an updated
%   ii_cfg with full command history. 

if nargin ~= 3
    prompt = {'Enter channel to invert:'};
    dlg_title = 'Invert Channel';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

%basevars = evalin('base','who');



if ismember(chan,fieldnames(ii_data))
    ii_data.(chan) = -1*ii_data.(chan);

    % TODO: add to ii_cfg history log
    ii_cfg.history{end+1} = sprintf('ii_invert %s %s',chan, datestr(now,30));
    
%    ii_replot;
else
    error('iEye:ii_invert:channelNotFound', 'Channel %s does not exist in ii_data',chan)
end
end