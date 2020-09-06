function [global_results] = global_output(all_results)

% FORMATS A SERIES OF MATRICES FOR ENTRY INTO AN EXCEL SPREADSHEET.
% CALLING CONVENTION IS:
%
% global_results=global_output(all_results)
%
% WHERE all_results IS A USER-DEFINED CELL ARRAY THAT CONTAINS THE MATRICES 
% THAT ARE TO BE PLACED INTO THE SPREADSHEET. IN THE CALLING ROUTINE, 
% THE CELL ARRAY all_results SHOULD BE DEFINED BY THE USER IN THE FORM: 
%
% all_results={matrix1,matrix2,matrix3,...},
%
% (NOTE THE USE OF BRACES {} ENCLOSING THE LIST ON THE RIGHT) WHERE matrix1,matrix2, 
% ETC DENOTE MATLAB MATRICES OF DIMENSIONALITY m1Xn1, m2Xn2, ETC. 
% THE NUMBER OF COLUMNS IN EACH MATRIX, n1, n2, etc, EACH MUST BE AT LEAST 2.
% NOTE: CELL ELEMENTS FOR UNUSED CELLS HAVE ZEROES PLACED INTO THEM. 
 

number_of_arrays=length(all_results);

test=zeros(number_of_arrays,2);


for i=1:number_of_arrays
    test(i,:)=size(all_results{i});
end

rows=max(test(:,1));
columns=sum(test(:,2));

rows=rows+1; % ADD EXTRA LINE TO ALLOW INFORMATION ON TOP LINE

global_results=zeros(rows,columns);

i_column=0;
for i=1:number_of_arrays
    current_array=all_results{i};
    global_results(1,i_column+1)=test(i,1);
    global_results(1,i_column+2)=test(i,2);
    for j=1:test(i,1)
        for k=1:test(i,2)
        global_results(j+1,k+i_column)=current_array(j,k);
        end
    end
i_column=i_column+test(i,2);
end


return