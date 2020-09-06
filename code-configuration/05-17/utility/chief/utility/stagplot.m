function p=stagplot(x,pct,norm)
%
%	function p=stagplot(x,pct,norm)
%
%	function to offset the successive columns of x by a
%	percent of the max value of all columns, giving a staggered effect.
%	pct is the percent of the max to offset,
%	norm is the normalizing option: 0 =no normalization,
%	1=normalize each column before plotting
%
pct=pct/100;
s=size(x);
if norm==1
	for i=1:s(2)
		m=max(abs(x(:,i))); 
		m=m+(m==0);
		x(:,i)=x(:,i)/m;
	end
end
m=max(max(x)); m=m+(m==0);
p=x;
for i=1:s(2)
	p(:,i)=x(:,i)+(pct*(i-1))*m;
end
return
