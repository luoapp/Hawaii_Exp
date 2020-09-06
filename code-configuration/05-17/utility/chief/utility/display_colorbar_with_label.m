function display_colorbar_with_label(lab)
colorbar
ax=gca;
ch=get(gcf,'Children');
for i=1:length(ch)
    cb=get(ch(i),'DeleteFcn');
    if length(cb)>=8
        switch(cb(1:8))
            case 'colorbar'
                break
        end
    end
end
axes(ch(i));
ylabel(lab);
axes(ax);
