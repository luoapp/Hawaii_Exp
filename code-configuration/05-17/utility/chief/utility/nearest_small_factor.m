function y=nearest_small_factor(x,off,even)
%function y=nearest_small_factor(x,off,even)
%
%Given a number, find the next higher highly composite number (powers of 2 times 3's and 5's).
%x is the number to refine,
%off is an offset that bumps up by "off" composite numbers (or down)
%even makes sure that the number returned is even.
global factors__
if ~exist('off','var')
    off=1;
end
if length(off)==0
    off=1;
end
if ~exist('even','var')
    even=0;
end
if length(factors__)==0
    factors__=unique([1;2;4;8;16;32;64;128;256;512;1024;2048;4096;8192;16384]*...
        prod(gen_all_combinations({[1,2,3,5,7],[1,2,3,5,7],[1,2,3,5,7],[1,2,3,5,7],[1,2,3,5,7]}),2)');
end
i=sum(x>=factors__);
while even
    if mod(factors__(i+off),2)
        i=i+1;
    else
        even=0;
    end
end
y=factors__(i+off);