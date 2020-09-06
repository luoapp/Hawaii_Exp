function p=centroid_peak(x,y,ymin,xlims)
if min(size(y))==1
    y=y(:);
end
x=x(:);
for i=1:size(y,2)
    if exist('xlims','var')
        ix=find(y(:,i)>=ymin & x>=xlims(1) & x<=xlims(2));
    else
        ix=find(y(:,i)>=ymin);
    end
    p(i)=sum(x(ix).*y(ix,i).^2)/sum(y(ix,i).^2);
end
p=p(:);