function m=meddev(d,sig)
if ~exist('sig','var')
    sig=.5;
end
[m,ix]=sort(abs(d-median(d)));
ix1=round(sig*length(m));
ix1=max(1,ix1);
ix1=min(length(m),ix1);
m=m(ix1);