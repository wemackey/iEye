function [ii_data,ii_cfg] = ii_censorchans(ii_data,ii_cfg,which_chans,censor_range)
% ii_censorchans - remove values from which_chans that are outside range
% specified in censor_range
%
% if censor_range is not a cell, then use same for all channels; otherwise,
% must have one element of cell array for each channel. we set, within each
% channel, values outside the range to nan
%
% TODO: radial mode? for now jsut censoring tpt-by-tpt based on extreme
% values

if nargin < 3 || isempty(which_chans)
    which_chans = {'X','Y'};
end

if nargin < 4 || isempty(censor_range)
    % default to no meaningful censor...
    censor_range = cell(size(which_chans));
    for cc = 1:length(which_chans)
        censor_range{cc} = [-inf inf];
    end
end


% so that below it's a bit easier to loop through these
if ~iscell(censor_range)
    orig_censor_range = censor_range;
    censor_range = cell(size(which_chans));
    for cc = 1:length(orig_censor_range)
        censor_range{cc} = orig_censor_range;
    end
end

% TODO: check that right number of ranges...

% as we loop through, "or" this...
cidx = zeros(size(ii_data.(which_chans{1})));

for cc = 1:length(which_chans)
    
    this_cidx = zeros(size(cidx));
    
    this_cidx( ii_data.(which_chans{cc}) < censor_range{cc}(1) | ...
               ii_data.(which_chans{cc}) > censor_range{cc}(2)) = 1;
    
    
    cidx = cidx | this_cidx==1;
           
    
    
end

% after all channels censored, make sure they all match
for cc = 1:length(which_chans)
    ii_data.(which_chans{cc})(cidx) = NaN;
end

% save things to ii_cfg
ii_cfg.censorvec = cidx;



return