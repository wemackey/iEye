function ii_savedata(ii_data,ii_cfg,filename)
%II_SAVEDATA Save ii_data,ii_cfg into file
%   ii_savedata(ii_data,ii_cfg) saves into same file as edf, suffixed with
%   _iEye.mat
%
%   ii_savedata(ii_data,ii_cfg,filename) saves into filename
%
% Example:
% load('exdata1.mat');
% ii_savedata(ii_data,ii_cfg,'newfilename.mat');

% Tommy Sprague, 8/17/2017


if nargin < 3
    filename = sprintf('%s_iEye.mat',filename(1:(end-4)));
end

% SAVE FILE
save(filename,'ii_data','ii_cfg');

end


