function [d1,d2]=partial_derivatives(O)
%function [d1,d2]=partial_derivatives(O)
%
%evaluate 1st and second derivatives of a function numerically.
%O is the structure of options, including function definition and variable info (see Levmarq).
global FuncEvals
h=O.Function;
a=O.Variables;
if ~isfield(O,'Shape')
    O.Shape=size(a);
end
if ~isfield(O,'Fixed')
    O.Fixed=zeros(size(a));
end
if ~isfield(O,'DerivDelta')
    O.DerivDelta=.001*ones(size(a));
end
if ~isfield(O,'var_ix')
    O.var_ix=find(~O.Fixed);
    O.fix_ix=find(O.Fixed);
end
var_ix=O.var_ix;
fix_ix=O.fix_ix;
N=length(var_ix);
d1=zeros(N,1);
d2=zeros(N,N);
if isfield(O,'DerivDelta')
    del=flatten(O.DerivDelta);
else
    del=.001;
end
a=flatten(a);
del=flatten(del);
a0=a(fix_ix);
if length(del)==1
    del=repmat(del,size(a));
end
del=del(var_ix);
FuncEvals=FuncEvals+N*(2+4*(N+1)/2);
for i=1:N
    deli=del(i);
    a1=a(var_ix);
    a1(i)=a1(i)-deli;
    aeval(fix_ix)=a0;
    aeval(var_ix)=a1;
    tm=feval(h,reshape(aeval,O.Shape),O);
    a1(i)=a1(i)+2*deli;
    aeval(fix_ix)=a0;
    aeval(var_ix)=a1;
    tp=feval(h,reshape(aeval,O.Shape),O);
    d1(i)=(tp-tm)/(2*deli);
    for j=i:N
        delj=del(j);
        a2=a(var_ix);
        
        a2(i)=a2(i)-deli;
        a2(j)=a2(j)-delj;
        aeval(fix_ix)=a0;
        aeval(var_ix)=a2;
        tmm=feval(h,reshape(aeval,O.Shape),O);
        
        a2(j)=a2(j)+2*delj;
        aeval(fix_ix)=a0;
        aeval(var_ix)=a2;
        tmp=feval(h,reshape(aeval,O.Shape),O);
        
        a2(i)=a2(i)+2*deli;
        a2(j)=a2(j)-2*delj;
        aeval(fix_ix)=a0;
        aeval(var_ix)=a2;
        tpm=feval(h,reshape(aeval,O.Shape),O);
        
        a2(j)=a2(j)+2*delj;
        aeval(fix_ix)=a0;
        aeval(var_ix)=a2;
        tpp=feval(h,reshape(aeval,O.Shape),O);
        
        d2(i,j)=(tpp+tmm-tmp-tpm)/(4*deli*delj);
        if i==j
            d2(i,j)=d2(i,j)/2;
        end
    end
end
d2=d2+d2';
