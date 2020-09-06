function global_writeout(filename,header_string,global_results)


% WRITES OUT SPREADSHEET DATA, WHICH HAS BEEN FORMATTED BY THE global_output ROUTINE,
% TO A DISK FILE SPECIFIED BY THE USER. 
%
% CALLING CONVENTION IS:
%
% global_writeout(filename,header_string,global_results)
%
% WHERE filename DENOTES THE NAME OF THE FILE WHERE THE OUTPUT IS TO BE PLACED; 
% header_string DENOTES THE HEADERS TO APPEAR IN THE SPREADSHEET (TOP ROW);
% AND global_results DENOTES THE OUTPUT RETURNED BY THE ROUTINE global_output.
%
% THE FORM THAT SHOULD BE USED TO DEFINE header_string IN THE CALLING ROUTINE IS:
%
% header_string=char('header1','header2',...)
%
% WHERE header1,header2, ETC ARE TEXT STRINGS THAT SPECIFY THE DESIRED HEADERS. THE
% HEADERS ARE SEQUENTIALLY APPLIED TO SPREADHSEET COLUMNS. 

fidheader = fopen(filename,'w');
temp1=size(header_string);
number_headers=temp1(1,1);
for i=1:number_headers
    fprintf( fidheader,'%s\t', header_string(i,:));
end
fprintf(fidheader,'\n')

temp=size(global_results);
loopsizevertical=temp(1,1);
loopsizehorizontal=temp(1,2);
for i=2:loopsizevertical
    for j=1:loopsizehorizontal-1
fprintf(fidheader,'%8.7g\t  %8.7g\n',global_results(i,j));
    end
fprintf(fidheader,'%8.4g\n',global_results(i,loopsizehorizontal));
end

fclose(fidheader);

return