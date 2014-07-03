function kill_trash()
%KILL_TRASH Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(ii_stats)
    ii_stats(i).trash = ones(30,1);
end

r = 3;
ind = 30;

ii_stats(r).trash(ind) = 0;
disp(ii_stats(r).primary_err_z(ind));
disp(ii_stats(r).primary_gain_z(ind));
end

