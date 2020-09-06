function w=spherical_besseljp(n,z)
w=-spherical_besselj(n,z)./(2*z)+.5*(spherical_besselj(n-1,z)-spherical_besselj(n+1,z));
