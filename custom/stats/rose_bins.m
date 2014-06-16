function [mtx,inds,mt_result,vec_result] = rose_bins(dt,v1,v2,num_runs)
%ROSE_BINS Summary of this function goes here
%   Detailed explanation goes here

for i = 1:num_runs
    mtx(i) = zeros(30,1);
    inds(i) = find(dt(i).corrective_rho > v1 & dt(i).corrective_rho <= v2);
    mtx(i,inds(i)) = 1;
    
    mt_result(i) = dt(i,inds(i));
end

vec_result = [];

for i = 1:num_runs
    vec_result = [vec_result; mt_result(i)];
end
end

