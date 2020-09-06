function [f,odd]=realfft(d)
f=fft(d);
keep=floor(size(d,1)/2)+1;
f=f(1:keep,:);
odd=mod(size(d,1),2);