function a = angle_outer(v1,v2,varargin)
% angle between two vectors
% Input
%  v1, v2 - @vector3d
%
% Output
%  angle  - double
%
% Options
%  antipodal  - include [[AxialDirectional.html,antipodal symmetry]]

a = dot_outer(v1.normalize,v2.normalize,varargin{:});

a = real(acos(a));
