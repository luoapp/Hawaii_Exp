function handle=master_zoom_plot_control(arg)
%
%	function master_zoom_plot_control(arg)
%
%	function to create, control a zoom plot
%	call with no args to create a new one
%
global Pts LastXY LastFigure
if nargin==0
	master_zoom_plot;
	handle=gcf;
	set(handle,'WindowButtonUpFcn','master_zoom_plot_control bu');
	return
end
f=gcf;
if strcmp(arg,'Show')
	mat=find_tag(f,'MainAxes');
   aat=find_tag(f,'AuxAxes');
   vit=find_tag(f,'Visibility');
	ch=get(f,'Children');
	for i=1:length(ch)
		if (ch(i)~=mat)&(ch(i)~=aat&ch(i)~=vit)
			set(ch(i),'Visible','on');
		end
	end
   %set(get(mat,'Title'),'Visible','on');
	return	
end	
if strcmp(arg,'Hide')
	mat=find_tag(f,'MainAxes');
	aat=find_tag(f,'AuxAxes');
   vit=find_tag(f,'Visibility');
	ch=get(f,'Children');
	for i=1:length(ch)
		if (ch(i)~=mat)&(ch(i)~=aat &ch(i)~=vit)
			set(ch(i),'Visible','off');
		end
   end
   %set(get(mat,'Title'),'Visible','off');
	return	
end	
h=get(f,'CurrentObject');
if h==f
   return
end
if length(h)==0
   return
end
while get(h,'Parent')~=f
   h=get(h,'Parent');
end
co=get(h,'Tag');
if strcmp(co,'MainAxes') | length(co)==0
   pos=get(f,'CurrentPoint');
   lasterr('');
   eval('set(h,''Units'',''pixels'');','');
   if ~(length(lasterr))
      pos1=get(h,'Position');
   end
   ax=h;%find_tag(f,'MainAxes');
   set(ax,'Units','pixels');
   axpos=get(ax,'Position');
   if (pos(1)>=axpos(1))&(pos(1)<=axpos(1)+axpos(3))&(pos(2)>=axpos(2))&(pos(2)<=axpos(2)+axpos(4))
      xl=get(ax,'XLim');
      yl=get(ax,'YLim');
      curx=xl(1)+(xl(2)-xl(1))*(pos(1)-axpos(1))/axpos(3);
      cury=yl(1)+(yl(2)-yl(1))*(pos(2)-axpos(2))/axpos(4);
      xy=[curx cury];
      LastFigure=gcf;
      if exist('LastXY')&length(LastXY)
         dxy=xy-LastXY;
         LastXY=xy;
         xyt=sprintf('%g, %g, %g, %g',xy(1),xy(2),dxy(1),dxy(2));
      else
         LastXY=xy;
         xyt=sprintf('%g, %g',xy(1),xy(2));
      end
      set(find_tag(f,'DispXY'),'String',xyt);
      if ~exist('Pts')
         Pts=[curx cury];
      else
         Pts=[[curx cury];Pts];
      end
      ps=size(Pts);
      if ps(1)>200
         Pts=Pts(1:200,:);
      end
      return
   end
end
c=get(f,'Children');c=c(1);
switch(co)
 case 'ZoomX'
   pos=get(h,'Value');
   set(h,'Value',0);
	ax=c(1);%find_tag(f,'MainAxes');
	xl=get(ax,'XLim'); %get current limits
	xc=xl(1);	%find center
	xw=xl(2)-xc;	%and half width
	xw=xw*2^(-pos);	%scale from 1/4 to 4
	set(ax,'XLim',[xc,xc+xw]);
	return
 case 'ZoomY'
   pos=get(h,'Value');
   set(h,'Value',0);
	ax=c(1);%find_tag(f,'MainAxes');
	xl=get(ax,'YLim'); %get current limits
	xc=xl(1);	%find center
	xw=xl(2)-xc;	%and half width
	xw=xw*2^(-pos);	%scale from 1/4 to 4
	set(ax,'YLim',[xc,xc+xw]);
	ax=find_tag(f,'AuxAxes');
	set(ax,'YLim',[xc,xc+xw]);
	return
 case 'PanX'
   pos=get(h,'Value');
   set(h,'Value',0);
	ax=c(1);%find_tag(f,'MainAxes');
	xl=get(ax,'XLim'); %get current limits
	xc=xl(1);	%find center
	xw=xl(2)-xc;	%and half width
	xc=xc+xw*(-0.5*pos);	%pan from -fs to fs
	set(ax,'XLim',[xc,xc+xw]);
	return
 case 'PanY'
	pos=get(h,'Value');
   set(h,'Value',0);
	ax=c(1);%find_tag(f,'MainAxes');
	xl=get(ax,'YLim'); %get current limits
	xc=xl(1);	%find center
	xw=xl(2)-xc;	%and half width
	xc=xc+xw*(-0.5*pos);	%pan from -fs to fs
	set(ax,'YLim',[xc,xc+xw]);
	ax=find_tag(f,'AuxAxes');
	set(ax,'YLim',[xc,xc+xw]);
	return
end