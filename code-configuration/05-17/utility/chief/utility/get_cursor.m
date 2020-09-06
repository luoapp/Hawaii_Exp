function [xyc,v,K]=get_cursor(x,y,V)
disp('move cursor over image and click for points');
[xc,yc,K]=ginput;
if ~exist('V')
    v=[];
    xyc=[xc(:),yc(:)];
    if nargout==0
        disp([xyc,K]);
    end
    return
end
for i=1:length(xc)
    x1=interp1(x,[1:length(x)]',xc(i),'linear',0);
    y1=interp1(y,[1:length(y)]',yc(i),'linear',0);
    ix=floor(x1);
    iy=floor(y1);
    x1=x1-ix;
    y1=y1-iy;
    if ix<1
        ix=1;
        x1=0;
    else
        if ix>size(V,2)
            ix=size(V,2)-1;
            x1=1;
        end
    end
    if iy<1
        iy=1;
        y1=0;
    else
        if iy>size(V,1)
            iy=size(V,1)-1;
            y1=1;
        end
    end
    M=V(iy+[0:1],ix+[0:1]);
    v(i)=interp2(M,x1+1,y1+1);
end
xyc=[xc(:),yc(:)];
v=v(:);
if nargout==0
    disp([xyc,v,K]);
end
