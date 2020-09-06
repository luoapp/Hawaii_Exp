function a=db(d)
%
%	out=db(in)
%
%	get db level of data
%
d=abs(d);
d=d+(d==0).*1.0E-200;
a=20.*log10(d);