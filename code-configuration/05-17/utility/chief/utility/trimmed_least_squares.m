function [x,subset,errhist]=trimmed_least_squares(Mat,b,Nsamp,Nthresh)
[M,N]=size(Mat);
cumerr=zeros(M,1);
numtries=cumerr;
if ~exist('Nsamp','var')
    Nsamp=[];
end
if length(Nsamp)==0
    Nsamp=max(round(M/10),N);
end
if ~exist('Nthresh','var')
    Nthresh=[];
end
if length(Nthresh)==0
    Nsamp=max(round(M/2),N);
end
Ntries=ceil(M*10/Nsamp);
for i=1:Ntries
    ix=randperm(M);
    ix=ix(1:Nsamp);
    M1=Mat(ix,:);
    b1=b(ix);
    x=M1\b1;
    be=M1*x;
    err=(be-b1).^2;
    cumerr(ix)=cumerr(ix)+err;
    numtries(ix)=numtries(ix)+1;
end
ix=find(numtries~=0);
rat=cumerr(ix)./numtries(ix);
[errhist,ix1]=sort(rat);
ix1=ix1(1:Nthresh);
errhist=rat(ix1);
subset=ix(ix1);
x=Mat(subset,:)\b(subset,:);
