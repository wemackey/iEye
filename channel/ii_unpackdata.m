function ii_unpackdata( ii_data, which_chans )
%II_UNPACKDATA Put channels from ii_data into base workspace
%   ii_unpackdata(ii_data) puts all fields of ii_data struct into base
%   workspace, to maintain backward compatibility with old iEye functions
%
%   ii_unpackdata(ii_data,which_chans) only puts fields within which_chans
%   into base workspace; warns if a channel is missing.
%
% NOTE: if run within a function, the function will not be able to access
% the chan variables - potentially could introspect whether run from base
% or a function? 
%

% Tommy Sprague, 8/17/2017


if nargin < 2
    which_chans = fieldnames(ii_data);
end

if ~iscell(which_chans)
    which_chans = {which_chans};
end

for cc = 1:length(which_chans)
    
    if ismember(which_chans{cc},fieldnames(ii_data))
        assignin('base',which_chans{cc},ii_data.(which_chans{cc}));
    else
        warning('iEye:ii_unpackdata:channelNotFound','Channel %s not found in ii_data',which_chans{cc});
    end
    
end


end

