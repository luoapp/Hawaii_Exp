function send_data(data,name,type)
global common_dir_
if length(common_dir_)==0
    get_common_dir
end
if ~exist('type','var')
    type='.mat';
end
switch type
    case '.mat'
        save([common_dir_,'\',name,'.tmp'],'data');
        eval(['!rename ',common_dir_,'\',name,'.tmp ',name,'.mat']);
    otherwise
        error('bad type');
end


