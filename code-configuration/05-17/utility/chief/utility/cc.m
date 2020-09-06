function z=cc(x,y)
%circular corr of col vector by cols of matrix
x=conj(realfft(x));
if size(x,2)==1
   x=repmat(x,1,size(y,2));
end
if size(y,2)==1 & size(x,2)>1
   y=repmat(y,1,size(x,2));
end
z=realifft(x.*realfft(y));