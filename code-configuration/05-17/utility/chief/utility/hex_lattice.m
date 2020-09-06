function xyz2=hex_lattice(N)
%function xyz=hex_lattice(N)
%Generate a hexagonal lattice of points [x,y,0] with unit spacing between adjacent points.
%Lattice is N points on a side.
xy1=gen_all_xyz_combinations(0:N-1,0:N-1,0); %3 out of 6 sides of a cube
xy2=gen_all_xyz_combinations(0:N-1,1:N-1,0);
xy3=gen_all_xyz_combinations(1:N-1,1:N-1,0);
xyz=[xy1;xy2(:,[1,3,2]);xy3(:,[3,1,2])];
xyz1=xyz*(eye(3)/rotate_z_to_vector([1,1,1])); %a cube seen from [Inf,Inf,Inf] looks like what you want.
xyz1=xyz1(:,1:2);
xyz2=xyz1*[cos(pi/12),-sin(pi/12);sin(pi/12),cos(pi/12)]; %rotate_z... needs to be turned
m=(max(xyz2(:,2))-min(xyz2(:,2)))/(2*N-2);
xyz2=xyz2/m;
xyz2=[xyz2,zeros(size(xyz2,1),1)];
xyz2=sortrows(xyz2);