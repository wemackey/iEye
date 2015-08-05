function ii_writeifg(ifg_file,nchan,lchan,schan)
%II_WRITEFILE Summary of this function goes here
%   Detailed explanation goes here

%open file with write permission
fid = fopen(ifg_file, 'w');

%write a line of text
fprintf(fid, '%d\n', nchan);
fprintf(fid, '%s\n', lchan);
fprintf(fid, '%d\n', schan);

%close file
fclose(fid);
end

