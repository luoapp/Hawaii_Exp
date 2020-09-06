function Hex=hex_patch
Hex=patch_define('uv_rectangle',[1 1],1,1,1,1);
Hex{1}([1,3,4,7,9],1)=Hex{1}([1,3,4,7,9],1)*cos(pi/3);
Hex{1}([1,3,4,6,7,9],2)=Hex{1}([1,3,4,6,7,9],2)*cos(pi/6);