function Pout=scale_rotate_xlate_matrix(scale,rot,xlate)
%function Pout=patch_copy(P,scale,rot,xlate)
%P is patch definition
%scale is x,y,z scales [xs,ys,zs]
%if rot is 3-vector of rotate around, first x, then y, then z, then make 3 d matrix
%if rot is a 3x3 rotation matrix: each point is rotated:p'=Rp; xlate is x,y,z offset
pts=eye(3);
if nargin<3
   xlate=[0,0,0];
end
if length(xlate)==0
   xlate=[0,0,0];
end
if nargin<2
   rot=eye(3);
end
if length(rot)==0
   rot=[0,0,0];
end
if size(rot,1)==1 %if vector of x,y,z rotation angles
   rot=rot*pi/180; %input in degrees
   rot=[cos(rot(3)),-sin(rot(3)),0;sin(rot(3)),cos(rot(3)),0;0,0,1]*...
      ([cos(rot(2)),0,-sin(rot(2));0,1,0;sin(rot(2)),0,cos(rot(2))]*...
      [1,0,0;0,cos(rot(1)),-sin(rot(1));0,sin(rot(1)),cos(rot(1))]);
end
if nargin<1
   scale=[1,1,1];
end
if length(scale)==0
   scale=[1,1,1];
end
pts=pts*diag(scale);
pts=pts*rot';
pts=[[pts;xlate(:)'],[0 0 0 1]'];
Pout=pts;      
