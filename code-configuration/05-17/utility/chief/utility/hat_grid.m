function [x,y,d]=hat_grid(xy,D,Nx,Ny)
xlim=[min(xy(:,1)),max(xy(:,1))];
%dx=(xlim(2)-xlim(1))/(Nx);
%xlim=xlim+dx*[-1,1];
ylim=[min(xy(:,2)),max(xy(:,2))];
%dy=(ylim(2)-ylim(1))/(Ny);
%ylim=ylim+dy*[-1,1];
ix=(xy(:,1)-xlim(1))/(xlim(2)-xlim(1))*(Nx-1);
iy=(xy(:,2)-ylim(1))/(ylim(2)-ylim(1))*(Ny-1);
x=linspace(xlim(1),xlim(2),Nx);
y=linspace(ylim(1),ylim(2),Ny);
d=zeros(Nx*Ny,1);

nx=floor(ix);ny=floor(iy);
wx=ix-nx;wy=iy-ny;
wx=1-wx;wy=1-wy;
i1=1+ny+nx*Ny;
for i=1:length(i1)
    d(i1(i))=d(i1(i))+D(i)*wx(i)*wy(i);
end

nx=floor(ix);ny=ceil(iy);
wx=ix-nx;wy=ny-iy;
wx=1-wx;wy=1-wy;
i1=1+ny+nx*Ny;
for i=1:length(i1)
    d(i1(i))=d(i1(i))+D(i)*wx(i)*wy(i);
end

nx=ceil(ix);ny=floor(iy);
wx=nx-ix;wy=iy-ny;
wx=1-wx;wy=1-wy;
i1=1+ny+nx*Ny;
for i=1:length(i1)
    d(i1(i))=d(i1(i))+D(i)*wx(i)*wy(i);
end

nx=ceil(ix);ny=ceil(iy);
wx=nx-ix;wy=ny-iy;
wx=1-wx;wy=1-wy;
i1=1+ny+nx*Ny;
for i=1:length(i1)
    d(i1(i))=d(i1(i))+D(i)*wx(i)*wy(i);
end
d=reshape(d,Ny,Nx);