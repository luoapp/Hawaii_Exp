function z=cartesian(fun,x,y)
Nx=length(x);
Ny=length(y);
x=repmat(x(:),1,Ny);
y=repmat(y(:)',Nx,1);
z=eval(fun);