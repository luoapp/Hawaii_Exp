function [b,M]=savitsky_golay(N,Npts)
%function [b,M]=savitsky_golay(Order,Npts)
%
%filter coefficients for savitsky-golay filter
%poly order Order, Npts number of points to fit poylnomial to.
%b is fir filter coefficients, M is pseudo inverse of matrix
%if Npts<=Order, no effect
if Npts<=N+1
    b=1;a=1;
    return
end
if mod(Npts,2)==0
    Npts=Npts+1;
end
M=[1:Npts]';M=M-mean(M);M=M/max(M);
M=repmat(M,1,N+1).^repmat([0:N],Npts,1);
M=pinv(M);
b=M(1,:)';

    
