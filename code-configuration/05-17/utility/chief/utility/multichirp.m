function [C,damp,fs]=multichirp(s,f0,f1,SR,alph,N,M)
%function C=multichirp(s,f0,f1,SR,alph,N,M)
%s is signal, f0 is start frequency, f1 is stop frequency, SR is sample
%rate, alph is the max "damping" of the chirp contour, N i the number of
%frequencies, M is the number of different dampings
C=zeros(N,M);
I=sqrt(-1);
s=s(:); %make column
damp=linspace(0,log(alph),M)';
damp=exp(damp);
fs=linspace(f0,f1,N)';
for i=1:M %many dampings
    a=damp(i)*exp(-I*2*pi*f0/SR);
    w=exp(I*2*pi*(f1-f0)/SR/N);
    C(:,i)=czt(s,N,w,a);
end