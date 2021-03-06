function [res]=rombint(funfcn,a,b,decdigs,varargin);
%ROMBINT	 Numerical evaluation of an integral using the Romberg method.
%
%   Q = rombint('F',A,B) approximates the integral of F(X) from A to B to
%   within a relative error of 1e-10 using Romberg's method of integration.
%   'F' is a string containing the name of the function.  The function
%   must return a vector of output values if a vector of input values is given.
%
%   Q = rombint('F',A,B,DECIMALDIGITS) integrates with accuracy 10^{-DECIMALDIGITS}.
%
%   Q = rombint('F',A,B,DECIMALDIGITS,P1,P2,...) allows coefficients P1, P2, ...
%   to be passed directly to function F:   G = F(X,P1,P2,...).
%
%   Based on the idea by David Eberly, Magic Software, Inc.
%   ( http://www.magic-software.com/nu_func.htm )
%   Tested under MATLAB 5.2.
%   ---------------------------------------------------------
%   Author: Martin Kacenak,
%           Department of Informatics and Control Engineering,
%           Faculty of BERG, Technical UNiversity of Kosice,
%           B.Nemcovej 3, 04200 Kosice, Slovak Republic
%   E-mail: ma.kac@post.cz
%   Date:   february 2000

if nargin<4, decdigs=10; end
if nargin<3
   Warning ('Error in input format')
else
   rom=zeros(2,decdigs);
   h=b-a;
   rom(1,1)=h*(feval(funfcn,a,varargin{:})+feval(funfcn,b,varargin{:}))/2;
   ipower=1;
   fp=ones(1,decdigs).*4;
   for i=2:decdigs
      fp(i)=fp(i)*fp(i-1);
      sume=zeros(ipower,1);
      sume(1:ipower)=feval(funfcn,(a+h*((1:ipower)-0.5)),varargin{:});
      % trapezoidal approximations
      rom(2,1)=(rom(1,1)+h*sum(sume))/2;
      % Richardson extrapolation
      for k=1:i-1
         rom(2,k+1)=((4^k)*rom(2,k)-rom(1,k))/((4^k)-1);
      end
      rom(1,1:i)=rom(2,1:i);
      ipower=ipower*2;
      h=h/2;
   end
   res=rom(1,decdigs);
end

