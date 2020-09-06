function [p,v]=prsvel_cpx(src,fld,k,rhoc,norm)
%function prsvel_cpx(src,fld,k,rhoc,norm)
%
%complex source, field point version of prsvel
%normals associated with source points
p=zeros(size(src,1),size(fld,1));
v=p;
I=sqrt(-1);
norm=normalize(norm);
if size(src,1)>size(fld,1) %if long and skinny
   for i=1:size(fld,1)
      d=dist(src,fld(i,:));
      d1=1./d;
      e=exp(-I*k*d);
      P=e.*d1;
      p(:,i)=P*(I*rhoc*k);
      V=-P.*(d1.^2+I*k.*d1);
      v1=src-repmat(fld(i,:),size(src,1),1);
      v1n=sum(v1.*norm,2);
      v(:,i)=v1n.*V;
   end   
else
   for i=1:size(src,1)
      d=dist(src(i,:),fld);
      d1=1./d;
      e=exp(-I*k*d);
      P=e.*d1;
      p(i,:)=P*(I*rhoc*k);
      V=-P.*(d1.^2+I*k.*d1);
      v1=repmat(src(i,:),size(fld,1),1)-fld;
		nr=repmat(norm(i,:),size(fld,1),1);
      v1n=sum(v1.*nr,2).';
      v(i,:)=v1n.*V;
   end   
end