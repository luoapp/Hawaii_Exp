function a=dbremax(d)
%
%	out=db(in)
%
%	get db level of data
%
a=db(d);
a=a-max(flatten(a));