function czt_filter = czt_get_convolver(xLength, k, w, a)
%function g = czt_get_convolver(xLength, k, w, a)
%
% xLength is the length of the input data with which the derived
% convolution filter will be used. k, w, a are defined as in the original
% MATLAB czt described below.
%
%CZT  Chirp z-transform setup routine. Used to derive the "filter" for
%eventual use and re-use with the czt implemented as a c-based algorithm.
%The discussion and code below is adapted from the original MATLAB czt
%routine. Use this function in conjunction with the function
%   "czt_as_convolution".
%
%
%
%   G = CZT(X, M, W, A) is the M-element z-transform of sequence X,
%   where M, W and A are scalars which specify the contour in the z-plane
%   on which the z-transform is computed.  M is the length of the transform,
%   W is the complex ratio between points on the contour, and A is the
%   complex starting point.  More explicitly, the contour in the z-plane
%   (a spiral or "chirp" contour) is described by
%       z = A * W.^(-(0:M-1))
%
%   The parameters M, W, and A are optional; their default values are 
%   M = length(X), W = exp(-j*2*pi/M), and A = 1.  These defaults
%   cause CZT to return the z-transform of X at equally spaced points
%   around the unit circle, equivalent to FFT(X).
%
%
%   See also FFT, FREQZ.

%   Author(s): C. Denham, 1990.
%   	   J. McClellan, 7-25-90, revised
%   	   C. Denham, 8-15-90, revised
%   	   T. Krauss, 2-16-93, updated help
%   Copyright 1988-2002 The MathWorks, Inc.
%       $Revision: 1.7 $  $Date: 2002/03/28 17:27:31 $

%   References:
%     [1] Oppenheim, A.V. & R.W. Schafer, Discrete-Time Signal
%         Processing,  Prentice-Hall, pp. 623-628, 1989.
%     [2] Rabiner, L.R. and B. Gold, Theory and Application of
%         Digital Signal Processing, Prentice-Hall, Englewood
%         Cliffs, New Jersey, pp. 393-399, 1975.

m= xLength; n=1;

if nargin < 2, k = m; end
if nargin < 3, w = exp(-i .* 2 .* pi ./ k); end
if nargin < 4, a = 1; end

if any([size(k) size(w) size(a)]~=1),
	error('Inputs M, W and A must be scalars.')
end

%------- Length for power-of-two fft.

nfft = 2^nextpow2(m+k-1);

%------- Premultiply data.

kk = ( (-m+1):max(k-1,m-1) ).';
kk2 = (kk .^ 2) ./ 2;
ww = w .^ (kk2);   % <----- Chirp filter is 1./ww
nn = (0:(m-1))';
czt_filter.premult = a .^ ( -nn );
czt_filter.premult = single(czt_filter.premult.*ww(m+nn));
%------- Fast convolution via FFT.

czt_filter.fftmult = single(fft(1./ww(1:(k-1+m)),nfft ));   % <----- Chirp filter.

%------- Final multiply.

czt_filter.postmult=single(ww(m:(m+k-1)));
czt_filter.nfft=single(nfft);


