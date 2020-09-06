function p=get_points(N,msg)
%function p=get_points(N,msg)
%get N points from the current zoom_ figure by clicking the mouse N times.
%msg is displayed to the user as instructions.
%p will be Nx2. If N==0, all points clicked will be returned.
%Note, to reset the points list to null, type
%
%   global Pts
%   Pts=zeros(0,2)
global Pts
if N==0
    Pts=zeros(0,2);
end
disp([msg,' then hit return'])
pause
if N==0
    N=size(Pts,1);
end
p=flipud(Pts(1:N,:));