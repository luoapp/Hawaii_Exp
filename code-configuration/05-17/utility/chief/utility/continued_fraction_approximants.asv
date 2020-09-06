function [n1,d1]=continued_fraction_approximants(n,d)
%function [n1,d1]=continued_fraction_approximants(n,d)
cf=to_continued_fraction(n,d);
n1=[];d1=[];
for i=1:length(cf)
    [nt,dt]=from_continued_fraction(cf(1:i));
    n1=[n1,nt];d1=[d1,dt];
end