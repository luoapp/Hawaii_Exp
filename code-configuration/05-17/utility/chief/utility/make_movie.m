function [m,lims]=make_movie(a1,a2)
if nargin==1
    a2=a1;
    a1=size(a2); a1=1:a1(1);
end
h=figure;
cols=size(a2); rows=cols(1); cols=cols(2);
a1cols=size(a1); a1rows=a1cols(1); a1cols=a1cols(2);
mx=max(max(a2));
mn=min(min(a2));
mnx=min(min(a1)); mxx=max(max(a1));
for i=1:cols
    if i==1
	if a1rows==1
            plot(a1,a2(:,i)');
	else
	    plot(a1(:,i)',a2(:,i)');
	end
	lims=axis;
	lims(1)=mnx; lims(2)=mxx; lims(3)=mn; lims(4)=mx;
	axis(lims);
	m=moviein(cols);
    else
	if a1rows==1
	    plot(a1,a2(:,i)');
	else
	    plot(a1(:,i)',a2(:,i)');
	end
	axis(lims);
    end
    m(:,i)=getframe;
end