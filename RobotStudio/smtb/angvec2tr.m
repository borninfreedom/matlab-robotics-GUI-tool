%ANGVEC2TR Convert angle and vector orientation to a homogeneous transform
%
% T = ANGVEC2TR(THETA, V) is a homogeneous transform matrix (4x4) equivalent to a
% rotation of THETA about the vector V.
%
% Note::
% - Uses Rodrigues' formula
% - The translational part is zero.
% - If THETA == 0 then return identity matrix and ignore V.
% - If THETA ~= 0 then V must have a finite length.
%
% See also angvec2r, eul2tr, rpy2tr, angvec2r, tr2angvec, trexp, SO3.angvec.

% Copyright (C) 1993-2019 Peter I. Corke
%
% This file is part of The Spatial Math Toolbox for MATLAB (SMTB).
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
% FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% https://github.com/petercorke/spatial-math

function T = angvec2tr(theta, k)

    assert( nargin >= 2, 'SMTB:angvec2tr:badarg', 'two arguments required');

    T = r2t( angvec2r(theta, k) );
end
