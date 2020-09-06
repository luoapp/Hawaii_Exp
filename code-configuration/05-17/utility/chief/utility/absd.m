function d=absd(s)
if size(s,1)==1
    s=s';
end
d=median(s);
d=sum(abs(s-repmat(d,size(s,1),1)))/(size(s,1)-1);