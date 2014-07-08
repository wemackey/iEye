function mstep(r)
%MSTEP Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Subject Run #'};
    dlg_title = 'Subject Run #';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    r = str2num(answer{1});
end


% Let's ask just to make sure you aren't writing over data
rr = sprintf('Do you really want to score run # %s', num2str(r));
choice = questdlg(rr, ...
    'WARNING', ...
    'Yes','No','No');
switch choice
    case 'Yes'     
        
        % Get config   

        ii_stats = evalin('base','ii_stats');
        
        % Set up ii_stats file
        % This will be a 1xn (n = # of runs) structure
        
        % Create trial compliance matrix
        ii_stats(r).mstep = zeros(30,1);
        
        putvar(ii_stats,r);

        multistep;
        
    case 'No'
        disp('Cancelled')
end

% j = 0;
% for i=1:10
%     j = j + sum(ii_stats(i).mstep);
% end

end

