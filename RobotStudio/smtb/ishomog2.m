%ISHOMOG2 Test if SE(2) homogeneous transformation matrix
%
% ISHOMOG2(T) is true (1) if the argument T is of dimension 3x3 or 3x3xN, else 
% false (0).
%
% ISHOMOG2(T, 'check') as above, but also checks the validity of the rotation
% sub-matrix.
%
% Notes::
% - A valid rotation sub-matrix has determinant of 1.
% - The first form is a fast, but incomplete, test for a transform in SE(3).
%
% See also ISHOMOG, ISROT2, ISVEC.

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

function h = ishomog2(T, rtest)
    h = false;
    d = size(T);
    
    if ndims(T) >= 2
        if ~(all(d(1:2) == [3 3]))
            return %false
        end

        if nargin > 1
            for i = 1:size(T,3)
                % check rotational part
                R = T(1:2,1:2,i);
                e = R'*R - eye(2,2);
                if norm(e) > 10*eps
                    return %false
                end
                e = abs(det(R) - 1);
                if norm(e) > 10*eps
                    return %false
                end
                % check bottom row
                if ~all(T(3,:,i) == [0 0 1])
                    return %false
                end
            end
        end
    end

    h = true;
end