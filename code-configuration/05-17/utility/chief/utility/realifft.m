function f=realifft(d,odd)
if nargin<2
   odd=0;
end
if odd
   d=[d;conj(d(end:-1:2,:))];
else
   d=[d;conj(d(end-1:-1:2,:))];
end
f=real(ifft(d));
