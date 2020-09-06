function D=ispecgram(s,fs,window,numolap)
d=realifft(s);
[N,M]=size(d);
P=N-numolap;
D=zeros(P*M+numolap,1);
D1=D;
for i=1:M
    D((i-1)*P+[1:N])=D((i-1)*P+[1:N])+d(:,i);
    D1((i-1)*P+[1:N])=D1((i-1)*P+[1:N])+window;
end
ix=find(D1>.95*max(D1));D1=D1(ix);
D=D/median(D1);