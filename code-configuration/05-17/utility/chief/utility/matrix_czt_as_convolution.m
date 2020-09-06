function g = matrix_czt_as_convolution(x,czt_filter,fast)
%function g = matrix_czt_as_convolution(x,czt_filter)
%
%using the structure created by the "czt_get_convolver" function, apply the
%filter to data x. All the setup is done in the "czt_get_convolver"
%function using the size of the data and the czt parameters. This is to be
%used when the czt is to be called over and over with the same parameters.
%The description of the original czt function, as created by the MATLAB folks, 
%is given below.
%
if fast
    g=matrix_czt(single(x),czt_filter.premult,czt_filter.fftmult,czt_filter.postmult,czt_filter.nfft);
else
    [m, n] = size(x); oldm = m;
    if m == 1 
        x = x(:); 
        [m, n] = size(x); 
    end
    k=length(czt_filter.postmult);
    %------- Length for power-of-two fft.
    nfft = double(czt_filter.nfft);
    
    %------- Premultiply data.
    y = x .* repmat(double(czt_filter.premult),1,n);
    
    %------- Fast convolution via FFT.
    fy = fft(  y, nfft );
    fy = fy.*repmat(double(czt_filter.fftmult),1,n);
    g  = ifft(fy);
    
    %------- Final multiply.
    g = g( m:(m+k-1), : );
    g=g.*repmat(double(czt_filter.postmult),1,n);
end
