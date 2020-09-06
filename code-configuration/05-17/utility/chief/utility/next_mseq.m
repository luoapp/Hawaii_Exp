function [m,N1,cm]=next_mseq(N)
if mod(N,2)==0
    N=N+1;
end
while 1
    [m,cm]=mseq(N);
    if length(m)>0
        break
    end
    N=N+2;
end
N1=N;