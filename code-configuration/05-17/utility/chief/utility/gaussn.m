function w=gaussn(N,P,mn,twosided)
%function w=gaussn(N,P,minval,twosided) N=number of points, P=power, minval=end of window,twosided=symmetric
if ~exist('twosided','var')
    twosided=1;
end
if twosided
    x=linspace(-1,1,N)';
else
    x=linspace(0,1,N)';
end
w=exp(log(mn)*abs(x).^P);