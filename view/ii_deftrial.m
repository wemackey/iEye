function ii_deftrial(c1, v1, c2, v2)
%II_TRIALS Summary of this function goes here
%   Detailed explanation goes here


if nargin ~= 4
    prompt = {'Start when Channel', 'is at Value', 'Until Channel', 'is at Value'};
    dlg_title = 'Trial Parameters';
    num_lines = 1;
    answer = inputdlg(prompt,dlg_title,num_lines);
    c1 = answer{1};
    v1 = str2num(answer{2});
    c2 = answer{3};
    v2 = str2num(answer{4});
end
ii_hideselections;
basevars = evalin('base','who');

if ismember(c1,basevars)
    if ismember(c2,basevars)
        thechan = evalin('base',c1);
        thechan2 = evalin('base',c2);
        tsel = thechan*0;
        
        swhere = find(thechan == v1);
        ewhere = find(thechan2 == v2);
        
        tcursel(:,1) = SplitVec(swhere,'consecutive','firstval');
        tcursel(:,2) = SplitVec(ewhere,'consecutive','firstval');
        
        for i=1:(size(tcursel,1))
            tsel(tcursel(i,1):tcursel(i,2)) = 1;
        end
        
        trialnums = zeros(length(thechan));
        
        for i = 1:length(tcursel)
            trialnum(tcursel(i,1):tcursel(i,2)) = i;
        end
                
        putvar(trialnum);
        
    else
        disp('Channel does not exist')
    end
else
    disp('Channel does not exist')
end

end