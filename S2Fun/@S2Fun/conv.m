function SO3F = conv(sF1,sF2,varargin)
% convolution with a function or a kernel on the sphere
%
% For detailed information about the definition of the convolution take a 
% look in the <SO3FunConvolution.html documentation>.
%
% Syntax
%   SO3F = conv(sF1,sF2)
%   sF = conv(sF1,psi)
%
% Input
%  sF1, sF2 - @S2Fun
%  psi  - convolution @S2Kernel
%
% Output
%  sF - @S2FunHarmonic
%  SO3F - @SO3FunHarmonic
%
% See also
% S2FunHarmonic/conv S2Kernel/conv SO3FunHarmonic/conv

if isnumeric(sF1)
  SO3F = conv(sF2,sF1,varargin{:});
  return
end

bw = get_option(varargin,'bandwidth',sF1.bandwidth);
sF1 = S2FunHarmonic.quadrature(sF1,'bandwidth',bw);
SO3F = conv(sF1,sF2,varargin{:});