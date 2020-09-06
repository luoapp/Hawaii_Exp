function R=scan_file(file,S)
%function D=scan_file(file,S)
%
%parse data from file according to specifications in state_def
%and return the results as fields in structure D
global f_
i=1;
f_=fopen(file,'r');
R={};
D=[];
while 1
   s_=fgets(f_); %get a line from the file
   err=0;
   try
      if s_<0
         err=1;
      end
   catch
   end
   if err==1 
      break
   end
   for j=1:length(S{i})
      s=S{i}{j};
      mat=0;
      if length(s{1})==0
         mat=1;
         s1=s_;
      else
         ix=findstr(s_,s{1});
         if length(ix)>0
            mat=1;
            ix=ix(1);
            s1=s_(ix+length(s{1}):end);
         end
      end
      if mat
         if length(s)>5
            String=s1;
            eval(s{6});
            s1=String;
         end
         if length(s{2})==0
            str=[];
         else
            str=sscanf(s1,s{2});
         end
         err1=0;
         if length(str)>=abs(s{3})
            if s{3}>0
               str=str(1:s{3});
            else
               str=str(end-s{3}+1:end);
            end
            err=0;
            if length(s{4})>0
               if s{5}<0
                  R=[R,{D}];
                  D=[];
               end
               try
                  if length(D)>0 & isfield(D,s{4})
                     exp=['D.',s{4},'=[D.',s{4},',str];'];
                     eval(exp);
                  else
                     exp=['D.',s{4},'=str;'];
                     eval(exp);
                  end
               catch
                  err=1;
               end
            end
            if err==0
               if s{5}~=0
                  i=abs(s{5});
               end
               err1=1;
               break;
            end
         end
         if err1==1
            break;
         end
      end
   end
end
if length(D)>0
   R=[R,{D}];
end
fclose(f_);

function skip(N)
global f_
for i=1:N
   s_=fgets(f_); %get a line from the file
end


