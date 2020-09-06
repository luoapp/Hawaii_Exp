function z=cfm(v1,v2)
S=size(v1);
if length(S)>2
    error('only 2 d arrays');
end
if S(1)==1
    z=repmat(v1,size(v2,1),1);
    return
end
if S(2)==1
    z=repmat(v1,1,size(v2,2));
    return
end