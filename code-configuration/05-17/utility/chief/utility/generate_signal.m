function [out,p]=generate_signal(params);
%function out=generate_signal(params)
%
%generate an FM sweep from params.f0 Hz to params.f1 Hz,
%  length params.duration seconds at sample rate params.sr.
%other params:
%params.sweep_type='lfm','hfm','efm','fhc' (linear fm, hyperbolic fm, exponential fm, frequency hop code).
%params.window_type = 'tukey' or 'gauss'
%params.is_complex = 0 or 1 (default 0). If true, use a complex exponential for the
% waveform, else use a cosine
%params.window=specifies the shape of the applied window 
%  (0-1=square to full raised cosine window for tukey, 
%	half amplitude relative to window
%  width for gaussian).
%params.modulation.xxx allows specification of amplitude and phase modulation as a function
%  of frequency:
%params.modulaton.frequency=vector of frequencies at which modulation is specified (must
%  contain the interval from f0 to f1, frequencies are interploated as needed).
%If modulation is chosen, one of the 3 following must be present:
%params.modulation.phase causes the signal's instantaneous phase to be changed by the
%  specified amount as a function of frequency.
%params.modulation.magnitude causes the signal's instantaneous phase to be multiplied by the
%  specified amount as a function of frequency.
%params.modulation.db causes the signal's instantaneous phase to be multiplied by the
%  specified amount (in db) as a function of frequency.
%params.modulation.complex_amplitude causes the signal's instantaneous phase and magnitude
%  to be changed by the specified amount as a function of frequency.
%params.frequency_quantization specifies the "rounding" of instantaneous frequency to the specified step.
%   for example, if this parameter is=10, instantaneous frequency will be constrained to multiples of
%   10 Hz. The signal remains continuous, but its derivative is not. Does not apply to frequency hop
%   codes.
%params.noise='white' causes a noise signal with the sweep's amplitude signal to be generated
%params.phase_continuity, if defined, will cause the phase of the generated
%signal to end at zero phase, at the expense of a slightly different sweep
%than specified.
I=sqrt(-1);
if ~exist('params')
    params=[];
    get_def=1;
else
    get_def=0;
end
if ~isstruct(params)
    params.sweep_type='lfm';
    params.window=0;
end
if ~isfield(params,'is_complex')
    is_complex=0;
    params.is_complex=is_complex;
else
    is_complex=params.is_complex;
end
if ~isfield(params,'f0')
    f0=0;
    params.f0=f0;
end
if ~isfield(params,'f1')
    f1=.1;
    params.f1=f1;
end
f0=params.f0;
f1=params.f1;
if ~isfield(params,'sr')
    params.sr=mean([f0;f1])*16;
end
if ~isfield(params,'duration')
    duration=1;
    params.duration=duration;
end
if ~isfield(params,'sweep_type')
    params.sweep_type='lfm';
end
if ~isfield(params,'window')
    params.window=0;
end
if ~isfield(params,'window_type')
    params.window_type='tukey';
end
if ~isfield(params,'placement_operator')
    params.placement_operator=[3,2,6,4,5,1]; %Default Costas code
end
if ~isfield(params,'frequency_quantization')
    params.frequency_quantization=0; %no quantization
end
p=params;
if get_def
    p.phase_continuity=0;
    out=p;
    return
end
sr=params.sr;
duration=params.duration;
duration=round(duration*sr); %duration is now in samples
f0=f0/sr;f1=f1/sr; %freqs expressed in cycles/sample, not cycles/sec
time=[0:duration-1]';
switch params.sweep_type
    case 'lfm',
        f=f0+time*((f1-f0)/duration);
    case 'hfm',
        if isfield(params,'exponent')
            expon=params.exponent;
        else
            expon=1;
        end
        T0=(1/f0)^expon;T1=(1/f1)^expon;
        f=1./(T0+time*((T1-T0)/duration));
        f=f.^(1/expon);
    case 'efm',
        f=exp(log(f0)+time*((log(f1)-log(f0))/duration));
    case 'fhc',
        
        f_place=params.placement_operator;
        srate=1;  % sampling rate is normalized to 1, as the frequencies have been 
        %normalized to the sampling rate
        phase1=0;	%Phase correction factors to for phase continuity going from 
        phase2=0;	%one subpulse to another.
        phasecorr=0; 
        num_subpulse=length(f_place);
        subpulse_bw=(f1-f0)/(num_subpulse-1);
        freq_subpulse=f0+(f_place-1)*subpulse_bw;
        start_index=[1,1+fix([1:num_subpulse-1]*(duration/num_subpulse)),...
                duration];
        
        for kk=1:num_subpulse
            if kk>1
                phase2=freq_subpulse(kk)*time(start_index(kk));
                phasecorr=phase1-phase2;
            end
            f(start_index(kk):start_index(kk+1)-1)=...
                time(start_index(kk):start_index(kk+1)-1).*freq_subpulse(kk)...
                +phasecorr;
            if kk<num_subpulse
                phase1=freq_subpulse(kk)*time(start_index(kk+1))+phasecorr;
            end
        end
end

if params.sweep_type=='fhc'
    phs=2*pi*f';
else
    if params.frequency_quantization~=0
        f=f/(params.frequency_quantization/sr);
        f=round(f);
        f=f*(params.frequency_quantization/sr);
    end
    phs=cumsum(2*pi*f);
    if isfield(params,'phase_continuity')
        if params.phase_continuity
            phs=phs-phs(1);
            phs(end+1)=0;
            delp=mod(phs(end),2*pi);
            phs=phs-linspace(0,delp*(length(phs))/(length(phs)+1),length(phs))'; %guarantee continuity
            phs=phs(1:end-1);
        end
    end
end
amp=ones(size(phs));


if isfield(params,'modulation')
    mf=params.modulation.frequency;
    mf=mf/sr; %express in cycles/sample
    if min(f0,f1)<min(mf) | max(f0,f1)>max(mf)
        error('frequency range must be within table of modulation frequencies');
    end
    ma=ones(size(f));
    mphs=zeros(size(f));
    if isfield(params.modulation,'complex_amplitude')
        ma=params.modulation.complex_amplitude;
        ma=interp1(mf,ma,f,'linear');
        mphs=angle(ma);
        ma=abs(ma);
    end
    if isfield(params.modulation,'magnitude')
        ma=params.modulation.magnitude;
        ma=interp1(mf,ma,f,'linear');
    end   
    if isfield(params.modulation,'db')
        ma=params.modulation.db;
        ma=interp1(mf,ma,f,'linear');
        ma=10.^(ma/20);
    end   
    if isfield(params.modulation,'phase')
        mphs=params.modulation.phase;
        mphs=interp1(mf,mphs,f,'linear');
    end   
    phs=phs+mphs;
    amp=amp.*ma;
end
switch params.window_type
    case 'tukey'
        if params.window~=0
            win=tukey(length(amp),params.window);
            if length(win)<length(amp)
                win(end+1)=0;
            end
            if length(win)>length(amp)
                win=win(1:end-1);
            end
            amp=amp.*win;
        end
    case 'gauss'
        win=linspace(-1,1,length(amp))'*params.window;
        win=exp(-win.^2);
        amp=amp.*win;
end
if is_complex
    out=amp.*exp(I*phs);
else
    out=amp.*sin(phs);
end
if isfield(params,'noise')
    S=rand('state');
    if isfield(params,'seed')
        randn('state',params.seed);
    end
    switch params.noise
        case 'white',
            fout=fft(out);
            out=ifft(fout.*exp(I*2*pi*rand(size(fout))));
    end
    rand('state',S);
end
