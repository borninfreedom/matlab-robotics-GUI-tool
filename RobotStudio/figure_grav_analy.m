function varargout = figure_grav_analy(varargin)
% FIGURE_GRAV_ANALY MATLAB code for figure_grav_analy.fig
%      FIGURE_GRAV_ANALY, by itself, creates a new FIGURE_GRAV_ANALY or raises the existing
%      singleton*.
%
%      H = FIGURE_GRAV_ANALY returns the handle to a new FIGURE_GRAV_ANALY or the handle to
%      the existing singleton*.
%
%      FIGURE_GRAV_ANALY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_GRAV_ANALY.M with the given input arguments.
%
%      FIGURE_GRAV_ANALY('Property','Value',...) creates a new FIGURE_GRAV_ANALY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before figure_grav_analy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to figure_grav_analy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help figure_grav_analy

% Last Modified by GUIDE v2.5 28-Nov-2019 14:32:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figure_grav_analy_OpeningFcn, ...
                   'gui_OutputFcn',  @figure_grav_analy_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before figure_grav_analy is made visible.
function figure_grav_analy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to figure_grav_analy (see VARARGIN)

% Choose default command line output for figure_grav_analy
handles.output = hObject;
% h = RobotStudio;
% h = guihandles(h);
% 
% handles.p560 = h.g_p560;
% handles.qn = h.g_qn;
mdl_puma560;
handles.p560 = p560;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes figure_grav_analy wait for user response (see UIRESUME)
% uiwait(handles.figure_gravload_analysis);


% --- Outputs from this function are returned to the command line.
function varargout = figure_grav_analy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'value',1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p560 = handles.p560;

V = get(handles.popupmenu1,'value');

[Q0  Q1] = meshgrid(-pi:0.1:pi, -pi:0.1:pi);

g1 = zeros(numcols(Q0), numcols(Q1));
g2 = zeros(numcols(Q0), numcols(Q1));
g3 = zeros(numcols(Q0), numcols(Q1));
g4 = zeros(numcols(Q0), numcols(Q1));
g5 = zeros(numcols(Q0), numcols(Q1));
g6 = zeros(numcols(Q0), numcols(Q1));

set(handles.text_warn,'String','请稍等');
drawnow;  %可立即处理请求，如果不加，显示的字符会等着计算结果出来后一起显示。

switch V
    case 1   
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([Q0(i,j)  Q1(i,j) 0 0 0 0]);
                g1(i,j) = g(1);
                g2(i,j) = g(2);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g1);    
        xlabel('q1');  ylabel('q2');  zlabel('关节1重力载荷');
 
        axes(handles.axes3)
        surfl(Q0,Q1,g2);
        xlabel('q1');   ylabel('q2');   zlabel('关节2重力载荷');
        
     case 2   
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([Q0(i,j)  0  Q1(i,j)  0 0 0]);
                g1(i,j) = g(1);
                g3(i,j) = g(3);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g1);    
        xlabel('q1');  ylabel('q3');  zlabel('关节1重力载荷');
 
        axes(handles.axes3)
        surfl(Q0,Q1,g3);
        xlabel('q1');   ylabel('q3');   zlabel('关节3重力载荷');
     
    case 3
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([Q0(i,j) 0 0  Q1(i,j)  0 0]);
                g1(i,j) = g(1);
                g4(i,j) = g(4);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g1);
        xlabel('q1');  ylabel('q4');  zlabel('关节1重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g4);
        xlabel('q1');   ylabel('q4');   zlabel('关节4重力载荷');
        
    case 4
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([Q0(i,j) 0 0 0  Q1(i,j)  0]);
                g1(i,j) = g(1);
                g5(i,j) = g(5);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g1);
        xlabel('q1');  ylabel('q5');  zlabel('关节1重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g5);
        xlabel('q1');   ylabel('q5');   zlabel('关节5重力载荷');
        
    case 5
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([Q0(i,j) 0 0 0 0  Q1(i,j) ]);
                g1(i,j) = g(1);
                g6(i,j) = g(6);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g1);
        xlabel('q1');  ylabel('q6');  zlabel('关节1重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g6);
        xlabel('q1');   ylabel('q6');   zlabel('关节6重力载荷');
        
    case 6
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  Q0(i,j)  Q1(i,j)  0 0 0]);
                g2(i,j) = g(2);
                g3(i,j) = g(3);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g2);
        xlabel('q2');  ylabel('q3');  zlabel('关节2重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g3);
        xlabel('q2');   ylabel('q3');   zlabel('关节3重力载荷');
        
    case 7
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  Q0(i,j)  0 Q1(i,j)   0 0]);
                g2(i,j) = g(2);
                g4(i,j) = g(4);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g2);
        xlabel('q2');  ylabel('q4');  zlabel('关节2重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g4);
        xlabel('q2');   ylabel('q4');   zlabel('关节4重力载荷');
        
    case 8
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  Q0(i,j) 0  0 Q1(i,j)    0]);
                g2(i,j) = g(2);
                g5(i,j) = g(5);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g2);
        xlabel('q2');  ylabel('q5');  zlabel('关节2重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g5);
        xlabel('q2');   ylabel('q5');   zlabel('关节5重力载荷');
        
    case 9
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  Q0(i,j)  0   0 0  Q1(i,j) ]);
                g2(i,j) = g(2);
                g6(i,j) = g(6);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g2);
        xlabel('q2');  ylabel('q6');  zlabel('关节2重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g6);
        xlabel('q2');   ylabel('q6');   zlabel('关节6重力载荷');
        
    case 10
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0   0  Q0(i,j)  Q1(i,j)   0 0]);
                g3(i,j) = g(3);
                g4(i,j) = g(4);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g3);
        xlabel('q3');  ylabel('q4');  zlabel('关节3重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g4);
        xlabel('q3');   ylabel('q4');   zlabel('关节4重力载荷');
        
    case 11
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  0  Q0(i,j)  0 Q1(i,j)    0]);
                g3(i,j) = g(3);
                g5(i,j) = g(5);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g3);
        xlabel('q3');  ylabel('q5');  zlabel('关节3重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g5);
        xlabel('q3');   ylabel('q5');   zlabel('关节5重力载荷');
        
    case 12
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  0  Q0(i,j)  0  0  Q1(i,j)   ]);
                g3(i,j) = g(3);
                g6(i,j) = g(6);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g3);
        xlabel('q3');  ylabel('q6');  zlabel('关节3重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g6);
        xlabel('q3');   ylabel('q6');   zlabel('关节6重力载荷');
        
    case 13
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  0  0  Q0(i,j)   Q1(i,j) 0 ]);
                g4(i,j) = g(4);
                g5(i,j) = g(5);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g4);
        xlabel('q4');  ylabel('q5');  zlabel('关节4重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g5);
        xlabel('q4');   ylabel('q5');   zlabel('关节5重力载荷');
        
    case 14
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  0  0  Q0(i,j)  0  Q1(i,j)  ]);
                g4(i,j) = g(4);
                g6(i,j) = g(6);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g4);
        xlabel('q4');  ylabel('q6');  zlabel('关节4重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g6);
        xlabel('q4');   ylabel('q6');   zlabel('关节6重力载荷');
        
    case 15
        for i = 1:numcols(Q0)
            for j = 1:numcols(Q1)
                g = p560.gravload([0  0  0   0  Q0(i,j)  Q1(i,j)  ]);
                g5(i,j) = g(5);
                g6(i,j) = g(6);
            end
        end
        set(handles.text_warn,'string',' ');
        drawnow
        
        axes(handles.axes1)
        surfl(Q0,Q1,g5);
        xlabel('q5');  ylabel('q6');  zlabel('关节5重力载荷');
        
        axes(handles.axes3)
        surfl(Q0,Q1,g6);
        xlabel('q5');   ylabel('q6');   zlabel('关节6重力载荷');
        
end





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
