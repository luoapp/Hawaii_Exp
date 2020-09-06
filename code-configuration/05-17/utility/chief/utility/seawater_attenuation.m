function a=seawater_attenuation(F,T)
%function atten=seawater_attenuation(F,T)
%F is frequency in Hz, T is Temperature in deg C.
%get attenuation coefficient as dB/meter
A=.0186;B=.0268;
Sal=35;
ft=21.9*10.^(6-1520./(T+273));
ASft=A*Sal*ft;
Bft=B./ft;
f2=(F/1000).^2;
ft2=ft.^2;
a=(ASft.*f2./(f2+ft2)+Bft.*f2)*39.97/36000;