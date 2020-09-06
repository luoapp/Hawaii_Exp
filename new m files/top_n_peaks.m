function [maxs,ixs]=top_n_peaks(d,N,dead,thresh)
dead=[1:dead];dead=dead-round(mean(dead));
for i=1:N
    [m,ix]=max(d);
    if i>1
        if m<max(maxs)*thresh
            break
        end
    end
    maxs(i)=m;
    ixs(i)=ix;
    ix=max(1,ix+dead);
    ix=min(length(d),ix);
    d(ix)=0;
end
[ixs,ix]=sort(ixs);
maxs=maxs(ix);