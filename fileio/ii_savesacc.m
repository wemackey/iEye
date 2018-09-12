function ii_savesacc( ii_cfg, ii_sacc, filename )
%ii_savesacc Saves saccade information
%   ii_savesacc(ii_cfg,ii_sacc) saves to a default filename
%   (ii_cfg.edf_fn_sacc.mat)
%
%   ii_savesacc(ii_cfg,ii_sacc,filename) saves to specified filename
%
% Resulting file will contain ii_cfg and ii_sacc structures (NOT ii_data)
%

% Tommy Sprague, 8/20/17

if nargin < 3
    filename = sprintf('%s_sacc.mat',ii_cfg.edf_file(1:end-4));
end

save(filename,'ii_cfg','ii_sacc');

end

