function [coodamp]=get_2d_peaks(data,threshold)
try
    [N,M]=size(data);
    c=ones(size(data)-2);
    row=repmat([1:N-2]',1,3)+repmat([0 1 2],N-2,1); %indices for rows
    col=repmat([1:M-2]',1,3)+repmat([0 1 2],M-2,1); %indices for cols
    for i=1:3
        for j=1:3
            if i==2 & j==2
                continue
            end
            c=c&(data(row(:,2),col(:,2))>=data(row(:,i),col(:,j)));
        end
    end
    ix=find(flatten(c));
    if length(ix)==0
        coodamp=zeros(0,3);
        return
    end
    [c1,c2]=ind2sub([N-2,M-2],ix);
    c1=c1+1;
    c2=c2+1;
    cood=[c1,c2];
    amp=flatten(data(2:end-1,2:end-1));
    amp=amp(ix);
    [amp,ix]=sort(-amp);
    amp=-amp;
    cood=cood(ix,:);
    if exist('threshold')
        ix=find(amp>threshold);
        amp=amp(ix);
        cood=cood(ix,:);
    end
    coodamp=[cood amp];
    return
catch
    error('error - fewer than 3 rows or columns');
end


