function w=quasi_gausswin(N,P,atten)
%function w=quasi_gausswin(N,P,atten)
w=abs(linspace(-1,1,N))';
sig=(-log(atten)).^(1./P);
w=exp(-(w*sig).^P);