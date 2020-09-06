function c=savitsky_golay_coeffs(x,M)
x=x(:)';
for i=1:size(M,2)
    c(i,:)=x;
    x=[x(2:end),x(1)];
end
c=M*c;