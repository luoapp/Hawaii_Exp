function [b, d] = fftd(t)
%Dimensionless Discrete Fourier Transform
%Usage: [B, D] = fftd(T)
%
%    FFTD(T) performs a "Dimensionless DFT" on real vector T.
%    Returns the dimensionless (unitless) vector D
%    and the universal Basis matrix B such that
%
%    Time = B*D,   and  Freq = Inv(B)*D
%
%    where Inv(B) is B'/sqrt(n) =>  F = B'*D/sqrt(n)
%    So  Freq = (B')^2 * Time/n
%    Time and Freq*n are the conventional DFT pair.
%
%    The Basis matrix, B, has the same dimensional units as T
%    and is always the same for the same sized T.
%
%    D is the dimensionless primitive representation of
%    power signal T and includes Time and Frequency
%    information simultaneously.
%
%    If T is odd the Real(D)~Time
%                and Imag(D)~Freq
%
%    Parseval's Theorem still holds (with correct scaling) for D
%
%
%    Tested under version 5.2.0
%    See also FFT, IFFT, FFTH, FFT2, IFFT2, FTSHIFT


%Paul Godfrey
%pgodfrey@intersil.com


[row,col]=size(t);
n=max(row,col);
t=real(t(:));


m=fft(eye(n))/n;
bi=sqrtm(m);
%b=inv(bi);
b=bi'*sqrt(n);
d=bi*t;
d=reshape(d,row,col);


%we have  t =  b *d
%and      f =  bi*d
return


%B is just the matrix square root of the unit circle
plot(b*b,'*');axis image;grid on


% A demo of this function is:
clc
clear all
close all
warning off
format short g
big=2^45;


n=64; 
k=(0:n-1).';
w=k*2*pi/n;


t=0;
for in=1:2:11;
    t=t+sin(in*w)/in;
end
%for in=13:2:23;
%    t=t+cos(in*w)/in;
%end


[d, b]=fftd(t);
f=b'*d/sqrt(n);


f=round(f*big)/big;
d=round(d*big)/big;
t=round(t*big)/big;
%sin is an odd function so everything separates
fpt=[8*f 4*d t];


figure(1);plot3(k,imag(t),abs(t).*sign(t),'b');hold on;
figure(1);plot3(k,imag(d),abs(d).*sign(d)*4,'r*');axis tight;
grid on;rotate3d;view([0,0]);


figure(2);plot3(k,imag(f),abs(f).*sign(f),'b');hold on;
figure(2);plot3(k,imag(d)/2,abs(d).*sign(d),'r*');axis tight;
grid on;rotate3d;view([0,90]);


figure(3);plot3(k,imag(d),abs(d).*sign(d),'r*');axis tight;
grid on;rotate3d;view([-15,45]);
disp('Use the mouse to examine/move the overlaid data');


clear all
n=8;
t=rand(n,1);
f=fft(t)/n;
[d,b]=fftd(t);
tt=[t b*d]
ff=[f b'*d/sqrt(n)]


return
