function Zm=piston_impedance(F,rho,c,a)
%function Zm=piston_impedance(F,rho,c,a)
%
%impedance of a piston in an infinite baffle from Beranek, Kinsler & Frey.
Zm=rho*c*pi*a^2; %constant coefficient
k=2*pi*F/c;
arg=2*k*a;
R=R1(arg);
X=X1(arg);
Zm=Zm*(R+sqrt(-1)*X);

function y=R1(x)
y=1-2*besselj(1,x)./x;

function y=X1(x)
y=2*struve(1,x)./x;
