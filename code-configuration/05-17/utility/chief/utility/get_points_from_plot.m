function [xs,ys]=get_points_from_plot
%function [xs,ys]=get_points_from_plot
%
%pick points from a plot (right click on last point)
x=[];
y=[];
n=0;
but=1;
while but==1
    [xi,yi,but]=ginput(1);
    plot(xi,yi,'go')
    n=n+1;
    x(n,1)=xi;
    y(n,1)=yi;
end
t=1:n;
ts=1:0.1:n;
xs=spline(t,x,ts);
ys=spline(t,y,ts);

