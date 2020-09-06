function M=rotate_z_to_vector(v)
%function M=rotate_z_to_vector(v)
%new axes
z=normalize(v);
x=normalize(v.*[1,1,0]);
y=normalize(cross(z,x));
x=cross(y,z);
x1=x;
x1(3)=0;
x1=normalize(x1);
from=[x1;y;[0,0,1]];
to=[x;y;z];
M=(to\from)';
