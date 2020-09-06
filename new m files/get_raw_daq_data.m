function [d,sampnums,SR,st,et]=get_raw_daq_data(pat,fn,typ,chnls,slop,offset)
%function [d,SR]=get_raw_daq_data(pat,fn,typ,chnls)
%get data of the specified type (e.g., typ='udel lowband')
%from file fn. Gets only channels defined by chnls parameter (e.g. 1:8).
%d is Nsamps x Nchnls matrix of voltages, sampnums is the start and ending
%sample number in the file actually read, SR is the file's sample rate, and
%st and et are the starting and ending times in the file (secs).
%
%To get a list of valid types, type t=get_signal_start_times. This will
%return a list of currently valid types.
%
%If the length of d is 0, no samples of the specified type were found in
%the file.
if length(pat)==0
    pat='.\';
end
if pat(end)~='\'
    pat(end+1)='\';
end
info=daqread([pat,fn],'info');
SR=info.ObjInfo.SampleRate;
NumSamp=info.ObjInfo.SamplesAcquired;
if length(typ)==0 %just get raw data
    st=slop;
    et=offset;
else
    [st,et]=get_signal_start_times(fn,typ,slop,offset);
end
if length(st)==0
    d=[];
    SR=0;
    sampnums=[];
    return
end
sampnums=1+round([st,et]*SR);
d=daqread([pat,fn],'Samples',sampnums,'Channels',chnls);
