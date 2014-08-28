ii_stats = evalin('base','ii_stats');
pvels = [];

for i = 1:16
    pvels = [pvels; ii_stats(i).ms_peak_velocity];
end

median(pvels)
putvar(pvels);