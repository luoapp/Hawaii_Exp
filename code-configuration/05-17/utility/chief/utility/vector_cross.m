function u=vector_cross(x,y)
if size(x,1)==1
   if size(y,1)>1
      x=repmat(x,size(y,1),1);
   end
end
if size(y,1)==1
   if size(x,1)>1
      y=repmat(y,size(x,1),1);
   end
end
u=[x(:,2).*y(:,3)-y(:,2).*x(:,3),x(:,3).*y(:,1)-x(:,1).*y(:,3),...
      x(:,1).*y(:,2)-y(:,1).*x(:,2)];
