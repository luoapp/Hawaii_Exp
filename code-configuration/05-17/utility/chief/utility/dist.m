function p=dist(s,f)
%gives matrix of distances from s to f N(src)xN(field)
[Frows,t]=size(f);
[Srows,t]=size(s);
p=zeros(Srows,Frows);
for i=1:Frows
   r=s-repmat(f(i,:),Srows,1);
   r=sum(r.*r,2);
   r=sqrt(r);
   p(:,i)=r;
end