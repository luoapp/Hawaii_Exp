function fr=causal_filter(siz,Fc,SR)
%fr=causal_filter(siz,Fc,SR)
%
%causal low pass filter
%siz is the desired size of the time domain filter
%Fc is the cutoff frequency
%SR is the sample rate
if Fc>=SR/2
    fr=zeros(siz,1);
    fr(1)=1;
end
[b]=fir1(51,Fc/SR*2);
fr=zeros(siz,1);
fr(1)=1;
fr=filter(b,1,fr);
fr(end)=1e-8;
try
    [t,fr]=rceps(fr); % MULTIPLIER CHANGED TO ZERO AT DIRECTION OF SEF 26NOV2001
catch
    'bad'
    s=randn('state');
    randn('state',39874543);
    %fr=fr+randn(size(fr))*1e-7;
    fr(end)=1e-8;
    [t,fr]=rceps(fr); % MULTIPLIER CHANGED TO ZERO AT DIRECTION OF SEF 26NOV2001
    randn('state',s);
end
fr(round(siz/2):end)=0;