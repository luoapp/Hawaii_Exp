function o=tukey(len,duty)
dls=ceil(len*duty/2);
d=.5-.5*cos(pi*(0:dls-1)/dls);
o=[d,ones(1,len-2*dls),fliplr(d)]';