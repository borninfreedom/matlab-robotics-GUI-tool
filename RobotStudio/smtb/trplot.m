%TRPLOT Plot a 3D coordinate frame
%
% TRPLOT(T, OPTIONS) draws a 3D coordinate frame represented by the SE(3) homogeneous 
% transform T (4x4).
%
% H = TRPLOT(T, OPTIONS) as above but returns a handle.
%
% TRPLOT(R, OPTIONS) as above but the coordinate frame is rotated about the
% origin according to the orthonormal rotation matrix R (3x3).
%
% H = TRPLOT(R, OPTIONS) as above but returns a handle.
%
% H = TRPLOT() creates a default frame EYE(3,3) at the origin and returns a
% handle.
%
% Animation::
%
% Firstly, create a plot and keep the the handle as per above.
%
% TRPLOT(H, T) moves the coordinate frame described by the handle H to
% the pose T (4x4).
%
% Options::
% 'handle',h             Update the specified handle
% 'axhandle',A           Draw in the MATLAB axes specified by the axis handle A
%
% 'color',C              The color to draw the axes, MATLAB ColorSpec
% 'axes'                 Show the MATLAB axes, box and ticks (default true)
% 'axis',A               Set dimensions of the MATLAB axes to A=[xmin xmax ymin ymax zmin zmax]
% 'frame',F              The coordinate frame is named {F} and the subscript on the axis labels is F.
% 'framelabel',F         The coordinate frame is named {F}, axes have no subscripts.
% 'framelabeloffset',O   Offset O=[DX DY] frame labels in units of text box height
% 'text_opts', opt       A cell array of MATLAB text properties
% 'length',s             Length of the coordinate frame arms (default 1)
% 'thick',t              Thickness of lines (default 0.5)
% 'text'                 Enable display of X,Y,Z labels on the frame (default true)
% 'labels',L             Label the X,Y,Z axes with the 1st, 2nd, 3rd character of the string L
% 'rgb'                  Display X,Y,Z axes in colors red, green, blue respectively
% 'rviz'                 Display chunky rviz style axes%
% 'arrow'                Use arrows rather than line segments for the axes
% 'width', w             Width of arrow tips (default 1)
%
% 'perspective'          Display the axes with perspective projection (default off)
% '3d'                   Plot in 3D using anaglyph graphics
% 'anaglyph',A           Specify anaglyph colors for '3d' as 2 characters for 
%                        left and right (default colors 'rc'): chosen from
%                        r)ed, g)reen, b)lue, c)yan, m)agenta.
% 'dispar',D             Disparity for 3d display (default 0.1)
% 'view',V               Set plot view parameters V=[az el] angles, or 'auto' 
%                        for view toward origin of coordinate frame
% 'lefty'                Draw left-handed frame (dangerous)
%
% Examples::
%
%       trplot(T, 'frame', 'A')
%       trplot(T, 'frame', 'A', 'color', 'b')
%       trplot(T1, 'frame', 'A', 'text_opts', {'FontSize', 10, 'FontWeight', 'bold'})
%       trplot(T1, 'labels', 'NOA');
%
%       h = trplot(T, 'frame', 'A', 'color', 'b');
%       trplot(h, T2);
%
% 3D anaglyph plot
%       trplot(T, '3d');
%
% Notes::
% - Multiple frames can be added using the HOLD command
% - When animating a coordinate frame it is best to set the axis bounds initially.
% - The 'rviz' option is equivalent to 'rgb', 'notext', 'noarrow', 
%   'thick', 5.
% - The 'arrow' option requires https://www.mathworks.com/matlabcentral/fileexchange/14056-arrow3

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

%TODO:
% 'rviz', chunky RGB lines, no arrows


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

% TODO
%  need to decide how to handle scaling
%  what does hold on mean?  don't touch scaling?

function hout = trplot(T, varargin)

    if nargin == 0
        T = eye(3,3);
    end
    
    if size(T,3) > 1
        error('SMTB:trplot:badarg', 'trplot cannot operate on a sequence');
    end
    if isa(T, 'SE3')
        T = T.T;
    elseif ~ishomog(T) && ~isrot(T)
        error('SMTB:trplot:badarg', 'trplot operates only on transform (4x4) or rotation matrix (3x3)');
    end
    
    opt.color = 'b';
    opt.textcolor = [];
    opt.rgb = false;
    opt.axes = true;
    opt.axis = [];
    opt.frame = [];
    opt.framelabel = [];
    opt.text_opts = [];
    opt.view = [];
    opt.width = 1;
    opt.arrow = false;
    opt.labels = 'XYZ';
    opt.axhandle = [];
    opt.anaglyph = 'rc';
    opt.d_3d = false;
    opt.dispar = 0.1;
    opt.thick = 0.5;
    opt.length = 1;
    opt.text = true;
    opt.lefty = false;
    opt.rviz = false;
    opt.framelabeloffset = [0 0];
    opt.handle = [];
    opt.perspective = false;
    
    [opt,args] = tb_optparse(opt, varargin);
    
    if opt.arrow && ~exist('arrow3')
        opt.arrow = false;
        warning('SMTB:trplot:badarg', 'arrow option requires arrow3 from FileExchange');
    end
        
    if isscalar(T) && ishandle(T)
        warning('SMTB:trplot:deprecated', 'Use ''handle'' option');
        % trplot(H, T)
        opt.handle = T; T = args{1};
    end
    
    % ensure it's SE(3)
    if isrot(T)
        T = r2t(T);
    end
    
    if ~isempty(opt.handle)
        set(opt.handle, 'Matrix', T);
        % for the 3D case retrieve the right hgtransform and set it
        hg2 = get(opt.handle, 'UserData');
        if ~isempty(hg2)
            set(hg2, 'Matrix', T);
        end
        if nargout > 0
            hout = opt.handle;
        end
        return;
    end

    if opt.rviz
        opt.thick = 5;
        opt.arrow = false;
        opt.rgb = true;
        opt.text = false;
    end

    if opt.rgb && opt.d_3d
        error('SMTB:trplot:badarg', 'cannot specify ''rgb'' and ''3d'', use ''anaglyph'' option');
    end
    if isempty(opt.textcolor)
        opt.textcolor = opt.color;
    end
    if isempty(opt.text_opts)
        opt.text_opts = {};
    end
    
    if opt.d_3d
        opt.color = ag_color(opt.anaglyph(1));
    end
    
    % figure the dimensions of the axes, if not given
    if isempty(opt.axis)
        % determine some default axis dimensions
        
        % get the origin of the frame
        if isrot(T)
            c = [0 0 0];  % at zero for a rotation matrix
        else
            c = transl(T);    
        end
        
        d = 1.2;
        opt.axis = [c(1)-d c(1)+d c(2)-d c(2)+d c(3)-d c(3)+d];
        
    end
        
    if ~isempty(opt.axhandle)
        hax = opt.axhandle;
        hold(hax);
    else
        ih = ishold;
        if ~ih
            % if hold is not on, then clear the axes and set scaling
            cla
            if ~isempty(opt.axis)
                axis(opt.axis);
            end
            daspect([1 1 1]);
            
            if opt.axes
                xlabel( 'X');
                ylabel( 'Y');
                zlabel( 'Z');
                rotate3d on
            end
            new_plot = true;
        end
        hax = gca;
        hold on
    end
    % hax is the handle for the axis we will work with, either new or
    % passed by option 'handle'

    opt.text_opts = [opt.text_opts, 'Color', opt.color];

    if opt.perspective
        hax.Projection = 'perspective';
    end
    hg = hgtransform('Parent', hax);


    % trplot( Q.R, fmt, color);
    if isrot(T)
        T = r2t(T);
    end

    % create unit vectors
    o =  [0 0 0]';
    x1 = opt.length*[1 0 0]';
    y1 = opt.length*[0 1 0]';
    if opt.lefty
        z1 = opt.length*[0 0 -1]';
    else
        z1 = opt.length*[0 0 1]';
    end
    
    % draw the axes
    
    mstart = [o o o]';
    mend = [x1 y1 z1]';

    if opt.rgb
        axcolors = {'r', 'g', 'b'};
    else
        axcolors = { opt.color, opt.color, opt.color};
    end
    
    if opt.arrow
%         % draw the 3 arrows
%         S = [opt.color num2str(opt.width)];
%         ha = arrow3(mstart, mend, S);
%         for h=ha'
%             set(h, 'Parent', hg);
%         end
          daspect([1,1,1])
          for i=1:3
              ha = arrow3(mstart(i,1:3), mend(i,1:3), axcolors{i}, opt.width);
              set(ha, 'Parent', hg);
          end
    else
        for i=1:3
            plot2([mstart(i,1:3); mend(i,1:3)], 'Color', axcolors{i}, ...
                'LineWidth', opt.thick, ...
                'Parent', hg);
        end
    end
    
    % label the axes
    if isempty(opt.frame)
        fmt = '%c';
    else
        fmt = sprintf('%%c_{%s}', opt.frame);
    end
    
    if opt.text
        % add the labels to each axis
        h = text(x1(1), x1(2), x1(3), sprintf(fmt, opt.labels(1)), 'Parent', hg);
        set(h, opt.text_opts{:});
        
        h = text(y1(1), y1(2), y1(3), sprintf(fmt, opt.labels(2)), 'Parent', hg);
        set(h, opt.text_opts{:});
        
        h = text(z1(1), z1(2), z1(3), sprintf(fmt, opt.labels(3)), 'Parent', hg);
        set(h, opt.text_opts{:});
    end
    
    if ~isempty(opt.framelabel)
        opt.frame = opt.framelabel;
    end
    % label the frame
    if ~isempty(opt.frame)
        h = text(o(1), o(2), o(3), ...
            ['\{' opt.frame '\}'], 'Parent', hg);
        set(h, 'VerticalAlignment', 'top', ...
            'HorizontalAlignment', 'center', opt.text_opts{:}, ...
            'FontUnits', 'normalized');
        e = get(h, 'Extent');
        d = e(4); % use height of text box as a scale factor
        e(1:2) = e(1:2) - opt.framelabeloffset * d;
        set(h, 'Position', e(1:2));

    end
    
    if ~opt.axes
        set(gca, 'visible', 'off');
    end
    if ischar(opt.view) && strcmp(opt.view, 'auto')
        cam = x1+y1+z1;
        view(cam(1:3));
    elseif ~isempty(opt.view)
        view(opt.view);
    end
    if isempty(opt.handle) && ~ih
        grid on
        hold off
    end
    
    % now place the frame in the desired pose
    set(hg, 'Matrix', T);

    
    if opt.d_3d
        % 3D display.  The original axes are for the left eye, and we add 
        % another set of axes to the figure for the right eye view and
        % displace its camera to the right of that of that for the left eye.
        % Then we recursively call trplot() to create the right eye view.
        
        left = gca;
        right = axes;
        
        % compute the offset in world coordinates
        off = -t2r(view(left))'*[opt.dispar 0 0]';
        pos = get(left, 'CameraPosition');
        
        set(right, 'CameraPosition', pos+off');
        set(right, 'CameraViewAngle', get(left, 'CameraViewAngle'));
        set(right, 'CameraUpVector', get(left, 'CameraUpVector'));
        target = get(left, 'CameraTarget');
        set(right, 'CameraTarget', target+off');
        
        % set perspective projections
        set(left, 'Projection', 'perspective');
        set(right, 'Projection', 'perspective');
        
        % turn off axes for right view
        set(right, 'Visible', 'Off');
        
        % set color for right view
        hg2 = trplot(T, 'color', ag_color(opt.anaglyph(2)));
        
        % the hgtransform for the right view is user data for the left
        % view hgtransform, we need to change both when we rotate the 
        % frame.
        set(hg, 'UserData', hg2);
    end

    % optionally return the handle, for later modification of pose
    if nargout > 0
        hout = hg;
    end
end

function out = ag_color(c)

% map color character to an color triple, same as anaglyph.m

    % map single letter color codes to image planes
    switch c
    case 'r'
        out = [1 0 0];        % red
    case 'g'
        out = [0 1 0];        % green
    case 'b'
        % blue
        out = [0 0 1];
    case 'c'
        out = [0 1 1];        % cyan
    case 'm'
        out = [1 0 1];        % magenta
    case 'o'
        out = [1 1 0];        % orange
    end
end
