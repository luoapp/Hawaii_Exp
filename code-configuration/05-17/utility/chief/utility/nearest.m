function [NearestValue,NearestIndex] = nearest(Numbers,PinPoints)
%
% NEAREST Find nearest values to the pin points provided.
%
%   Example: If a = 0:0.01:1; b = sin(2*a*pi); plot(a,b)
%
%            then nearest(b,[-0.5 0 0.25 2]) is [-0.4818 0 0.2487 1.0000].
%
%   See also FIND.

%   Copyright (c) 2000- by Heekwan Lee (heekwan.lee@reading.ac.uk)
%   $Revision: 1.1 $  $Date: 2000/04/16 16:17:18 $


if nargin < 2
   NearestValue = [];
   return
end


Numbers = real(Numbers);
Pins = length(PinPoints);

Max = max(Numbers);
Min = min(Numbers);

for iPin = 1:Pins
   
   if PinPoints(iPin) > Max
      NearestValue(iPin) = Max;
      NearestIndex(iPin) = length(Numbers);
   elseif PinPoints(iPin) < Min
      NearestValue(iPin) = Min;
      NearestIndex(iPin) = 1;
   else
      nul = abs(Numbers - PinPoints(iPin));
      iValue = find(nul==min(nul));
      if length(iValue)>0
          iValue=iValue(1);
      end
      NearestValue(iPin) = Numbers(iValue);
      NearestIndex(iPin)=iValue;
   end
   
end
   
   

