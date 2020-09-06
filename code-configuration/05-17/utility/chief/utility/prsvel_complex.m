function [p,v]=prsvel_complex(src,fld,k,rhoc)
%function [p,v]=prs(s,f,k,rhoc,norm)
%s=source points (Nx3),
%f=field points(Mx3),
%k=wavenumber, 
%rhoc=rho*c,
%
%p and v are matrices of complex pressures and normal velocities, both NxM.
p=zeros(size(src,1),size(fld,1));
v=zeros([size(src,1),size(fld,1),3]);
I=sqrt(-1);
amax=sqrt(sum(imag(src).^2,2))
srccor=exp(-k*amax)
if size(src,1)>size(fld,1) %if long and skinny
   for i=1:size(fld,1)
      d=dist(src,fld(i,:));
      d1=1./d;
      e=exp(-I*k*d);
      P=e.*d1;
      P=P.*srccor;
      p(:,i)=P*(I*rhoc*k);
      V=-P.*(d1.^2+I*k.*d1);
      v1=src-repmat(fld(i,:),size(src,1),1);
      %v1n=sum(v1.*norm,2);
      v(:,i,:)=repmat(V,1,3).*v1;
   end   
else
   for i=1:size(src,1)
      d=dist(fld,src(i,:)).';
      d1=1./d;
      e=exp(-I*k*d);
      P=e.*d1;
      P=P*srccor(i);
      p(i,:)=P*(I*rhoc*k);
      V=-P.*(d1.^2+I*k.*d1);
      v1=repmat(src(i,:),size(fld,1),1)-fld;
	  %nr=repmat(norm(i,:),size(fld,1),1);
      %v1n=sum(v1.*nr,2).';
      v(i,:,:)=repmat(V.',[1,3]).*v1;
   end   
end
