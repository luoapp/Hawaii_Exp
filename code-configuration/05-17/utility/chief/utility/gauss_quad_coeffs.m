function [x,w]=gauss_quad_coeffs(N)
l=legendre_poly(N);
l=fliplr(l./repmat(diag(l),1,N+1));
x=sort(roots(l(end,:)))';
for i=1:N
   if i==1
      w=polyval(l(i,:),x);
   else
      w=[w;polyval(l(i,:),x)];
   end
end
x=x';
w=w\[2;zeros(N-1,1)];


function p=legendre_poly(ord)
if ord==0
   p=1;
   return
end
p=[1,zeros(1,ord);0,1,zeros(1,ord-1)];
for i=1:ord-1
   p=[p;((2*i+1)*[0,p(i+1,1:end-1)]-i*p(i,:))/(i+1)];
end