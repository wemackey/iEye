function plotErr( chan )
%PLOTERR Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 1
    prompt = {'Enter Matrix:'};
    dlg_title = 'Plot';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
end

basevars = evalin('base','who');

if ismember(chan,basevars)
    ichan = evalin('base',chan);
    rsize = size(ichan,1);
    csize = size(ichan,2);
    
    figure;
    
    hold all
    plot(0,0);
    plot(1,ichan(1,1:30),'m:o');
    plot(2,ichan(2,1:30),'m:o');
    plot(3,ichan(3,1:30),'r:o');
    plot(4,ichan(4,1:30),'r:o');
    plot(5,ichan(5,1:30),'r:o');
    plot(6,ichan(6,1:30),'r:o');
    plot(7,ichan(7,1:30),'r:o');
    plot(8,ichan(8,1:30),'r:o');
    plot(9,ichan(9,1:30),'r:o');
    plot(10,ichan(10,1:30));
    
    
else
    disp('Channel does not exist')
end

end

