function w=spherical_besselj(n,z)
w=sqrt((pi/2)./z)*besselj(n+.5,z);