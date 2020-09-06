function out=gen_all_combinations(X,altord)
if ~exist('altord','var')
    altord=0;
end
if altord
    X=fliplr(X);
end
if length(X)==0
    out=[];
    return
end
out=X{end}(:);
for i=length(X)-1:-1:1
    out=[flatten(repmat(X{i}(:)',size(out,1),1)),repmat(out,length(X{i}),1)];
end
if altord
    out=fliplr(out);
end