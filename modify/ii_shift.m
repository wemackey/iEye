function [ shft ] = ii_shift( chan, val )
%II_SHIFT Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 2
    prompt = {'Channel', '# Samples'};
    dlg_title = 'Shift Time';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    chan = answer{1};
    val = str2num(answer{2});
end

basevars = evalin('base','who');
disp(val);

if ismember(chan,basevars)
    c = evalin('base',chan);
    csize = size(c);
    shft = [ ];
    
    if val > 0
        ix = val + 1;
        for z = 1:val
            shft(z,1) = 0;
        end
        
        for g = 1:(csize - val)
            shft(ix) = c(g);
            ix = ix + 1;
        end
    elseif val < 0
        val = abs(val);
        ix = val + 1;
        
        for z = 1:(csize - val)
            shft(z,1) = c(ix);
            ix = ix + 1;
        end
        
        for g = (csize - val):csize
            shft(g,1) = 0;
        end
    else
        disp('Value of 0 is invalid')
    end
    
    assignin('base',chan,shft);
    
else
    disp('Channel does not exist')
end

end

