function zoom_image(x,y,z)
switch nargin
case 1
   z=x;
   x=1:size(z,2);
   y=1:size(z,1);
case 2
   error('provide either no x,y series or both x,y series');
case 3
end
zoom_plot([0:1],[0:1]);
imagesc(x,y,z)
ax=gca;
colorbar
axis xy
axes(ax);