function [num,den]=from_continued_fraction(cf)
num=cf(end);
den=1;
for i=length(cf)-1:-1:1
    t=den;
    den=num;
    num=t;
    num=(cf(i))*den+num;
end
    
    