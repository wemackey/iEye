function [ ii_plotparams ] = ii_loadplotparams( params_fn )
%ii_loadparams Load pre/processing parameters
%   To use automated pre-processing function ii_preproc, must define a set
%   of params for each stage of pre/processing. If no params_fn given, then
%   default parameters will be loaded.
%
% Edit this function to update default parameters for your setup (or you
% could modify this to load a default_params.mat file - but seems easier to
% read putting it in a text file like this)
%
% TODO: add flags for whether or not to run each piece of preproc? maybe
% better in a 'flags' suffix of ii_preproc.m...

% Tommy Sprague, 8/21/2017


if nargin < 1
    
    
    tmp_lines = lines(7); % colors we draw from
    
    % DEFAULT PARAMETER VALUES
    ii_plotparams.EXCL_COLOR = [0.8 0 0]; % color to draw excluded trials in
    
    ii_plotparams.RAW_COLORS = tmp_lines([1 2],:); % for 1d traces (X,Y)

    ii_plotparams.SACC_COLORS = tmp_lines([4 5],:);% for primary; final saccade overlay

    
    % maximum ecc to which we plot (15 deg is aperture size in scanner)
    ii_plotparams.MAXECC = 15;
    
else
    
    ii_plotparams = load(params_fn);
    
    % handle case where saved as ii_params w/in file
    if ismember('ii_plotparams',fieldnames(ii_plotparams))
        ii_plotparams = ii_plotparams.ii_plotparams;
    end
       
end


end

