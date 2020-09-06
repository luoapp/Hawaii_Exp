function zoom_plot(x,y,s,x1,y1,s1)
han=master_zoom_plot_control;
ma=find_tag(han,'MainAxes');
axes(ma);
if nargin==1
	plot(x);
elseif nargin==2
	plot(x,y);
elseif nargin==3
	plot(x,y,s);
elseif nargin==4
	plot(x,y,s,x1);
elseif nargin==5
	plot(x,y,s,x1,y1);
elseif nargin==6
	plot(x,y,s,x1,y1,s1);
end
set(ma,'Tag','MainAxes');
