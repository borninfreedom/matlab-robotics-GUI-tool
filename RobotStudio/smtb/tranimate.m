%TRANIMATE Animate a 3D coordinate frame
%
% TRANIMATE(P1, P2, OPTIONS) animates a 3D coordinate frame moving from pose X1
% to pose X2.  Poses X1 and X2 can be represented by:
%   - SE(3) homogeneous transformation matrices (4x4)
%   - SO(3) orthonormal rotation matrices (3x3)
%
% TRANIMATE(X, OPTIONS) animates a coordinate frame moving from the identity pose
% to the pose X represented by any of the types listed above.
%
% TRANIMATE(XSEQ, OPTIONS) animates a trajectory, where XSEQ is any of
%   - SE(3) homogeneous transformation matrix sequence (4x4xN)
%   - SO(3) orthonormal rotation matrix sequence (3x3xN)
%
% Options::
%  'fps', fps    Number of frames per second to display (default 10)
%  'nsteps', n   The number of steps along the path (default 50)
%  'axis',A      Axis bounds [xmin, xmax, ymin, ymax, zmin, zmax]
%  'movie',M     Save frames as a movie or sequence of frames
%  'cleanup'     Remove the frame at end of animation
%  'noxyz'       Don't label the axes
%  'rgb'         Color the axes in the order x=red, y=green, z=blue
%  'retain'      Retain frames, don't animate
%  Additional options are passed through to TRPLOT.
%
% Notes::
% - Uses the Animate helper class to record the frames.
%
% See also TRPLOT, Animate, SE3.animate.

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
%  auto detect the axis scaling
function tranimate(P2, varargin)

    opt.fps = 10;
    opt.nsteps = 50;
    opt.axis = [];
    opt.movie = [];
    opt.cleanup = false;
    opt.retain = false;
    opt.time = [];

    [opt, args] = tb_optparse(opt, varargin);
    
    ud.opt = opt;
    ud.args = args;
    
    if ~isempty(opt.movie)
        ud.anim = Animate(opt.movie);
    end
    P1 = [];
    if ~isempty(opt.time) && isempty(opt.fps)
        opt.fps = 1 /(opt.time(2) - opt.time(1));
    end


    % convert quaternion and rotation matrix to hom transform
    if isrot(P2)
        % tranimate(R1, options)
        % tranimate(R1, R2, options)
        T2 = r2t(P2);
        if ~isempty(args) && isrot(args{1})
            T1 = T2;
            T2 = r2t(args{1});
            args = args(2:end);
        else
            T1 = eye(4,4);
        end
    elseif ishomog(P2)
        % tranimate(T1, options)
        % tranimate(T1, T2, options)
        T2 = P2;
        if ~isempty(args) && ishomog(args{1})
            T1 = T2;
            T2 = args{1};
            args = args(2:end);
        else
            T1 = eye(4,4);
        end
    elseif isa(P2, 'function_handle')
        % we were passed a handle
        %
        % tranimate( @func(x), x, options)
        T2 = [];
        for x = args{1}
            T2 = cat(3, T2, P2(x));
        end
    else
        error('SMTB:tranimate:badarg', 'argument must be 3x3 or 4x4 matrix');
    end
    
    % at this point
    %   T1 is the initial pose
    %   T2 is the final pose
    %
    %  T2 may be a sequence
        
    if size(T2,3) > 1
        % tranimate(Ts)
        % we were passed a homog sequence
        if ~isempty(P1)
            error('only 1 input argument if sequence specified');
        end
        Ttraj = T2;
    else
        % tranimate(P1, P2)
        % create a path between them
        Ttraj = trinterp(T1, T2, linspace(0, 1, opt.nsteps));
    end
    
    if isempty(opt.axis)
        % create axis limits automatically based on motion of frame origin
        t = transl(Ttraj);
        mn = min(t) - 1.5;  % min value + length of axis + some
        mx = max(t) + 1.5;  % max value + length of axis + some
        axlim = [mn; mx];
        axlim = axlim(:)';
        args = [args 'axis' axlim];
    else
        args = [args 'axis' opt.axis];
    end
    
    if opt.retain
        hold on
        ud.hg = [];  % indicate no animation
    else
        ud.hg = trplot(eye(4,4), args{:});  % create a frame at the origin
    end
    ud.Ttraj = Ttraj;

    if ~isempty(opt.time)
        ud.htime = uicontrol('Parent', gcf, 'Style', 'text', ...
            'HorizontalAlignment', 'left', 'Position', [50 20 100 20]);
    end
    % animate it for all poses in the sequence
    

    t = timer('ExecutionMode', 'fixedRate', ...
        'BusyMode', 'queue', ...
        'UserData', ud, ...
        'TasksToExecute', length(ud.Ttraj), ...
        'Period', 1/opt.fps/2);
    t.TimerFcn = @timer_callback;
    start(t);
    
    waitfor(t)
    
    if ~isempty(ud.opt.movie)
        ud.anim.close();
    end
    delete(t)
        if opt.cleanup
            delete(ud.hg);
        end
end

function guts(ud, i)
    if isa(ud.Ttraj, 'SO3')
        T = ud.Ttraj(i);
    else
        T = ud.Ttraj(:,:,i);
    end
    if ud.opt.retain
        trplot(T, ud.args{:});
    else
        trplot(T, 'handle', ud.hg);
    end
    
    if ~isempty(ud.opt.movie)
        ud.anim.add();
    end
    
    if ~isempty(ud.opt.time)
        set(ud.htime, 'String', sprintf('time %g', ud.opt.time(i)));
    end
    drawnow
              
end

function timer_callback(timerObj, ~)
    ud = get(timerObj, 'UserData');
    if ~ishandle(ud.hg)
        % the figure has been closed
        stop(timerObj);
        delete(timerObj);
    end
    
    i = timerObj.TasksExecuted;
    
    guts(ud, i);
    
end
