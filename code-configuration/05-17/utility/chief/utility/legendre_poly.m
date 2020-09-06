function p=legendre_poly(ord)
if ord==0
   p=1;
   return
end
p=[1,zeros(1,ord);0,1,zeros(1,ord-1)];
for i=1:ord-1
   p=[p;((2*i+1)*[0,p(i+1,1:end-1)]-i*p(i,:))/(i+1)];
end