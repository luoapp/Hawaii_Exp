function play_saved_movie(name,reps,speed)
eval(['load ',name])
figure;
set(gcf,'Position',Pos);
if exist('speed')
   movie(M,reps,speed)
else
   movie(M,reps)
end