function h=find_tag(handle,name)
%
%	function h=find_tag(handle,name)
%
%	find the handle of a child object
%	handle=handle of window to look in (0=current)
%	name=name of child window to find
%	h=handle of found child (0 if not found)
%
if handle==0
	handle=gcf;
end
ns=size(name); ns=ns(2);
children=get(handle,'Children');
children=children';
size(children);
i=1;
while i<=prod(size(children))
	cname=get(children(i),'Tag');
	if strcmp(cname,name)
		break;
	end
	i=i+1;
end
if i>prod(size(children))
	h=0;
else
	h=children(i);
end
return	