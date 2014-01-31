function [ smoothd ] = ii_smooth(c, typ, degr)
%II_SMOOTH Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 3
    prompt = {'Enter channel to smooth:', 'Type: (moving, lowess, loess, sgolay, rlowess, rloess)', 'Degree'};
    dlg_title = 'Smooth Data';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    
    c = answer{1};
    typ = answer{2};
    degr = str2num(answer{3});
end

basevars = evalin('base','who');

if ismember(c,basevars)
    chan = evalin('base',c);
    
    smoothd = smooth(chan,degr,typ);
    
    %      figure;
    %      plot(chan,'r','LineStyle', '-');
    %      hold all
    %      plot(smoothd,'b','LineStyle', '-');
    %      hold all
    %      clickableLegend('Original','Smoothed','Location', 'Southeast', 'Orientation', 'Horizontal');
    
    %      choice = questdlg('Would you to save smooth?', ...
    %      'Save Changes', ...
    %      'Yes','No','Try Again','No');
    
    %      switch choice
    %         case 'Yes'
    disp('Smooth saved');
    assignin('base',c,smoothd);
    ii_replot;
    %         case 'No'
    %            disp('Smooth not saved');
    %         case 'Try Again'
    %            ii_smooth;
    %      end
    
else
    disp('Channel to smooth to does not exist in workspace');
end
end


