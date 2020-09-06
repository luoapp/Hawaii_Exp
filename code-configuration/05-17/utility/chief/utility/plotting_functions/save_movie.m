function save_movie(M,name)
Pos=get(gcf,'Position');
eval(['save ',name,' M Pos']);