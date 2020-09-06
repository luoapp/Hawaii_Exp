function [x,X,E]=row_action_project(M,b,mu,delmu,N)
x=zeros(size(M,2),1);
X=zeros(size(x,1),N);
E=zeros(size(b,1),N);
for j=1:N
    for i=1:size(b,1)
        del=M(i,:);
        b1=del*x;
        e=b(i)-b1;
        E(i,j)=e;
        del=del'/(del*del');
        x=x+mu*del*e;
    end
    X(:,j)=x;
    mu=mu*delmu;
    if mu>1.999
        mu=1.999;
    end
end