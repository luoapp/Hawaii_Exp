function out=input_with_default(string,def)
if nargin<2
   out=input(string);
   return
end
while 1
   if ischar(def)
      out=input([string,' (default ',def,')'],'s');
      if length(out)==0
         out=def;
      end
      return
   else
      if length(def)>1
         i=input(sprintf('%s (default [%d..%d]) ',string,def(1),def(end)),'s');
      else
         i=input(sprintf('%s (default %d) ',string,def),'s');
      end
      
      if length(i)==0
         out=def;
         return
      end
      err=0;
      out=eval(i,'err=1;');
      if ~err
         return
      end
   end
end
      