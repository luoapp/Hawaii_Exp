function [fD,F,T,cztD,Ns]=specgram_czt(st,SR,F1,F2,timeW,delT)
%function [SG,F,T]=specgram_czt(Data,SR,F1,F2,timeW,delT)
%Data:input data, SR:sample rate, F1,F2:lower and upper
%frequencies,timeW:window width,delT:time advance for overlapping
I=sqrt(-1);
N=nearest_small_factor(timeW*SR);
Olap=round(delT*SR);
Fdel=(F2-F1)/N;
A=exp(I*2*pi*F1/SR);
W=exp(-I*2*pi*Fdel/SR);
S=sin(pi*[0:N-1]'/N).^2;
F=(F1+Fdel*[0:N-1]');
clear cztD
i=0;

while 1
    i=i+1;
    try
        cztD(:,i)=st((i-1)*Olap+[1:N]).*S;
        Ns(i)=(i-1)*Olap;
    catch
        break
    end
end
[N,M]=size(cztD);
T=N/SR*.5+Olap*[.5:M-.5]'/SR;
if nargout>3
    fD=[];
    return
end
fD = czt(cztD, N, W, A);
