function len=veclen(vecs)
%function len=veclen(vecs)
%get the lengths of vectors: vecs is Mx...PxN and len is sum of squares along the last dimension
len=sqrt(sum(vecs.^2,length(size(vecs))));
