function theta = subspace(A,B)
%SUBSPACE Angle between subspaces.
%   SUBSPACE(A,B) finds the largest angle between two subspaces specified
%   by the columns of A and B.  If A and B are vectors of unit
%   length, this is the same as ACOS(A'*B).
%   
%   This is a replacement of the MATLAB's subspace Rev. 5.5
%   The MATLAB's version fails to provide correct answers
%   for angles smaller than e-8. This is fixed in the present version.
%
%   For a more general code, which computes all angles
%   and corresponding canonical vectors in a general scalar product, see
%   ftp://ftp.mathworks.com/pub/contrib/v5/linalg/subspacea.m
%
%   The algorithm is described in
%   A. V. Knyazev, M. E. Argentati, 
%   An Effective and Robust Algorithm for Finding Principal Angles
%   Between Subspaces Using An $A$-Based Scalar Product
%   Report UCD-CCM 163, 2000, see
%   http://www-math.cudenver.edu/ccmreports/rep163.ps.gz

%   Copyright (c) Andrew Knyazev knyazev@na-net.ornl.gov
%   Freeware for noncommercial use
%   $Revision: 2.0 $  $Date: 2000/9/8 $
%   Tested under MATLAB v. 5.0-5.3.

if size(A,1) ~= size(B,1)
   error('Row dimensions of A and B must be the same.')
end

threshold=sqrt(2)/2; % Define threshold for determining when an angle is small

QA=orth(A);
QB=orth(B);

s = svd(QA'*QB);
mains = min(min(s),1); %This is cosine of the angle
if mains < threshold % Check for small angles and recompute using sine
   theta = acos(mains);
else
   if size(QA,2)<size(QB,2) %ignore angles due to different sizes
   sintheta = norm(QA' - (QA'*QB)*QB');
   else
   sintheta = norm(QB' - (QB'*QA)*QA');
   end
   theta = asin(sintheta);
end
