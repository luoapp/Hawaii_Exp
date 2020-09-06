function zoom_image(x,y,z,w,r,q)
zoom_plot([0:1],[0:1]);
switch nargin
case 1
    error('provide both x,y,z series');
case 2
    error('provide both x,y,z series');
case 3
    scatter3(x,y,z)
case 4
    scatter3(x,y,z,w)
case 5
    scatter3(x,y,z,w,r)
case 6
    scatter3(x,y,z,w,r,q)
end
