function add_subdirs_to_path(d)
if ~exist('d','var')
    d=cd;
end
ud=dir([d,'\*.']);
for i=1:length(ud)
    if ud(i).isdir
        n=ud(i).name;
        switch n
        case '.'
        case '..'
        otherwise
            addpath([d,'\',ud(i).name]);
        end
    end
end