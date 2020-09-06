function cf=to_continued_fraction(num,den)
cf=[];
while 1
    cf(end+1)=floor(num/den);
    t=num-cf(end)*den;
    num=den;
    if t~=0
        den=t;
    else
        break
    end
end
    
    