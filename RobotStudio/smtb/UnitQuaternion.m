%UnitQuaternion Unit quaternion class
%
% A UnitQuaternion is a compact method of representing a 3D rotation that has
% computational advantages including speed and numerical robustness.
% A quaternion has 2 parts, a scalar s, and a vector v and is typically
% written: q = s <vx, vy, vz>.
%
% A UnitQuaternion is one for which s^2+vx^2+vy^2+vz^2 = 1.  It can be
% considered as a rotation by an angle theta about a unit-vector V in space where
%
%         q = cos (theta/2) < v sin(theta/2)>
%
% Constructors::
%  UnitQuaternion          general constructor
%  UnitQuaternion.angvec   constructor, from (angle and vector)
%  UnitQuaternion.eul      constructor, from Euler angles
%  UnitQuaternion.omega    constructor for angle*vector
%  UnitQuaternion.rpy      constructor, from roll-pitch-yaw angles
%  UnitQuaternion.Rx       constructor, from x-axis rotation
%  UnitQuaternion.Ry       constructor, from y-axis rotation
%  UnitQuaternion.Rz       constructor, from z-axis rotation
%  UnitQuaternion.vec      constructor, from 3-vector
%
% Display and print methods::
%  animate                 animates a coordinate frame
%  display                 print in human readable form
%  plot                    plot a coordinate frame representing orientation of quaternion
%
% Group operations::
%  *       ^quaternion (Hamilton) product
%  .*      quaternion (Hamilton) product and renormalize
%  /       ^multiply by inverse
%  ./      multiply by inverse and renormalize
%  ^       ^exponentiate (integer only)
%  exp     ^exponential
%  inv     ^inverse
%  log     ^logarithm
%  prod    product of elements
%
% Methods::
%  angle                   angle between two quaternions
%  conj                    ^conjugate
%  dot                     derivative of quaternion with angular velocity
%  inner                   ^inner product
%  interp                  interpolation (slerp) between two quaternions
%  norm                    ^norm, or length
%  unit                    unitized quaternion
%  UnitQuaternion.qvmul    multiply unit-quaternions in 3-vector form
%
% Conversion methods::
%  char                    convert to string
%  double                  ^convert to 4-vector
%  matrix                  convert to 4x4 matrix
%  R                       convert to 3x3 rotation matrix
%  SE3                     convert to SE3 object
%  SO3                     convert to SO3 object
%  T                       convert to 4x4 homogeneous transform matrix
%  toangvec                convert to angle vector form
%  toeul                   convert to Euler angles
%  torpy                   convert to roll-pitch-yaw angles
%  tovec                   convert to 3-vector 
%
% Operators::
%  +       elementwise sum of quaternion elements (result is a Quaternion)
%  -       elementwise difference of quaternion elements (result is a Quaternion)
%  ==      test for equality
%  ~=      ^test for inequality
%
% ^ means inherited from Quaternion class.
%
% Properties (read only)::
%  s         real part
%  v         vector part
%
% Notes::
% - A subclass of Quaternion
% - Many methods and operators are inherited from the Quaternion superclass.
% - UnitQuaternion objects can be used in vectors and arrays.
% - The + and - operators return a Quaternion object not a UnitQuaternion
%   since these are not group operators.
% - For display purposes a Quaternion differs from a UnitQuaternion by
%   using << >> notation rather than < >.
% - To a large extent polymorphic with the SO3 class.
%
% References::
% - Animating rotation with quaternion curves,
%   K. Shoemake,
%   in Proceedings of ACM SIGGRAPH, (San Fran cisco), pp. 245-254, 1985.
% - On homogeneous transforms, quaternions, and computational efficiency,
%   J. Funda, R. Taylor, and R. Paul,
%   IEEE Transactions on Robotics and Automation, vol. 6, pp. 382-388, June 1990.
% - Quaternions for Computer Graphics, J. Vince, Springer 2011.
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016; p44-45.
%
% See also Quaternion, SO3.

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

% TODO
%  constructor handles R, T trajectory and returns vector
%  .r, .t on a quaternion vector??


% TODO
% add & test dotb, add dot, dotb to SO3
% rpy/eul, to and from should be vectorised

classdef UnitQuaternion < Quaternion

    
    methods

        function uq = UnitQuaternion(s, v)
            %UnitQuaternion.Quaternion Construct a unit quaternion object
            %
            % Construct a UnitQuaternion from various other orientation representations.
            %
            % Q = UnitQuaternion() is the identitity UnitQuaternion 1<0,0,0> representing a null rotation.
            %
            % Q = UnitQuaternion(Q1) is a copy of the UnitQuaternion Q1, if Q1 is a
            % Quaternion it is normalised.
            %
            % Q = UnitQuaternion(S, V) is a UnitQuaternion formed by specifying directly
            % its scalar and vector parts which are normalised.
            %
            % Q = UnitQuaternion([S, V1, V2, V3]) is a UnitQuaternion formed by specifying
            % directly its 4 elements which are normalised.
            %
            % Q = Quaternion(R) is a UnitQuaternion corresponding to the SO(3)
            % orthonormal rotation matrix R (3x3).  If R (3x3xN) is a sequence then Q
            % (Nx1) is a vector of Quaternions corresponding to the elements of R.
            %
            % Q = Quaternion(T) is a UnitQuaternion equivalent to the rotational part
            % of the SE(3) homogeneous transform T (4x4). If T (4x4xN) is a sequence
            % then Q (Nx1) is a vector of Quaternions corresponding to the elements of
            % T.
            %
            % Notes::
            % - Only the R and T forms are vectorised.
            % - To convert an SO3 or SE3 object to a UnitQuaternion use their 
            %   UnitQuaternion conversion methods.
            %
            % See also UnitQuaternion.eul, UnitQuaternion.rpy, UnitQuaternion.angvec,
            % UnitQuaternion.omega, UnitQuaternion.Rx, UnitQuaternion.Ry,
            % UnitQuaternion.Rz, SE3.UnitQuaternion, SO3.UnitQuaternion.
            if nargin == 0
                % null constructor
                %             uq.v = [0,0,0];
                uq.s = 1;
            elseif isa(s, 'Quaternion')
                % passed a quaternion of some kind, optionally normalize
                if ~isa(s, 'UnitQuaternion');
                    s = s.unit();
                end
                uq.s = s.s;
                uq.v = s.v;
            elseif isa(s, 'SO3')
                %   Q = Quaternion(R)       from a 3x3 or 4x4 matrix
                uq(length(s)) = UnitQuaternion();  % preallocate
                for i=1:length(s)
                    [qs,qv] = UnitQuaternion.tr2q(s(i).R);
                    uq(i) = UnitQuaternion(qs,qv);
                end                
            elseif isrot(s) || ishomog(s)
                %   Q = Quaternion(R)       from a 3x3 or 4x4 matrix
                uq(size(s,3)) = UnitQuaternion();  % preallocate
                for i=1:size(s,3)
                    [qs,qv] = UnitQuaternion.tr2q(s(:,:,i));
                    uq(i) = UnitQuaternion(qs,qv);
                end
            elseif nargin == 2 && isscalar(s) && isvec(v,3)
                % ensure its a unit quaternion
                n = norm([s; v(:)]);
                uq.s = s/n;
                uq.v = v/n;
            elseif isvec(s,4)
                % passed in a 4-vector of components
                % normalize it
                if ~isa(s, 'sym')
                    s = unit(s);
                end
                uq.s = s(1);
                uq.v = s(2:4);
            else
                error ('SMTB:UnitQuaternion:badarg', 'bad argument to quaternion constructor');
            end
            
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% UNIT QUATERNION FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

        function qi = inv(q)
            %UnitQuaternion.inv Invert a UnitQuaternion
            %
            % Q.inv() is a UnitQuaternion object representing the inverse of Q.  If 
            % Q is a vector (1xN) the result is a vector of elementwise inverses.
            %
            % See also Quaternion.conj.
            
            for i=1:length(q)
                qi(i) = UnitQuaternion( [q(i).s -q(i).v] );
            end
        end
        
        function q = interp(Q1, varargin)
            %UnitQuaternion.interp Interpolate UnitQuaternion
            %
            % QI = Q.scale(S, OPTIONS) is a UnitQuaternion that interpolates between a null
            % rotation (identity UnitQuaternion) for S=0 to Q for S=1.
            %
            % QI = Q1.interp(Q2, S, OPTIONS) as above but interpolates a rotation
            % between Q1 for S=0 and Q2 for S=1.
            %
            % If S is a vector QI is a vector of UnitQuaternions, each element
            % corresponding to sequential elements of S.
            %
            % Options::
            % 'shortest'   Take the shortest path along the great circle
            %
            % Notes::
            % - This is a spherical linear interpolation (slerp) that can be interpretted
            %   as interpolation along a great circle arc on a sphere.
            % - It is an error if any element of S is outside the interval 0 to 1.
            %
            % References::
            % - Animating rotation with quaternion curves, K. Shoemake,
            %   in Proceedings of ACM SIGGRAPH, (San Francisco), pp. 245-254, 1985.
            %
            % See also ctraj.
            
            opt.shortest = false;

            [opt,args] = tb_optparse(opt, varargin);
            
            if isa(args{1}, 'UnitQuaternion')
                q1 = double(Q1);
                q2 = double(args{1});
                r = args{2};
            else
                q1 = [1  0 0 0]; % unit quaternion
                q2 = double(Q1); % given quaternion
                r = args{1};
            end
            
            % now, interpolate between q1 and q2

            cosTheta = q1*q2';
            
            if opt.shortest
                % take shortest path along the great circle, patch by Gauthier Gras
                if cosTheta < 0
                    q1 = - q1;
                    cosTheta = - cosTheta;
                end;
            end
                      
            theta = acos(cosTheta);
            
            if length(r) == 1 && r > 1 && (r == floor(r))
                % integer value
                r = [0:(r-1)] / (r-1);
            elseif any(r<0 | r>1)
                error('SMTB:UnitQuaternion:interp', 'values of S outside interval [0,1]');
            end
            
            q(length(r)) = UnitQuaternion();  % preallocate space for Quaternion vector
            
            for i=1:length(r)
                if theta == 0
                    q(i) = Q1;
                else
                    q(i) = UnitQuaternion( (sin((1-r(i))*theta) * q1 + sin(r(i)*theta) * q2) / sin(theta) );
                end
            end
        end
        
% polymorphic with SE3
% function v = isidentity(obj)
%             v = all(all(obj.T == eye(4,4)));
%                 end


        function qu = increment(obj, w)
            %UnitQuaternion.increment Update UnitQuaternion by angular displacement
            %
            % QU = Q.increment(OMEGA) updates Q by an infinitessimal rotation which is given 
            % as a spatial displacement OMEGA (3x1) whose direction is the rotation axis and
            % magnitude is the amount of rotation.
            %
            % Notes::
            % - OMEGA is an approximation to the instantaneous spatial velocity multiplied by
            %   time step.
            %
            % See also tr2delta.
            
            qu = obj .* UnitQuaternion.omega( w );
        end

        function th = angle(q1, q2)
            %UnitQuaternion.angle Angle between two UnitQuaternions
            %
            % A = Q1.angle(Q2) is the angle (in radians) between two UnitQuaternions Q1 and Q2.
            %
            % Notes::
            % - If either, or both, of Q1 or Q2 are vectors, then the result is a vector.
            %  - if Q1 is a vector (1xN) then A is a vector (1xN) such that A(i) = P1(i).angle(Q2).
            %  - if Q2 is a vector (1xN) then A is a vector (1xN) such that A(i) = P1.angle(P2(i)).
            %  - if both Q1 and Q2 are vectors (1xN) then A is a vector (1xN) such 
            %    that A(i) = P1(i).angle(Q2(i)).
            %
            % References::
            % - Metrics for 3D rotations: comparison and analysis, Du Q. Huynh,
            %   J.Math Imaging Vis. DOFI 10.1007/s10851-009-0161-2.
            %
            % See also Quaternion.angvec.
            
            c = zeros(1, max(length(q1), length(q2)));
            q1d = q1.double; q2d = q2.double;

            if length(q1) == length(q2)
                    th = 2*atan2( colnorm((q1d-q2d)'), colnorm((q1d+q2d)') );
            elseif length(q1) == 1
                for i=1:length(q2)
                    th(i) = 2*atan2( colnorm((q1d-q2d(i,:))'), colnorm((q1d+q2d(i,:))') );
                end
            elseif length(q2) == 1
                for i=1:length(q1)
                    th(i) = 2*atan2( colnorm((q1d(i,:)-q2d)'), colnorm((q1d(i,:)+q2d)') );
                end
            else
                error('SMTB:Quaternion:badarg', 'angle arguments must be vectors of same length');
            end
            % clip it, just in case it's unnormalized
            c(c<-1) = -1;  c(c>1) = 1;
            
            % Huynh method 3, LaValle p157
            % acos( abs(dot(q1d,q2d)) )
            %th = 2*acos(c);
            %% use 2 atan2(|q1-q2|, |q1+q2|)
        end
        
        function qu = unit(q)
            %UnitQuaternion.unit Unitize unit-quaternion
            %
            % QU = Q.unit() is a UnitQuaternion with a norm of 1.  If Q is a vector (1xN) then
            % QU is also a vector (1xN).
            %
            % Notes::
            % - This is UnitQuaternion of unit norm, not a Quaternion of unit norm.
            %
            % See also Quaternion.norm.
            
            for i=1:length(q)
                qu(i) = UnitQuaternion( q(i).double / norm(q(i)) );
            end
        end
        
        function qd = dot(q, omega)
            %UnitQuaternion.dot UnitQuaternion derivative in world frame
            %
            % QD = Q.dot(omega) is the rate of change of the UnitQuaternion Q expressed 
            % as a Quaternion in the world frame. Q represents the orientation of a body
            % frame with angular velocity OMEGA (1x3).
            %
            % Notes::
            % - This is not a group operator, but it is useful to have the result as a
            %   Quaternion.
            %
            % Reference::
            %  - Robotics, Vision & Control, 2nd edition, Peter Corke, pp.64.
            %
            % See also UnitQuaternion.dotb.
            
            % UnitQuaternion.pure(omega) * q
            E = q.s*eye(3,3) - skew(q.v);
            omega = omega(:);
            qd = 0.5 * Quaternion(-q.v*omega, E*omega);
        end
 
        
        function qd = dotb(q, omega)
            %UnitQuaternion.dot UnitQuaternion derivative in body frame
            %
            % QD = Q.dotb(omega) is the rate of change of the UnitQuaternion Q expressed 
            % as a Quaternion in the body frame. Q represents the orientation of a body
            % frame with angular velocity OMEGA (1x3).
            %
            % Notes::
            % - This is not a group operator, but it is useful to have the result as a
            %   quaternion.
            %
            % Reference::
            %  - Robotics, Vision & Control, 2nd edition, Peter Corke, pp.64.
            %
            % See also UnitQuaternion.dot.
            
            % q * UnitQuaternion.pure(omega)

            E = q.s*eye(3,3) + skew(q.v);
            omega = omega(:);
            qd = 0.5 * Quaternion(-q.v*omega, E*omega);
        end
 
         function out = prod(q)
            %UnitQuaternion.prod Product of unit quaternions
            %
            % prod(Q) is the product of the elements of the vector of UnitQuaternion objects Q.
            %
            % Note::
            % - Multiplication is performed with the .* operator, ie. the product is 
            %   renormalized at every step.
            %
            % See also UnitQuaternion.times, RTBPose.prod.
            out = q(1);
            for qq = q(2:end)
                out = out * qq;
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ARITHMETIC OPERATORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        function qp = mtimes(q1, q2)
            %UnitQuaternion.mtimes Multiply UnitQuaternion's
            %
            % R = Q1*Q2 is a UnitQuaternion object formed by Hamilton product
            % of Q1 and Q2 where Q1 and Q2 are both UnitQuaternion objects.
            %
            % Q*V     is a vector (3x1) formed by rotating the vector V (3x1)by the UnitQuaternion Q.
            %
            % Notes::
            % - Overloaded operator '*'
            % - If either, or both, of Q1 or Q2 are vectors, then the result is a vector.
            %   - if Q1 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1(i)*Q2.
            %   - if Q2 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1*Q2(i).
            %   - if both Q1 and Q2 are vectors (1xN) then R is a vector (1xN) such 
            %    that R(i) = Q1(i)*Q2(i).
            %
            % See also Quaternion.mrdivide, Quaternion.mpower, Quaternion.plus, Quaternion.minus.

            if isa(q2, 'UnitQuaternion')
                %QQMUL  Multiply UnitQuaternion by UnitQuaternion
                %
                %   QQ = qqmul(Q1, Q2)
                %
                %   Return a product of UnitQuaternions.
                %
                %   See also: TR2Q

                % get the superclass to do this for us
                qp = mtimes@Quaternion(q1, q2);

            elseif isa(q2, 'Quaternion')
                % get the superclass to do this for us
                qp = mtimes@Quaternion(q1, q2);

            elseif isa(q1, 'Quaternion') && (isnumeric(q2) | isa(q2, 'sym'))

                %QVMUL  Multiply vector by UnitQuaternion
                %
                %   VT = qvmul(Q, V)
                %
                %   Rotate the vector V by the UnitQuaternion Q.
                %
                %   See also: QQMUL, QINV

                %% 2?qv �(?qv �v+qwv)+v
                %% 2*q.v x ( q.v x v + s v) + v
                assert(isreal(q2), 'SMTB:UnitQuaternion:*', 'quat-double: matrix must be real');
                assert(size(q2,1) == 3, 'SMTB:UnitQuaternion:*', 'quat-double: matrix must have 3 rows');
                if isnumeric(q2)
                    q2 = double(q2); % force to double
                end

                %                 if q1(1).issym || isa(q2, 'sym')
                %                     qp = zeros(3, max(length(q1), numcols(q2)), 'sym');
                %                 else
                %                     qp = zeros(3, max(length(q1), numcols(q2)));
                %                 end

                if length(q1) == numcols(q2)
                    for i=1:length(q1)
                        q = q1(i) * Quaternion.pure(q2(:,i)) * inv(q1(i));
                        qp(:,i) = q.v(:);
                    end
                elseif length(q1) == 1
                    for i=1:numcols(q2)
                        q = q1 * Quaternion.pure(q2(:,i)) * inv(q1);
                        qp(:,i) = q.v(:);
                    end
                elseif numcols(q2) == 1
                    for i=1:length(q1)
                        q = q1(i) * Quaternion.pure(q2(:)) * inv(q1(i));
                        qp(:,i) = q.v(:);
                    end
                else
                    error('SMTB:UnitQuaternion:badarg', 'quaternion-double product: vectors lengths incorrect');
                end

            else
                error('SMTB:UnitQuaternion:badarg', 'quaternion product: incorrect right hand operand');
            end
        end
        
        
        function qp = times(q1, q2)
            %UnitQuaternion.times Multiply UnitQuaternion's and unitize
            %
            % R = Q1.*Q2 is a UnitQuaternion object formed by Hamilton product of Q1 and
            % Q2. The result is explicitly unitized.
            %
            % Notes::
            % - Overloaded operator '.*'
            % - If either, or both, of Q1 or Q2 are vectors, then the result is a vector.
            %   - if Q1 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1(i).*Q2.
            %   - if Q2 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1.*Q2(i).
            %   - if both Q1 and Q2 are vectors (1xN) then R is a vector (1xN) such 
            %    that R(i) = Q1(i).*Q2(i).
            %
            % See also Quaternion.mtimes.
            if isa(q2, 'UnitQuaternion')
                qp = unit(q1*q2 );
            else
                error('SMTB:UnitQuaternion:badarg', 'quaternion product .*: incorrect operands');
            end
        end
        
        
        
        function qq = mrdivide(q1, q2)
            %UnitQuaternion.mrdivide Divide unit quaternions
            %
            % R = Q1/Q2 is a UnitQuaternion object formed by Hamilton product of Q1 and
            % inv(Q2) where Q1 and Q2 are both UnitQuaternion objects.
            %
            % Notes::
            % - Overloaded operator '/'.
            % - If either, or both, of Q1 or Q2 are vectors, then the result is a vector.
            %   - if Q1 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1(i)/Q2.
            %   - if Q2 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1/Q2(i).
            %   - if both Q1 and Q2 are vectors (1xN) then R is a vector (1xN) such 
            %    that R(i) = Q1(i)/Q2(i).
            %
            % See also Quaternion.mtimes, Quaternion.mpower, Quaternion.plus, Quaternion.minus.
            
            if isa(q2, 'UnitQuaternion')
                % qq = q1 / q2
                %    = q1 * qinv(q2)
                
                qq = q1 * inv(q2);
            else
                error('SMTB:UnitQuaternion:badarg', 'quaternion divide /: incorrect RH operands');
            end
        end

        function qp = rdivide(q1, q2)
            %UnitQuaternion.rdivide Divide unit quaternions and unitize
            %
            % Q1./Q2   is a UnitQuaternion object formed by Hamilton product of Q1 and
            % inv(Q2) where Q1 and Q2 are both UnitQuaternion objects.  The result is
            % explicitly unitized.
            %
            % Notes::
            % - Overloaded operator './'.
            % - If either, or both, of Q1 or Q2 are vectors, then the result is a vector.
            %   - if Q1 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1(i)./Q2.
            %   - if Q2 is a vector (1xN) then R is a vector (1xN) such that R(i) = Q1./Q2(i).
            %   - if both Q1 and Q2 are vectors (1xN) then R is a vector (1xN) such 
            %    that R(i) = Q1(i)./Q2(i).
            %
            % See also Quaternion.mtimes.
            if isa(q2, 'UnitQuaternion')
                qp = unit( q1/q2 );
            else
                error('SMTB:UnitQuaternion:badarg', 'quaternion product .*: incorrect operands');
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% GRAPHICS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function hout = plot(Q, varargin)
            %UnitQuaternion.plot Plot a quaternion object
            %
            % Q.plot(options) plots the UnitQuaternion as an oriented coordinate frame.
            %
            % H = Q.plot(options) as above but returns a handle which can be used for animation.
            %
            % Animation::
            %
            % Firstly, create a plot and keep the the handle as per above.
            %
            % Q.plot('handle', H) updates the coordinate frame described by the handle H to
            % the orientation of Q.
            %
            % Options::
            %
            % 'color',C          The color to draw the axes, MATLAB colorspec C
            % 'frame',F          The frame is named {F} and the subscript on the axis labels is F.
            % 'view',V           Set plot view parameters V=[az el] angles, or 'auto'
            %                    for view toward origin of coordinate frame
            % 'handle',h         Update the specified handle
            %
            % These options are passed to trplot, see trplot for more options.
            %
            % See also trplot.
            
            %axis([-1 1 -1 1 -1 1])
            
            h = trplot( Q.R, varargin{:});
            if nargout > 0
                hout = h;
            end
        end
        
        function animate(Q, varargin)
            %UnitQuaternion.animate Animate UnitQuaternion object
            %
            % Q.animate(options) animates a UnitQuaternion array Q (1xN) as a 3D coordinate frame.
            %
            % Q.animate(QF, options) animates a 3D coordinate frame moving from
            % orientation Q to orientation QF.
            %
            % Options::
            % Options are passed to tranimate and include:
            %
            %  'fps', fps    Number of frames per second to display (default 10)
            %  'nsteps', n   The number of steps along the path (default 50)
            %  'axis',A      Axis bounds [xmin, xmax, ymin, ymax, zmin, zmax]
            %  'movie',M     Save frames as files in the folder M
            %  'cleanup'     Remove the frame at end of animation
            %  'noxyz'       Don't label the axes
            %  'rgb'         Color the axes in the order x=red, y=green, z=blue
            %  'retain'      Retain frames, don't animate
            %  Additional options are passed through to TRPLOT.
            %
            % See also tranimate, trplot.
            
            if nargin > 1 && isa(varargin{1}, 'Quaternion')
                QF = varargin{1};
                tranimate(Q.R, QF.R, varargin{2:end});
            else
                tranimate(Q.R, varargin{:});
            end
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% TYPE CONVERSION METHODS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        function s = char(q)
            %UnitQuaternion.char Convert to string
            %
            % S = Q.char() is a compact string representation of the UnitQuaternion's value
            % as a 4-tuple.  If Q is a vector then S has one line per element.
            %
            % Notes::
            % - The vector part is delimited by single angle brackets, to differentiate
            %   from a Quaternion which is delimited by double angle brackets.
            %
            % See also Quaternion.char.
            
            if length(q) > 1
                s = '';
                for qq = q(:)'
                    s = char(s, char(qq));
                end
                return
            end
            
            function s = render(x)
                if isnumeric(x)
                    s = num2str(x);
                elseif isa(x, 'sym')
                    s = char(x);
                end
            end
                
            s = [render(q.s), ' < ' ...
                render(q.v(1)) ', ' render(q.v(2)) ', '   render(q.v(3)) ' >'];
        end  
        
        function r = R(q)
            %UnitQuaternion.R Convert to SO(3) rotation matrix
            %
            % R = Q.R() is the equivalent SO(3) orthonormal rotation matrix (3x3).  If
            % Q represents a sequence (Nx1) then R is 3x3xN.
            %
            % See also UnitQuaternion.T, UnitQuaternion.SO3.
            
            if ~issym(q(1))
                r = zeros(3,3,numel(q));
            end
            for i=1:numel(q)
                r(:,:,i) = q(i).torot();
            end
        end
        
        function v = issym(q)
            v = isa(q.s, 'sym') || isa(q.v, 'sym');
        end
            
        function t = T(q)
            %UnitQuaternion.T Convert to homogeneous transformation matrix
            %
            % T = Q.T() is the equivalent SE(3) homogeneous transformation 
            % matrix (4x4).  If Q is a sequence (Nx1) then T is 4x4xN.
            %
            % Notes:
            % - Has a zero translational component.
            %
            % See also UnitQuaternion.R, UnitQuaternion.SE3.
            
            if ~issym(q(1))
                t = zeros(4,4,numel(q));
            end
            for i=1:numel(q)
                t(1:3,1:3,i) = q(i).torot();
                t(4,4,i) = 1;
            end
        end
        
        function obj = SO3(q)
            %UnitQuaternion.SO3 Convert to SO3 object
            %
            % Q.SO3() is an SO3 object with equivalent rotation.
            %
            % Notes::
            % - If Q is a vector then an equivalent vector of SO3 objects is created.
            %
            % See also UnitQuaternion.SE3, SO3.
            
            obj = repmat(SO3, 1, length(q));
            for i=1:numel(q)
                obj(i) = SO3( q(i).R );
            end
        end

        function obj = SE3(q)
            %UnitQuaternion.SE3 Convert to SE3 object
            %
            % Q.SE3() is an SE3 object with equivalent rotation and zero translation.
            %
            % Notes::
            % - The translational part of the SE3 object is zero
            % - If Q is a vector then an equivalent vector of SE3 objects is created.
            %
            % See also UnitQuaternion.SE3, SE3.
            
            obj = repmat(SE3, 1, length(q));
            for i=1:numel(q)
                obj(i) = SE3( q(i).T );
            end
        end
        
        function rpy = torpy(q, varargin)
            %UnitQuaternion.torpy Convert to roll-pitch-yaw angle form.
            %
            % RPY = Q.torpy(OPTIONS) are the roll-pitch-yaw angles (1x3) corresponding to
            % the UnitQuaternion Q.  These correspond to rotations about the Z, Y, X axes
            % respectively. RPY = [ROLL, PITCH, YAW].
            %
            % If Q is a vector (1xN) then each row of RPY corresponds to an element of
            % the vector.
            % 
            % Options::
            %  'deg'   Compute angles in degrees (radians default)
            %  'xyz'   Return solution for sequential rotations about X, Y, Z axes
            %  'yxz'   Return solution for sequential rotations about Y, X, Z axes
            %
            % Notes::
            % - There is a singularity for the case where P=pi/2 in which case R is arbitrarily
            %   set to zero and Y is the sum (R+Y).
            %
            % See also UnitQuaternion.toeul, tr2rpy.
            rpy = zeros(length(q), 3);
            for i=1:length(q)
                rpy(i,:) = tr2rpy( q(i).R, varargin{:} );
            end
        end
        
        function eul = toeul(q, varargin)
            %UnitQuaternion.toeul Convert to roll-pitch-yaw angle form.
            %
            % EUL = Q.toeul(OPTIONS) are the Euler angles (1x3) corresponding to
            % the UnitQuaternion Q.  These correspond to rotations about the Z, Y, Z axes
            % respectively. EUL = [PHI,THETA,PSI].
            %
            % If Q is a vector (1xN) then each row of EUL corresponds to an element of
            % the vector.
            % 
            % Options::
            %  'deg'   Compute angles in degrees (radians default)
            %
            % Notes::
            % - There is a singularity for the case where THETA=0 in which case PHI is arbitrarily
            %   set to zero and PSI is the sum (PHI+PSI).
            %
            % See also UnitQuaternion.torpy, tr2eul.
            eul = zeros(length(q), 3);
            for i=1:length(q)
                eul(i,:) = tr2eul( q(i).R, varargin{:} );
            end
        end
        
        function [theta_,n_] = toangvec(q, varargin)
            %UnitQuaternion.angvec Convert to angle-vector form
            %
            % TH = Q.toangvec(OPTIONS) is the rotational angle, about some vector,
            % corresponding to this UnitQuaternion. If Q is a UnitQuaternion 
            % vector (1xN) then TH (1xN) and V (Nx3).
            %
            % [TH,V] = Q.toangvec(OPTIONS) as above but also returns a unit vector
            % parallel to the rotation axis.
            %
            % Q.toangvec(OPTIONS) prints a compact single line representation of the
            % rotational angle and rotation vector corresponding to this UnitQuaternion.
            % If Q is a UnitQuaternion vector then print one line per element.
            %
            % Options::
            %  'deg'     Display/return angle in degrees rather than radians
            %
            % Notes::
            % - Due to the double cover of the UnitQuaternion, the returned rotation angles
            %   will be in the interval [-2pi, 2pi).
            %
            % See also UnitQuaternion.angvec.

            opt.deg = false;
            opt = tb_optparse(opt, varargin);
            
            if opt.deg
                theta = theta * 180/pi;
                units = 'deg';
            else
                units = 'rad';
            end
            
            % compute the angle and vector for each quaternion
            for i=1:length(q)
                qi = q(i);
                if norm(qi.v) < 10*eps
                    % identity quaternion, null rotation
                    theta(i) = 0;
                    n(i,:) = [0 0 0];
                else
                    % finite rotation
                    n(i,:) = unit(qi.v);
                    theta(i) = 2*atan2( norm(qi.v), qi.s);
                end
            end
            
            % optionally display them
            if nargout == 0
                % if no output arguments display the angle and vector
                for i=1:length(q)
                    fprintf('Rotation: %f %s x [%f %f %f]\n', theta(i), units, n(i,:));
                end
            elseif nargout == 1
                theta_ = theta;
            elseif nargout == 2
                theta_ = theta;
                n_ = n;
            end
        end

        function qv = tovec(q)
            %UnitQuaternion.tovec Convert to unique 3-vector
            %
            % V = Q.tovec() is a vector (1x3) that uniquely represents the UnitQuaternion.  The scalar
            % component can be recovered by 1 - norm(V) and will always be positive.
            % 
            % Notes::
            % - UnitQuaternions have double cover of SO(3) so the vector is derived
            %   from the UnitQuaternion with positive scalar component.
            % - This unique and concise vector representation of a UnitQuaternion is often used 
            %   in bundle adjustment problems.  
            % 
            % See also UnitQuaternion.vec, UnitQuaternion.qvmul.
            if q.s < 0
                qv = -q.v;
            else
                qv = q.v;
            end
        end
        
        function e = eq(q1, q2)
            %UnitQuaternion.eq Test for equality
            %
            % Q1 == Q2 is true if the two UnitQuaternions represent the same rotation.
            %
            % Notes::
            % - The double mapping of the UnitQuaternion is taken into account, that is,
            %   UnitQuaternions are equal if Q1.s == -Q1.s && Q1.v == -Q2.v.
            % - If Q1 is a vector of UnitQuaternions, each element is compared to
            %   Q2 and the result is a logical array of the same length as Q1.
            % - If Q2 is a vector of UnitQuaternion, each element is compared to
            %   Q1 and the result is a logical array of the same length as Q2.
            % - If Q1 and Q2 are equal length vectors of UnitQuaternion, then the result
            %   is a logical array of the same length.

            % overloaded version for UnitQuaternions to support double mapping
            
            if (numel(q1) == 1) && (numel(q2) == 1)
                e = (sum(abs(q1.double - q2.double)) < 100*eps) || (sum(abs(q1.double + q2.double)) < 100*eps);
            elseif (numel(q1) >  1) && (numel(q2) == 1)
                e = zeros(1, numel(q1), 'logical');
                for i=1:numel(q1)
                    e(i) = q1(i) == q2;
                end
            elseif (numel(q1) == 1) && (numel(q2) > 1)
                e = zeros(1, numel(q2), 'logical');
                for i=1:numel(q2)
                    e(i) = q2(i) == q1;
                end
            elseif numel(q1) == numel(q2)
                e = zeros(1, numel(q1), 'logical');
                for i=1:numel(q1)
                    e(i) = q1(i) == q2(i);
                end
            else
                error('SMTB:UnitQuaternion:eq: badargs');
            end
        end

    end % methods
    
    methods (Access=private)
        
        %TOROT   Convert UnitQuaternion to homogeneous transform
        %
        %   T = q2tr(Q)
        %
        %   Return the rotational homogeneous transform corresponding to the unit
        %   quaternion Q.
        %
        %   See also: TR2Q
            
        function R = torot(q)

            
            q = double(q);
            s = q(1);
            x = q(2);
            y = q(3);
            z = q(4);
            
            R = [   1-2*(y^2+z^2)   2*(x*y-s*z) 2*(x*z+s*y)
                2*(x*y+s*z) 1-2*(x^2+z^2)   2*(y*z-s*x)
                2*(x*z-s*y) 2*(y*z+s*x) 1-2*(x^2+y^2)   ];
            
        end
        
    end % private methods
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% STATIC FACTORY METHODS, ALTERNATIVE CONSTRUCTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Static) 
        
        function uq = rand()
            %UnitQuaternion.rand Construct a random UnitQuaternion
            %
            % UnitQuaternion.rand() is a UnitQuaternion representing a random 3D rotation.
            %
            % References::
            % - Planning Algorithms, Steve LaValle, p164.
            %
            % See also SO3.rand, SE3.rand.
            
            u = rand(1,3);  % get 3 random numbers in [0,1]
            uq = UnitQuaternion( [
                sqrt(1-u(1))*sin(2*pi*u(2))
                sqrt(1-u(1))*cos(2*pi*u(2))
                sqrt(u(1))*sin(2*pi*u(3))
                sqrt(u(1))*cos(2*pi*u(3)) ]');
        end
        
        function uq = new(varargin)
            %UnitQuaternion.new Construct a new UnitQuaternion
            %
            % QN = Q.new() constructs a new UnitQuaternion object of the same type as Q.
            %
            % QN = Q.new([S, V1, V2, V3]) as above but specified directly by its 4 elements.
            %
            % QN = Q.new(S, V) as above but specified directly by the scalar S and vector
            % part V (1x3)
            %
            % Notes::
            % - Polymorphic with Quaternion and RTBPose derived classes.  For any of these
            %   instance objects the new method creates a new instance object of the same type.
            uq = UnitQuaternion(varargin{:});
        end

        function uq = Rx(varargin)
            %UnitQuaternion.Rx Construct UnitQuaternion from rotation about x-axis
            %
            % Q = UnitQuaternion.Rx(ANGLE) is a UnitQuaternion representing rotation of ANGLE about the x-axis.
            %
            % Q = UnitQuaternion.Rx(ANGLE, 'deg') as above but THETA is in degrees.
            %
            % See also UnitQuaternion.Ry, UnitQuaternion.Rz.
            uq = UnitQuaternion( rotx(varargin{:}));
        end
        
        function uq = Ry(varargin)
            %UnitQuaternion.Ry Construct UnitQuaternion from rotation about y-axis
            %
            % Q = UnitQuaternion.Ry(ANGLE) is a UnitQuaternion representing rotation of ANGLE about the y-axis.
            %
            % Q = UnitQuaternion.Ry(ANGLE, 'deg') as above but THETA is in degrees.
            %
            % See also UnitQuaternion.Rx, UnitQuaternion.Rz.
            uq = UnitQuaternion( roty(varargin{:}));
        end
        
        function uq = Rz(varargin)
            %UnitQuaternion.Rz Construct UnitQuaternion from rotation about z-axis
            %
            % Q = UnitQuaternion.Rz(ANGLE) is a UnitQuaternion representing rotation of ANGLE about the z-axis.
            %
            % Q = UnitQuaternion.Rz(ANGLE, 'deg') as above but THETA is in degrees.
            %
            % See also UnitQuaternion.Rx, UnitQuaternion.Ry.
            uq = UnitQuaternion( rotz(varargin{:}));
        end
        
        function uq = omega(w)
            %UnitQuaternion.omega Construct UnitQuaternion from angle times rotation vector
            %
            % Q = UnitQuaternion.omega(W) is a UnitQuaternion representing rotation of ||W|| about the vector W (3x1).
            %
            % Notes::
            % - The input representation is known as exponential coordinates.
            %
            % See also UnitQuaternion.angvec.            
            assert(isvec(w), 'SMTB:UnitQuaternion:bad arg', 'must be a 3-vector');

            theta = norm(w);
            s = cos(theta/2);
            v = sin(theta/2)*unit(w(:)');
            uq = UnitQuaternion(s, v);
        end
        
        function uq = angvec(theta, v)
            %UnitQuaternion.angvec Construct UnitQuaternion from angle and rotation vector
            %
            % Q = UnitQuaternion.angvec(TH, V) is a UnitQuaternion representing rotation of TH about the vector V (3x1).
            %
            % See also UnitQuaternion.omega.              
            assert(isvec(v), 'SMTB:UnitQuaternion:bad arg', 'must be a 3-vector');

            uq = UnitQuaternion();
            uq.s = cos(theta/2);
            uq.v = sin(theta/2)*unit(v(:)');
        end
        
        function uq = rpy(varargin)
            %UnitQuaternion.rpy Construct UnitQuaternion from roll-pitch-yaw angles
            %
            % Q = UnitQuaternion.rpy(ROLL, PITCH, YAW, OPTIONS) is a UnitQuaternion
            % representing rotation equivalent to the specified roll, pitch, yaw angles
            % angles. These correspond to rotations about the Z, Y, X axes
            % respectively.
            %
            % Q = UnitQuaternion.rpy(RPY, OPTIONS) as above but the angles are given by
            % the passed vector RPY = [ROLL, PITCH, YAW].  If RPY is a matrix (Nx3)
            % then Q is a vector (1xN) of UnitQuaternion objects where the index
            % corresponds to rows of RPY which are assumed to be [ROLL,PITCH,YAW].
            % 
            % Options::
            % 'deg'   Compute angles in degrees (default radians)
            % 'zyx'   Return solution for sequential rotations about Z, Y, X axes (default)
            % 'xyz'   Return solution for sequential rotations about X, Y, Z axes
            % 'yxz'   Return solution for sequential rotations about Y, X, Z axes
            %
            % Notes::
            % - Is vectorised, see rpy2r for details.
            %
            % See also UnitQuaternion.eul, rpy2r.

            [s,v] = UnitQuaternion.tr2q( rpy2r(varargin{:}) );
            
            uq = UnitQuaternion();
            uq.s = s;
            uq.v = v;
            
        end
        
        function uq = eul(varargin)
            %UnitQuaternion.eul Construct UnitQuaternion from Euler angles
            %
            % Q = UnitQuaternion.eul(PHI, THETA, PSI, OPTIONS) is a UnitQuaternion
            % representing rotation equivalent to the specified Euler angles
            % angles. These correspond to rotations about the Z, Y, Z axes
            % respectively.
            %
            % Q = UnitQuaternion.eul(EUL, OPTIONS) as above but the Euler angles are
            % taken from the vector (1x3) EUL = [PHI THETA PSI]. If EUL is a matrix
            % (Nx3) then Q is a vector (1xN) of UnitQuaternion objects where the index
            % corresponds to rows of EUL which are assumed to be [PHI,THETA,PSI].
            % 
            % Options::
            % 'deg'   Compute angles in degrees (default radians)
            %
            % Notes::
            % - Is vectorised, see eul2r for details.
            %
            % See also UnitQuaternion.rpy, eul2r.
            [s,v] = UnitQuaternion.tr2q( eul2r(varargin{:}) );
            
            uq = UnitQuaternion();
            uq.s = s;
            uq.v = v;
        end
        
        function uq = vec(qv)
            %UnitQuaternion.vec Construct UnitQuaternion from 3-vector
            %
            % Q = UnitQuaternion.vec(V) is a UnitQuaternion constructed from just its vector
            % component (1x3) and the scalar part is 1 - norm(V) and will always be positive.
            % 
            % Notes::
            % - This unique and concise vector representation of a UnitQuaternion is often used 
            %   in bundle adjustment problems.
            %
            % See also UnitQuaternion.tovec, UnitVector.qvmul.
            s = sqrt(1 - sum(qv.^2));
            uq = UnitQuaternion(s, qv);
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% OTHER STATIC METHODS, ALTERNATIVE CONSTRUCTORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [s,v] = tr2q(R)
            %UnitQuaternion.TR2Q   Convert SO(3) or SE(3) matrix to unit quaternion as vector 
            %
            % [S,V] = UnitQuaternion.tr2q(R) is the scalar S and vector V (1x3) elements of a 
            % unit quaternion equivalent to the SO(3) rotation matrix R (3x3).
            %
            % [S,V] = UnitQuaternion.tr2q(T) as above but for the rotational part of the SE(3) matrix T (4x4).
            %
            % Notes::
            % - Is a static class method.
            %
            % Reference::
            % - Funda, Taylor, IEEE Trans. Robotics and Automation, 6(3), June 1990, pp.382-388.
            
            % modified version of sign() function as per the paper
            %  sign(x) = 1 if x>=0
            function s = sign(x) 
                if x >= 0
                    s = 1;
                else
                    s = -1;
                end
            end
            
            if ishomog(R)
                R = t2r(R);
            end
            s = sqrt(trace(R)+1)/2.0;
            kx = R(3,2) - R(2,3);   % Oz - Ay
            ky = R(1,3) - R(3,1);   % Ax - Nz
            kz = R(2,1) - R(1,2);   % Ny - Ox
            
            if isa(R, 'sym') 
                s = simplify(s);
                v = simplify( [kx ky kz] / (4*s) );
            else
                % for the numerical case, deal with rotations by very small angles
                
                % equation (7)
                [~,k] = max(diag(R));
                switch k
                    case 1  % Nx dominates
                        kx1 = R(1,1) - R(2,2) - R(3,3) + 1; % Nx - Oy - Az + 1
                        ky1 = R(2,1) + R(1,2);          % Ny + Ox
                        kz1 = R(3,1) + R(1,3);          % Nz + Ax
                        sgn = sign(kx);
                    case 2  % Oy dominates
                        kx1 = R(2,1) + R(1,2);          % Ny + Ox
                        ky1 = R(2,2) - R(1,1) - R(3,3) + 1; % Oy - Nx - Az + 1
                        kz1 = R(3,2) + R(2,3);          % Oz + Ay
                        sgn = sign(ky);
                    case 3 % Az dominates
                        kx1 = R(3,1) + R(1,3);          % Nz + Ax
                        ky1 = R(3,2) + R(2,3);          % Oz + Ay
                        kz1 = R(3,3) - R(1,1) - R(2,2) + 1; % Az - Nx - Oy + 1
                        add = (kz >= 0);
                        sgn = sign(kz);
                end
                
                % equation (8)
                kx = kx + sgn*kx1;
                ky = ky + sgn*ky1;
                kz = kz + sgn*kz1;

                nm = norm([kx ky kz]);
                if nm == 0
                    % handle special case of null quaternion
                    s = 1;
                    v = [0 0 0];
                else
                    v = [kx ky kz] * sqrt(1 - s^2) / nm;  % equation (10)
                end
            end
        end

        
        function R = q2r(q)
            %UnitQuaternion.q2r  Convert unit quaternion as vector to SO(3) rotation matrix
            %
            % UnitQuaternion.q2r(V) is an SO(3) orthonormal rotation matrix (3x3) representing the
            % same 3D orientation as the elements of the unit quaternion V (1x4).
            %
            % Notes::
            % - Is a static class method.
            %
            % Reference::
            % - Funda, Taylor, IEEE Trans. Robotics and Automation, 6(3), June 1990, pp.382-388.
            %
            % See also UnitQuaternion.tr2q
            
            s = q(1);
            x = q(2);
            y = q(3);
            z = q(4);
            
            R = [   1-2*(y^2+z^2)   2*(x*y-s*z) 2*(x*z+s*y)
                2*(x*y+s*z) 1-2*(x^2+z^2)   2*(y*z-s*x)
                2*(x*z-s*y) 2*(y*z+s*x) 1-2*(x^2+y^2)   ];
            
        end
        
        
        function out1 = qvmul(qa, qb)
            %UnitQuaternion.QVMUL Multiply unit quaternions defined by vector part
            %
            % QV = UnitQuaternion.QVMUL(QV1, QV2) multiplies two unit-quaternions
            % defined only by their vector components QV1 and QV2 (3x1).  The result is
            % similarly the vector component of the Hamilton product (3x1).
            %
            % Notes::
            % - Is a static class method.
            %
            % See also UnitQuaternion.tovec, UnitQuaternion.vec.
            
            % generated symbolically then hand simplified.

%             %
%             %          qp = qvmul(qax, qay, qaz, qbx, qby, qbz)
%             %
%             % which compounds two quaternions (qax,qay,qaz) and (qbx,qby,qbz)
%             % represented only by their vector components and returns a quaternion
%             % vector (qpx,qpy,qpz).  It is important that the quaternions have positive
%             % scalar components.
%             %
%             syms qs qx qy real
%             qz = sym('qz', 'real'); % since qz is a builtin function :(
%             qs = sqrt(1- qx^2 - qy^2 - qz^2);
%
%             % quaternion vector update
%             syms qs2 qx2 qy2 qz2 real
%             qs2 = sqrt(1-qx2^2 - qy2^2 - qz2^2);
%             
%             % create two quaternions, scalar parts are functions of vector parts
%             Q1 = Quaternion([qs qx qy qz]);
%             Q2 = Quaternion([qs2 qx2 qy2 qz2]);
%             
%             % multiply them
%             QQ = Q1 * Q2;
%             
%             % create a function to compute the vector part, as a function of
%             % the two input vector parts
%             fprintf('creating file --> qvmul.m\n');
%             matlabFunction(QQ.v, 'file', 'qvmul', 'Vars', [qx qy qz qx2 qy2 qz2]);
            
%             t2 = qa(1).^2;
%             t3 = qa(2).^2;
%             t4 = qa(3).^2;
%             t5 = -t2-t3-t4+1.0;
%             t6 = sqrt(t5);
            t6 = sqrt(1 - sum(qa.^2));
            
%             t7 = qb(1).^2;
%             t8 = qb(2).^2;
%             t9 = qb(3).^2;
%             t10 = -t7-t8-t9+1.0;
%             t11 = sqrt(t10);
            t11 = sqrt(1 - sum(qb.^2));

            out1 = [qa(2).*qb(3)-qb(2).*qa(3)+qb(1).*t6+qa(1).*t11,-qa(1).*qb(3)+qb(1).*qa(3)+qb(2).*t6+qa(2).*t11,qa(1).*qb(2)-qb(1).*qa(2)+qb(3).*t6+qa(3).*t11];
        end
            
        end % static methods
    
end % classdef


