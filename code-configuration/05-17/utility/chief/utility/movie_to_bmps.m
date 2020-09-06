function movie_to_bmps(M,file,reverse)
if ~exist('reverse')
   reverse=0;
end
frames=[1:size(M,2)];
if reverse
   frames=[frames,size(M,2)-1:-1:2];
end
for i=1:length(frames)
   [m,map]=frame2im(M(:,frames(i)));
   if length(map)==0
      eval(sprintf('imwrite(m,''%s%03d.bmp'');',file,i));
   else      
      eval(sprintf('imwrite(m,map,''%s%03d.bmp'');',file,i));
   end
end