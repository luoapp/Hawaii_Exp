function make_p_package(name,dirstring,include_curdir,already_made)
%function make_p_package(name,dirstring,include_curdir)
%
%using the name of a top-level function, find all dependent functions
%within the subdirectory structure defined by "dirstring" and make them into p files for export to
%another user. Note that caps are important: the disk name should be capitalized.
%include_curdir is set to 1 if you want to compile p files in the current
%directory and its subdirectories.
if ~exist('include_curdir')
    include_curdir=[];
end
if length(include_curdir)==0
    include_curdir=0;
end
if ~exist('already_made','var')
    already_made={name};
end
list = depfun(name,'-nographics','-toponly');
curdir=cd;
for i=1:length(list)
    if length(findstr(list{i},dirstring))==0
        continue
    end
    if ~include_curdir & length(findstr(list{i},curdir))>0
        continue
    end
    if strcmp('.dll',list{i}(end-3:end))
        cpy=sprintf('!copy /y %s .',list{i});
        disp(cpy)
        eval(cpy);
        ix=find(list{i}=='\');
        ix=ix(end);
        fn=list{i}(ix+1:end); %next level of file
        continue
    end
    if ~strcmp('.m',list{i}(end-1:end));
        continue
    end
    ix=find(list{i}=='\');
    ix=ix(end);
    fn=list{i}(ix+1:end-2); %next level of file
    made=0;
    for j=1:length(already_made)
        if strcmp(already_made{j},fn)
            made=1;
            break
        end
    end
    if made
        continue
    end
    already_made{end+1}=fn;
    disp(['making p file ',fn]);
    eval(['pcode ',fn]);
    %recursively make files that he depends on
    make_p_package(fn,dirstring,include_curdir,already_made);
end
