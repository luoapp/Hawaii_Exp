function y=normalize(x)
d1=realsqrt(sum(x.*x,2));
d=d1+(d1==0);
d=repmat(d,1,size(x,2));
y=x./d;
y(:,1)=y(:,1)+(d1==0);