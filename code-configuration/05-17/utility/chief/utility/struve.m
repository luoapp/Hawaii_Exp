function y=struve(N,x)
s=size(x);
if N~=1
    error('only 1 allowed now');
end
x=x(:);
L=18;
y=zeros(size(x));
ix1=find(x<L);
ix2=find(x>=L);
if length(ix1)>0
    i=1:30;
    rat=(2*i-1).*(2*i+1);
    rat=-x(ix1).^2*(1./rat);
    rat=cumprod(rat,2);
    y(ix1)=sum(rat,2)*(-2/pi);
end
if length(ix2)>0
    y(ix2)=2/pi+sqrt(2/pi./x(ix2)).*sin(x(ix2)-3*pi/4);
end
y=reshape(x,s);
