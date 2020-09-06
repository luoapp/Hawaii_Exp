function y=analytic(x,cf,wid,sr)
%
%    y=analytic(x,center,width[,sample_rate])
%
%    compute the lowpass-filtered complex representation of a signal
%
%    x=data series to be processed (length=power of 2)
%    center=center frequency (normalized to SR=1 if sample rate not included)
%    width=half power bandwidth (normalized to SR=1 if sample rate not  included)
%
if nargin<4
	sr=1;
end
cf=cf/sr;
wid=wid/sr;
s=size(x);
if s(1)==1
    x=x';
end
cols=s(2);
s=s(1);
cf=fix(cf*s)/s;  %make sure cf is an exact bin
%convolve in the freq domain with delta at -cf
c=exp((0:s-1)*((-2)*pi*cf*j)); %by multiplying by cpx exponential
c=c';
for i=1:cols
	x(:,i)=x(:,i).*c;
end
y=fft(x);
%build gaussian filter in freq domain
c=(2/0.85)*(0:(s+mod(s,2))/2)/(s*wid);
c=2.^(-c.*c);
c=[c,c((s-mod(s,2))/2-1:-1:1)]';
%do filtering operation
for i=1:cols
	y(:,i)=ifft(y(:,i).*c);
end

return