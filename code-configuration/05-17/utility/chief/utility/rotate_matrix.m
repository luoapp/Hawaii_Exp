function out=rotate_matrix(in,len,dim)
if (nargin<3)
   dim=1;
end
if dim==1
	in=in';
end
s=size(in);
if length(len)==1 %rotate by scalar
   s=s(2);
   s=1+mod(len-1+[1:s],s);
   out=in(:,s);
else %rotate by vector
   if s(1)~=length(len)
      error('rotate-by vector must be same length as matrix dimension');
   end
   s=s(2);
   out=zeros(size(in));
   for i=1:length(len)
      s1=1+mod(len(i)-1+[1:s],s);
      out(i,:)=in(i,s1);
   end
end
if dim==1
	out=out';
end