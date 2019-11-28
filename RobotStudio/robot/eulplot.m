


% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com
function eulplot(a,b,c)
    R = eye(3,3);
    trplot( R, 'unit', 'frame', '0', 'color', 'k');
    hold on
    R = R * rotz(a);
    trplot( R, 'unit', 'frame', '1', 'color', 'r');
    R = R * roty(b);
    trplot( R, 'unit', 'frame', '2', 'color', 'g');
    R = R * rotz(c);
    trplot( R, 'unit', 'frame', '3', 'color', 'b');
    hold off
