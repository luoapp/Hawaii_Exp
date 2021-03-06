function g = czt_as_convolution(x,czt_filter)
%function g = czt_as_convolution(x,czt_filter)
%
%using the structure created by the "czt_get_convolver" function, apply the
%filter to data x. All the setup is done in the "czt_get_convolver"
%function using the size of the data and the czt parameters. This is to be
%used when the czt is to be called over and over with the same parameters.
%The description of the original czt function, as created by the MATLAB folks, 
%is given below.
%
%CZT  Chirp z-transform.
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
%   If X is a matrix, the chirp z-transform operation is applied to each
%   column.
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

[m, n] = size(x); oldm = m;
if m == 1, x = x(:); [m, n] = size(x); end
k=length(czt_filter.postmult);
%------- Length for power-of-two fft.
nfft = czt_filter.nfft;

%------- Premultiply data.
y = x .* repmat(czt_filter.premult,1,n);

%------- Fast convolution via FFT.
fy = fft(  y, nfft );
fy = fy.*repmat(czt_filter.fftmult,1,n);
g  = ifft(fy);

%------- Final multiply.
g = g( m:(m+k-1), : ).*repmat(czt_filter.postmult,1,n);
if oldm == 1, g = g.'; end

