function out=gen_all_combinations(x,y,z)

if nargin<3
   z=0;
end
Lx=length(x);
Ly=length(y);
Lz=length(z);
L=Lx*Ly*Lz;
Ns=0:(L-1);
out=zeros(L,3);
out(:,1)=x(1+floor(Ns/(Ly*Lz))).';
out(:,2)=y(1+mod(floor(Ns/Lz),Ly)).';
out(:,3)=z(1+mod(Ns,Lz)).';
if nargin<3
   out=out(:,[1,2]);
end