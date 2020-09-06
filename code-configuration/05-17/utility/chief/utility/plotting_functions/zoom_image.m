function zoom_image(x,y,z,use_colorbar)
switch nargin
case 1
   z=x;
   x=1:size(z,2);
   y=1:size(z,1);
   use_colorbar=1;
case 2
   error('provide either no x,y series or both x,y series');
case 3
   use_colorbar=1;
case 4
end
zoom_plot([0:1],[0:1]);
imagesc(x,y,z)
ax=gca;
if use_colorbar
    colorbar
end
axis xy
axes(ax);