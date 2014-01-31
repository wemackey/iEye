function ii_view_channels(vis)
%II_VIEW_CHANNELS Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Channel Names'};
    dlg_title = 'Visible Channels';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    vis = answer{1};
end

ii_cfg = evalin('base', 'ii_cfg');
ii_cfg.vis = vis;
putvar(ii_cfg);
ii_replot;
end

