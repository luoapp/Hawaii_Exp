function allfigs(figs)
a=axis;
c=get(gca,'CLim');
for i=figs
    figure(i);
    axis(a);
    set(gca,'CLim',c);
    colorbar
end