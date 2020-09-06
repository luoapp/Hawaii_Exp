function [fr,toefreq]=minimum_phase_fir_filter(SR,Fc,TransWidth,ToeDb,NoiseAmp)
%[Fr,ToeFreq]=minimum_phase_fir_filter(SampleRate,CutoffFrequency,TransWidth,ToeDb,Threshold)
%
%minimum phase low pass filter
%
%Inputs (all arguments have defaults if not specified or specified as []):
%SampleRate is the sample rate (default 1).
%CutoffFrequency is the cutoff frequency (default .25*SR).
%TransWidth is the width of the transition band (in Hz, default 0.1*SR).
%ToeDb is the maximum tolerable relative dB level in the stop band (60 means at least 60 dB down in stop band).
%    (default 60 dB).
%Threshold will truncate of the tail of the impulse response (samples whose absolute value are less than 
%    the specified amplitude). Default is 0 (no truncation).
%
%Outputs:
%Fr is the output filter samples. Length is Siz (or less if NoiseAmp is specified),
%ToeFreq is the frequency above which the filter output is guaranteed to be at least ToeDb down.
if ~exist('NoiseAmp')
    NoiseAmp=[];
end
if ~exist('ToeDb')
    ToeDb=[];
end
ToeDb=abs(ToeDb);
if ~exist('TransWidth')
    TransWidth=[];
end
if ~exist('SR')
    SR=[];
end
if ~exist('Fc')
    Fc=[];
end
if length(SR)==0
    SR=1;
end
if length(Fc)==0
    Fc=.25*SR;
end
if length(NoiseAmp)==0
    NoiseAmp=1E-5;
end
if length(TransWidth)==0
    TransWidth=SR/10;
end
if length(ToeDb)==0
    ToeDb=60;
end
rat=(Fc+TransWidth)*2/SR;
fracts=[1,12;1,10;1,8;1,6;1,5;1,4;2,7;3,10;1,3;2,5;4,9];
frat=fracts(:,1)./fracts(:,2);
if 0%rat<max(frat)
    ix=find(rat<frat);ix=ix(1);
    fracts(ix,:)
    [fr,toefreq]=minimum_phase_fir_filter(SR*frat(ix)*2,Fc,TransWidth,ToeDb+10,NoiseAmp);
    fr=resample(fr,fracts(ix,2),2*fracts(ix,1));
    fr=fr/sum(fr);
    Fr=db(realfft(fr));
    ix=find(flipud(Fr>-ToeDb));
    ix=ix(1);ix=length(Fr)-ix;
    toefreq=SR/length(fr)*ix;
    return
end
try
    Forder=2*round(SR/TransWidth);
    len=nearest_small_factor(Forder,[],1);
    c=chebwin(len,ToeDb);
    F=[0:length(c)/2]'*SR/length(c);
    F=double(F<=Fc);
    f=fftshift(realifft(F)).*c;
    fr=[f;zeros(3*length(f),1)];
catch
    lasterr
    error('bad filtering parameters Forder should be < siz)')
end
try
    Fr=abs(realfft(fr));
    if sum(Fr<1e-10)>0
        bomb
    end
    [t,fr]=rceps(fr);
catch
    fr(1)=fr(1)+1e-10;
    [t,fr]=rceps(fr);
end
fr(length(fr)/2:end)=0;
ix=find(flipud(fr)>=NoiseAmp);ix=length(fr)-ix(1);
len=nearest_small_factor(ix,[],1);
fr=[fr(1:ix);zeros(len-ix,1)];
fr=fr/sum(fr);
Fr=db(realfft(fr));
ix=find(flipud(Fr>-ToeDb));
ix=ix(1);ix=length(Fr)-ix;
toefreq=SR/length(fr)*ix;