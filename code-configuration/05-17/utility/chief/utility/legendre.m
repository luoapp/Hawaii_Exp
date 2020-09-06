function v=legendre(ord,x)
if ord==0
   v=1;
   return
end
v=[1,x]; %initial values
if ord==1
   return
end
for o=2:ord
   v=[v,((2*o-1)*x*v(o)-(o-1)*v(o-1))/o];
end
