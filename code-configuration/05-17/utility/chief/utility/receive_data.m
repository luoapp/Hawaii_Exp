function out=receive_data(name,timeout,type)
global common_dir_
if length(common_dir_)==0
    get_common_dir
end
if ~exist('timeout','var')
    timeout=[];
end
if length(timeout)==0
    timeout=1E8;
end
if ~exist('type','var')
    type='.mat';
end
dt=min(timeout/20,.2);
while timeout>0
    d=dir([common_dir_,'\',name,type]);
    if length(d)>0
        break
    end
    timeout=timeout-dt;
    pause(dt)
end
if timeout<=0
    out=[];
    return
end
switch type
    case '.mat'
        eval(['!rename ',common_dir_,'\',name,'.mat ',name,'.tmp']);
        out=load([common_dir_,'\',name,'.tmp'],'data','-mat');
        out=out.data;
    otherwise
        error('bad type');
end
