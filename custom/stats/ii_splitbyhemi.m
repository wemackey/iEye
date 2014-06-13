function [l,r,l_all,r_all] = ii_splitbyhemi(dat,num_runs,l_mtx,r_mtx)
%II_SPLITBYHEMI Summary of this function goes here
%   Detailed explanation goes here

% Left
for i = 1:num_runs
    l_inds = find(l_mtx==1); % Get good trials
    
    % Error
    l(i) = dat(l_inds);
end

% Right
for i = 1:num_runs
    r_inds = find(r_mtx==1); % Get good trials
    
    % Error
    r(i) = dat(r_inds);
end

l_all = [];
r_all = [];

% All trials
for j = 1:num_runs   
    % left   
    l_all = [l_all; l(j)];
    r_all = [r_all; l(j)];
end
end

