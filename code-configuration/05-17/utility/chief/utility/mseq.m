function [s,cs]=mseq(N)
N2=2^floor(log2(N));
c=[];
while N
    c=[mod(N,2);c];
    N=floor(N/2);
end
m=zeros(size(c));m(1)=1;
s=[];
for i=1:N2-1
    if m(1)==1
        s(i)=1;
        m=m~=c;
        m=[m(2:end);0];
    else
        s(i)=0;
        m=[m(2:end);0];
    end
end
c1=round(cc(s,s));
if all(c1(2:end)==c1(2)) & sum(s)==(length(s)+1)/2
    s1=[s,s(1:length(c))];
    pow2=flipud(2.^[0:length(c)-2]');
    Mp2=sum(pow2)+1;
    for i=1:length(s)
        cs(i)=exp(sqrt(-1)*(s1(i:i+length(pow2)-1)*pow2)*2*pi/Mp2);
        %cs(i)=(s1(i:i+length(pow2)-1)*pow2);
    end
else
    s=[];
    cs=[];
end
    
    