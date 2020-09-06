function z=exact_convolve(x,y,TimeFreq,TruncAmp)
%z=exact_convolve(x,y,TimeFreq)
%
%perform an exact convolution with minimum padding
%
%Inputs: (omitting a value or value=[] is default):
%x and y are signals or impulse responses; x is always a time domain signal. Y can be either time or frequency domain subject to:
%if y is a complex vector, it is assumed to be frequency domain responses at the output frequencies
%   of 'frequencies_for_exact_convolve' (q.v.).
%TimeFreq='time' (default) returns the output in the time domain with all samples in the convolution guaranteed to be present.
%TimeFreq='freq' returns the positive part of the spectrum.
%TruncAmp is the relative amplitude to use (in dB) when truncating the tail of the signal 
%    (throw away small values at the end), default 1E-4.
if ~exist('TimeFreq','var')
    TimeFreq='time';
end
if ~exist('TruncAmp','var')
    TruncAmp=[];
end
if length(TimeFreq)==0
    TimeFreq='time';
end

if size(x,1)==1
    x=x(:);
end
if size(y,1)==1
    y=y(:);
end
yf=0;
if any(imag(y))~=0
    yf=1;
end
if yf
    X=x;
    len=length(X);
else
    len=nearest_small_factor(length(x)+length(y)+1,1,1);
    X=[x;zeros(len-length(x),1)];
end
if yf
    X=realfft(X);
    Y=[y;zeros(length(X)-length(y),1)];
    Z=X.*Y;
else
    Y=[y;zeros(len-length(y),1)];
    Z=realfft(X).*realfft(Y);
end
switch TimeFreq
case 'freq'
    return
case 'time'
    z=realifft(Z);
    if length(TruncAmp)>0
        zm=abs(z);
        ix=find(flipud(zm)>max(zm)*(10^(-abs(TruncAmp)/20)));
        if length(ix)==0
            ix=1;
        end
        ix=ix(1);ix=length(z)-ix+1;
        z=z(1:ix);
    end
otherwise
    error('must choose ''time'' or ''freq'' for TimeFreq');
end