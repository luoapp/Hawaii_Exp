function D=padded_medfilt2(d,N,M)
d1=zeros(size(d)+2*[N,M]);
%pad be continuing values, not just adding 0s
d1(N+[1:size(d,1)],M+[1:size(d,2)])=d;
d1(1:N,1:M)=d(1,1);
d1(N+[1:size(d,1)],1:M)=repmat(d(:,1),1,M);
d1(end-N+[1:N],1:M)=d(end,1);
d1(1:N,M+[1:size(d,2)])=repmat(d(1,:),N,1);
d1(1:N,end-M+[1:M])=d(1,end);
d1(N+[1:size(d,1)],end-M+[1:M])=repmat(d(:,end),1,M);
d1(end-N+[1:N],M+[1:size(d,2)])=repmat(d(end,:),N,1);
d1(end-N+[1:N],end-M+[1:M])=d(end,end);
D=zeros(size(d));
Ni=[-N:N]+N;
Mj=[-M:M]+M;
for i=1:size(d,1)
    for j=1:size(d,2)
        D(i,j)=median(flatten(d1(i+Ni,j+Mj)));
    end
end
