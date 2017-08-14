function [ii_data,ii_cfg] = ii_velocity(ii_data,ii_cfg,xchan,ychan)
% Calculate eye-movement velocity using eye-tracker X and Y channels as
% input. This vector is automatically saved to ii_cfg.velocity
%
% Updated 8/14/2017 TCS - uses ii_data; velocity saved in deg/s

if nargin == 2
    prompt = {'Channel 1 (X)', 'Channel 2 (Y)'};
    dlg_title = 'Velocity';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    xchan = answer{1};
    ychan = answer{2};
end


if ismember(xchan,fieldnames(ii_data)) && ismember(ychan,fieldnames(ii_data))
    
    ii_cfg.velocity = [0; sqrt(diff(ii_data.(xchan)).^2 + diff(ii_data.(ychan)).^2) ] / ii_cfg.hz;
    
    ii_cfg.history{end+1} = sprintf('ii_velocity (%s,%s) - %s ', xchan, ychan, datestr(now,30));
    
    
    
else
    error('iEye:ii_smooth:channelNotFound', 'Channel %s or %s does not exist in ii_data',xchan,ychan)
end


end

