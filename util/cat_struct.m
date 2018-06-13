function s_combined = cat_struct(s1,s2,skip_fields)
%cat_struct Combines structures that have the same format by concatenating
%fields:
%   [s_combined] = cat_struct(s1,s2) loops over all fields in s2 and
%   concatenates them with matching fields in s1
%
%   [s_combined] = cat_struct(s1,s2,skip_fields) does not apply
%   concatenation operation to fields with names matching those in
%   skip_fields
%
%   [s_combined] = cat_struct([],s2,...) returns s2 - useful for looping
%   over a set of structs and concatenating element 1,2, then [1,2],3,etc. 
%
% cat_struct is recursive such that it will concatenate sub-structs as
% well (at present, no support for skipping those fields...)
%
% cat_struct always VERTICALLY concatenates; it's assumed that you want to
% stack data on top of each other.
%
% When a field is a string, cat_struct creates a cell array (vertical) of
% strings
%

% which fields do we not concatenate (will use s1's values)?

% include ability to loop over an arbitrary length of structs to cat, whcih
% means the first time you're cat'ing w/ nothing (replicates pattern of:
% my data = []; for ii = 1:10; mydata = [mydata; rand(5,1)]; end;
if isempty(s1) || (isstruct(s1) && isempty(fieldnames(s1)))
    s_combined = s2;
    return;
end

if nargin < 3
    skip_fields = {};
end

fields_to_cat = setdiff(fieldnames(s1),skip_fields);


% initialize s_combined to be s1, then loop over and add elements of s2
s_combined = s1; % (we do this so that skipped fields are still populated)

for ff = 1:length(fields_to_cat)
    
    if isstruct(s1.(fields_to_cat{ff}))
        s_combined.(fields_to_cat{ff}) = cat_struct(s1.(fields_to_cat{ff}),s2.(fields_to_cat{ff}));
    
        
    elseif ischar(s1.(fields_to_cat{ff}))
        
        s_combined.(fields_to_cat{ff}) = {s1.(fields_to_cat{ff});s2.(fields_to_cat{ff})};
        
    else
        
        s_combined.(fields_to_cat{ff}) = vertcat(s1.(fields_to_cat{ff}),s2.(fields_to_cat{ff}));
        
    end
    
    
    
end




return