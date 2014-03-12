function procm()
%PROCM Summary of this function goes here
%   Detailed explanation goes here

% Specify run #
r = 1;

ii_cfg = evalin('base','ii_cfg');

% Create trial compliance matrix
trial_compliance = ones(30,3);

% Open trial compliance window
tComp;
end

