function [time,freq]=min_phase_filter(sig)
[temp,sigm]=rceps(sig);
freq=realfft(sigm)./realfft(sig);
time=realifft(freq);