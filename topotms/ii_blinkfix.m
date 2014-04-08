function ii_blinkfix()
% s = # of samples to delete from the beginning of the file
s = 1600;

% Delete those samples from our variables
X(1:s) = [];
Y(1:s) = [];
TarX(1:s) = [];
TarY(1:s) = [];
Pupil(1:s) = [];
XDAT(1:s) = [];
ii_cfg.sel=X*0;
ii_replot;
end

