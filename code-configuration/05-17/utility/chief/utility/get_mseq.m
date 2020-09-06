function [m]=get_mseq(dir,num,scale,expand,filt)
%function m=get_mseq(dir,num,scale,expand,filt)
%
%	Get a length 2^N-1 m-sequence from a list of files, optionally
%	center it, expand it (interpolate 0s) and filter it (using a 
%	specified FIR filter),
%
%	m=output sequence
%
%	dir is the directory that contains the m-sequence files
%
%	num is the "seed" of the sequence, contained in a file of bits
%
%	scale is 0 (for no scale, output 1's and 0's) or 1 (scaled
%	so that the circular autocorrelation of the sequence is 1 at lag
%	tau=0, 0 at all other lags).
%
%	expand is the number of samples per bit of the original sequence
%	(e.g., if expand=2, 11101 in->1010100010 out).
%
%	filt is the fir filter to convolve with the sequence with to produce
%	band_limited sequences with the same autocorrelation property as
%	the original m-sequence.
%
m=[];
file=sprintf('%ss%05d.seq',dir,num);
fil=fopen(file,'r');
if fil~=-1
    arr=fread(fil,inf,'uint8');
    m=arr;
    fclose(fil);
else
    error(sprintf('bad file name %s',file))
    return
end
bits=zeros(length(m),8);
for i=0:7
    bits(:,8-i)=mod(floor(m/(2^i)),2);
end
m=reshape(bits',prod(size(bits)),1);
m=m(1:length(m)-1,1);
if nargin<3
    return
end
m=m*(2/sqrt(length(m)+1))-(sqrt(length(m)+1)-1)/length(m);
if nargin<4
    return
end
m=repmat(m,1,expand);
for i=2:expand
    m(:,i)=0;
end
m=reshape(m',prod(size(m)),1);
if nargin<5
    return
end
m=real(ifft(fft(m).*fft([filt;zeros(length(m)-length(filt),1)])));

