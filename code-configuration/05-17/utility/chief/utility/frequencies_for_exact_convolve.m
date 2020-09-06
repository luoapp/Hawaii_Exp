function [new_sig,Fs]=frequencies_for_exact_convolve(SR,sig,maxt,maxf)
%function [new_sig,Fs]=frequencies_for_exact_convolve(SR,sig,maxt,maxf)
%
%Precondition a signal for doing an exact_convolve (q.v.) operation with a system defined in the frequency domain.
%
%inputs:
%
%SR is the sample rate of the digitized data.
%sig is the input signal that will eventually be convolved with the frequency domain system response.
%maxt is the a priori length of the impulse response of the system (estimated by knowing the system characteristics)
%maxf is the highest frequency present in the input signal (sig) which is assumed to be band limited.
%
%outputs:
%
%Fs is the set of frequencies at which the system response must be evaluated.
%new_sig is a zero-end-padded version of sig with a length that guarantees that the exact_convolve operation will cause no
%unwanted end effects during the convolve.
%
%example:
%
%S is a band limited signal with upper frequency Fmax and sample rate sr.
%The impulse response of the system is no longer than Ts seconds.
%[S1,F]=frequencies_for_exact_convolve(sr,S(1:maxs),Ts,Fmax); %maxs is the number of samples I need of system output
%Rf=system_response(F,....); %calculate system response at prescribed frequencies
%Sout=exact_convolve(S1,Rf); %Sout is a system response valid up to maxs samples (number of samples of the original signal).
l1=length(sig);
l2=ceil(maxt*SR);
l=2*nearest_small_factor((l1+l2)/2,1);
new_sig=[sig;zeros(l-l1,1)];
Fs=[0:length(new_sig)/2]'*SR/length(new_sig);
Fs=Fs(find(Fs<=maxf));