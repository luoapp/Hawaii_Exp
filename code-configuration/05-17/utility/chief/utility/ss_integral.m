function [t,th]=ss_integral(s0,s1,a)
global uq uw int_pos int_sin int_cos
if length(uq)==0
   [uq,uw]=gauss_quad_coeffs(12);
   int_pos=repmat(uq,1,3);
   uw=uw';
   %int_wt=repmat(uw,1,3);
   int_sin=sin(pi/2*(uq+1)*[1:20]);
   int_cos=cos(pi/2*(uq+1)*[1:20]).*repmat([1:20]*pi/2,length(uq),1);
end
N=size(a,1);
M=size(uq);
s0=repmat(s0,M,1);
s1=repmat(s1,M,1);
s=.5*(s0+s1+(s1-s0).*int_pos)+int_cos(:,1:N)*a;
c=ss(s); %sound speed at intermediate points
dsdu=(s1-s0)/2;
dsdu1=int_cos(:,1:N)*a;
dsdu=dsdu+dsdu1;
t=uw*(sqrt(sum(dsdu.^2,2))./c);
if nargout==2
   th=(s1(1,:)-s0(1,:))/2+sum(a);
   th=normalize(th);
end


