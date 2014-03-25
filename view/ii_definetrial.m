function ii_definetrial(c1, v1, c2, v2)
%II_DEFINETRIAL Summary of this function goes here
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

basevars = evalin('base','who');
ii_cfg = evalin('base', 'ii_cfg');

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
        
        tindex = 1;
        
        ii_cfg.tcursel = tcursel;
        ii_cfg.tsel = tsel;
        ii_cfg.tindex = tindex;
        
        putvar(ii_cfg);
        
    else
        disp('Channel does not exist')
    end
else
    disp('Channel does not exist')
end

end

