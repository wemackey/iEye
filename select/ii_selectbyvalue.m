function [ii_data,ii_cfg] = ii_selectbyvalue(ii_data,ii_cfg, c, cond, cval)
%II_SELECTBYVALUE Select all points where a particular channel (or input
%that's the same size as channel) passes an equality condition
%   II_SELECTBYVALUE requires either a channel name which is present in
%   ii_data or a vector the same length as the ii_data channels. This
%   function compares data in the indicated channel with input value and
%   comparator function 'cond', which should return a logical given a
%   vector and either a scalor or a matching vector. Also allowed is one of
%   6 numerics (1-6), which specifify an operation, or associated string:
% 1 or 'equal' : ==
% 2 or 'notequal' : ~=
% 3 or 'lessthan' : < 
% 4 or 'greaterthan' : >
% 5 or 'lessthanequalto' : <=
% 6 or 'greaterthanequalto' : >=
%
% TCS, 8/14/2017 - substantial changes to previous behavior!!! More verbose
% usage possible, arbitrary 'anonymous channnels' allowed, and arbitrary
% comparator functions allowed
% [[still not well-tested..., especially GUI aspects]]


valid_cond_str = {'equal','notequal','lessthan','greaterthan','lessthanequalto','greaterthanequalto'};
default_cond_fcn = {@(a,b) eq(a,b), @(a,b) ne(a,b), @(a,b) lt(a,b), @(a,b) gt(a,b), @(a,b) le(a,b), @(a,b) ge(a,b) };



if nargin == 2
    prompt = {'Channel', sprintf('Condition: \n(1) is \n(2) is not \n(3) less than \n(4) greater than \n(5) less than or equal to \n(6) greater than or equal to'), 'Value'};
    dlg_title = 'Select by Value';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    c = answer{1};
    cond = str2num(answer{2});
    cval = str2num(answer{3});
end


% ensure channel exists, if it's a string, or that it matches length, if
% it's a number

if ischar(c)
    % check the channel exists
    if ~ismember(c,fieldnames(ii_data))
        error('iEye:ii_selectbyvalue:channelNotFound', 'Channel %s does not exist in ii_data',c)
    else
        chandata = ii_data.(c);
    end
elseif isnumeric(c)
    % check it's the right size
    if numel(c)~=numel(ii_cfg.sel)
        error('iEye:ii_selectbyvalue:dimensionMismatchError', 'Anonymous input channel has %i elements, %i expected',numel(c),numel(ii_cfg.sel))
    else
        chandata = c;
    end
end
    
    
% check the conditional:
if isa(cond,'function_handle')
    % make sure it works....
elseif isnumeric(cond) && ~ismember(cond,1:length(valid_cond_str))
    error('iEye:ii_selectbyvalue:invalidConditionalError', 'Numeric conditional flag %i unrecognized (1-6 expected)',cond)
elseif ischar(cond) && ~ismember(cond,valid_cond_str)
    error('iEye:ii_selectbyvalue:invalidConditionalError', 'String conditional flag %s unrecognized',cond)
%else % if not a functional, a valid number, or a valid string, error
%    error('iEye:ii_selectbyvalue:invalidConditionalError', 'Invalid input for cond')
end


% if numercal or char, and valid (by virtue of making it this far), get the
% function handle

if isnumeric(cond)
    cond_fcn = default_cond_fcn{cond};
elseif ischar(cond)
    cond_fcn = default_cond_fcn{strcmpi(valid_cond_str,cond)};
else
    cond_fcn = cond;
end



%ii_hideselections;
[ii_data,ii_cfg] = ii_selectempty(ii_data,ii_cfg); % NOTE: do we need this???


sel = ii_cfg.sel;



newsel = cond_fcn(chandata,cval);

% get the beginning/end using diff (I think this will guarantee
% matching dimensions?)
begin_selection = find(diff([0;newsel])== 1);
end_selection   = find(diff([newsel;0])==-1);
% these are the samples where the selection begins, ends

% should definitely be the same size...
assert(numel(begin_selection)==numel(end_selection));

cursel = [reshape(begin_selection,numel(begin_selection),1) reshape(end_selection,numel(end_selection),1)];

%cursel(:,1) = SplitVec(cwhere,'consecutive','firstval');
%cursel(:,2) = SplitVec(cwhere,'consecutive','lastval');

% NOTE: beginning/end of selection can match! this means for plotting,
% etc, need to plot -0.5*sample_rate and +0.5*sample_rate on each side

% leaving this out for above reasons!
% for i = 1:length(cursel)
%     dif = cursel(i,2) - cursel(i,1);
%     if dif < 2
%         cursel(i,2) = cursel(i,2) + 1;
%     else
%     end
% end
% 
% for i=1:(size(cursel,1))
%     sel(cursel(i,1):cursel(i,2)) = 1;
% end

ii_cfg.cursel = cursel;
ii_cfg.sel = newsel;

    

end

