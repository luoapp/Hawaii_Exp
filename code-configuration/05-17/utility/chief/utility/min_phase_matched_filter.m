function y=min_phase_matched_filter(x,xmatched)
%function y=min_phase_matched_filter(x,xmatched)
%
%   Create a modified matched filter from x. The modified filter has the
%   same use as a matched filter: send the signal x into the environment,
%   record the response, and correlate the response (use cc) with y. The
%   result is an impulse-like signal that is minimum phase and causal (the
%   standard matched filter output is symmetric about t=0 and the early energy
%   sometimes interferes with peak location.
%
%   x is the input signal (column vector).
%   xmatched is the original matcheded-filter (normally the same as x, but can
%   be different in special cases). If xmatched is omitted, x is used.
%   y is the modified (minimum phase) matched filter.
%
%   Caution: the signal y is not causal and the acausal part must be
%   retained. Therefore, the signal should not be padded, truncated, etc.
%   (i.e., use the signal for correlation processing only with the original
%   buffer size).
%
%   Use (s=output signal, say a linear fm sweep):
%   c=cc(s,s);
%   smin=min_phase_matched_filter(x);
%   c1=cc(smin,s);
%   figure;plot(abs(hilbert([c,c1])));
if ~exist('xmatched')
    xmatched=x;
end
c=cc(xmatched,x);
c(round(end/2))=1E-8;
[t,m]=rceps(c);
m(floor(length(m)/2):end)=0;
y=realifft(conj(realfft(m)./realfft(x)));