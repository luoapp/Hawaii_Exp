function [OK,unknownprm]=newvarsdlg(prmlist)

prmval={};
prmlen=[];
prmdisp={};
for i=1:length(prmlist)
    try
        pv=evalin('caller',prmlist{i},' ');
    catch
        pv=0;
    end
    if min(size(pv))==1
        prmval{i}=sprintf('%g ',pv);
    else
        p='';
        for j=1:size(pv,1)
            p=[p,sprintf('%g ',pv(j,:)),';'];
        end
        prmval{i}=p(1:end-1);
    end
    prmlen(i)=length(pv);
end
Answer = inputdlg(prmlist,...
    'Enter Parameters',...
    repmat([1 100],length(prmlist),1),prmval);
if length(Answer)==0
    OK=0;
    unknownprm=[];
    return
end
unknownprm=[];
num_unknown=0;
for i=1:length(prmlist)
    if length(Answer{i})==0
        num_unknown=num_unknown+1;
        unknownprm(end+1)=i;
    elseif all(Answer{i}==' ')
        num_unknown=num_unknown+1;
        unknownprm(end+1)=i;
    else
        eval(sprintf('%s=[%s];',prmlist{i},Answer{i}));
        assignin('caller',prmlist{i},eval(['[',Answer{i},']']));
    end
end
OK=1;