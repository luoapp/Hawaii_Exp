function [st,et]=get_signal_start_times(fn,typ,slop,offset)
%function [st,et]=get_signal_start_times(fn,typ,slop)
%
%Get start and end times of selected signal type in file.
%Times are in seconds into the file. st is the start time, et is the ending
%time. If st is length 0 (length(st)==0), there is no signal of the
%specified type in the file.
%
%fn is a file name of the form yyyymmddThhmmss.daq (no directory spec in
%front).
%typ is the type of signal desired (use sig_types=get_signal_start_times
%with no arguments to get valid signal types.
%slop is the expected error in the time recorded in the file name (start
%time of transmission). Default is 2 sec if not specified.
if nargin==0
    st={'udel lowband','udel midband','udel highband'};
    return
end
if ~exist('slop')
    slop=[];
end
if length(slop)==0
    slop=2;
end
if ~exist('offset')
    offset=[];
end
if length(offset)==0
    offset=0;
end
hh=eval(fn(10:11));mm=eval(fn(12:13));ss=eval(fn(14:15));
sec=mod(mm*60+ss,3600);%half hourly transmission
st=sec;
et=sec+4*60;
switch typ
    case 'udel lowband'
        times=[0 30]+60*(0+4.5); %from minutes 4.5 to 5 of half hour
        times=[times;times+1800]; %for either half hour or hour
    case 'udel midband'
        times=[0 30]+60*(15+4.5);    
    case 'udel highband'
        times=[0 30]+60*(45+4.5);
    otherwise
        error('invalid type use get_signal_start_times with no arguments to get valid types')
end
times=times+repmat([-slop slop]+offset,size(times,1),1);
found=0;
for i=1:size(times,1)
    st=times(i,1)-sec;
    et=times(i,2)-sec;
    if st>=0 & st<4*60
        found=1;
        break
    end
end
if ~found
    st=[];et=[];
end
