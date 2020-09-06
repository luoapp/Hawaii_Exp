function [thbeam,pat]=parametric_beam_pat(O)
%function [thbeam,pat]=parametric_beam_pat(O) - run Mark Moffett's parametric beam pat
%
%O is a structure of options.
%To create a default options structure, type O=parametric_beam_pat;
inches=.0254;
Pat_opt='P';
Proj_type='C';
eval('Diameter=O.Diameter;','Diameter=12*inches;');
eval('Primary=O.Primary;','Primary=200000;');
eval('Difference=O.Difference;','Difference=45000;');
eval('SourceLevel=O.SourceLevel;','SourceLevel=240.0;');
eval('Range=O.Range;','Range=-1.0;');
eval('Temp=O.Temp;','Temp=20.0;');
eval('Salinity=O.Salinity;','Salinity=0.0;');
eval('Depth=O.Depth;','Depth=10.0;');
eval('Ph=O.Ph;','Ph=8.0;');
disp(sprintf('Diameter (meters) %g\nPrimary (Hz) %g\nDifference (Hz) %g\nSourceLevel (dB re 1uPa) %g\nRange (m, -1=infinity) %g\nTemp (deg C) %g\nSalinity (ppt) %g\nDepth (ppt) %g\nPh %g',...
   Diameter,...
   Primary,...
   Difference,...
   SourceLevel,...
   Range,...
   Temp,...
   Salinity,...
   Depth,...
   Ph...
   ));
if nargin==0
   O.Diameter=Diameter;
   O.Primary=Primary;
   O.Difference=Difference;
   O.SourceLevel=SourceLevel;
   O.Range=Range;
   O.Temp=Temp;
   O.Salinity=Salinity;
   O.Depth=Depth;
   O.Ph=Ph;
   thbeam=O;
   pat=[];
   return
end
me=which('parametric_beam_pat');
ix=find(me=='\');me=me(1:ix(end)-1);
you=cd;
cd(me);
fil=fopen('in.txt','w');
fprintf(fil,'%s\r\n%s\r\n%8.2f\r\n%12.2f\r\n%12.2f\r\n%10.2f\r\n%10.2f\r\n%10.2f\r\n%10.2f\r\n%10.2f\r\n%10.2f\r\nT\r\n',...
   Pat_opt,...
   Proj_type,...
   Diameter,...
   Primary/1000,...
   Difference/1000,...
   SourceLevel,...
   Range,...
   Temp,...
   Salinity,...
   Depth,...
   Ph...
   );
fclose(fil);
eval('!convol3 <in.txt >out.txt')
fil=fopen('out.txt','r');
try
   st=0;
   i=0;
   clear pat
   while 1
      l=fgets(fil);
      try
         if l(1)==-1
            eof=1;
         else
            eof=0;
         end
      catch
         eof=0;
      end
      if eof
         break
      end
      
      switch st
      case 0
         ix=findstr(l,'APPARENT SOURCE LEVEL = ');
         if length(ix)>0
            src_lvl=sscanf(l(ix+length('APPARENT SOURCE LEVEL = '):end),'%f');
            st=1;
         end
      case 1
         ix=findstr(l,'THETA(DEG)');
         if length(ix)>0
            st=2;
         end
      case 2
         p=sscanf(l,'%f %f');
         if length(p)==2;
            i=i+1;
            pat(:,i)=p(:);
         end
      end
   end
   pat=pat';
   thbeam=pat(:,1);
   pat=pat(:,2)+src_lvl;
   fclose(fil);
catch
    thbeam=lasterr;pat='error in parameters - look at frequencies (must be in Hz)';
    lasterr
   fclose(fil);
   cd(you);
end
cd(you);


