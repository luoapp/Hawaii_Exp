function zoom_image(x,y,z,w,r,f)
zoom_plot([0:1],[0:1]);
switch nargin
case 1
    error('provide both x,y series');
case 2
    scatter(x,y)
case 3
    scatter(x,y,z)
case 4
    scatter(x,y,z,w)
case 5
    scatter(x,y,z,w,r)
case 6
    scatter(x,y,z,w,r,f)
end
