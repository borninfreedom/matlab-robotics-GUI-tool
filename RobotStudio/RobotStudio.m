function varargout = RobotStudio(varargin)
% ROBOTSTUDIO MATLAB code for RobotStudio.fig
%      ROBOTSTUDIO, by itself, creates a new ROBOTSTUDIO or raises the existing
%      singleton*.
%
%      H = ROBOTSTUDIO returns the handle to a new ROBOTSTUDIO or the handle to
%      the existing singleton*.
%
%      ROBOTSTUDIO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTSTUDIO.M with the given input arguments.
%
%      ROBOTSTUDIO('Property','Value',...) creates a new ROBOTSTUDIO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotStudio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotStudio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotStudio

% Last Modified by GUIDE v2.5 28-Nov-2019 15:34:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RobotStudio_OpeningFcn, ...
                   'gui_OutputFcn',  @RobotStudio_OutputFcn, ...
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


% --- Executes just before RobotStudio is made visible.
function RobotStudio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotStudio (see VARARGIN)

% Choose default command line output for RobotStudio
handles.output = hObject;
   set(handles.radiobutton1,'value',1);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    
   mdl_puma560
   p560
   global g_p560;
   g_p560 = p560;
   global g_qn;
   g_qn = qn;
   handles.p560 = p560;
   handles.h_qn = qn;
  % guidata(hObject,handles); 
   axes(handles.axes1);
   cla reset
   g_p560.plot(g_qn)
   set(handles.slider1,'value',g_qn(1));
   set(handles.slider2,'value',g_qn(2));
   set(handles.slider3,'value',g_qn(3));
   set(handles.slider4,'value',g_qn(4));
   set(handles.slider5,'value',g_qn(5));
   set(handles.slider6,'value',g_qn(6));

   set(handles.text_state,'string','');

global g_flag_edit;
g_flag_edit = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotStudio wait for user response (see UIRESUME)
% uiwait(handles.figure_main);


% --- Outputs from this function are returned to the command line.
function varargout = RobotStudio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(1) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'value',0);

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(2) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
%         set(hObject,'Min',0);
%     set(hObject,'Max',2*pi);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'value',0);


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(3) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
%         set(hObject,'Min',0);
%     set(hObject,'Max',2*pi);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'Value',0);


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(4) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
%         set(hObject,'Min',0);
%     set(hObject,'Max',2*pi);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'value',0);


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(5) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
%         set(hObject,'Min',0);
%     set(hObject,'Max',2*pi);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'value',0);


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global g_qn;
global g_p560;
g_qn(6) = get(hObject,'Value')
axes(handles.axes1)
g_p560.plot(g_qn)

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
%         set(hObject,'Min',0);
%     set(hObject,'Max',2*pi);
end
set(hObject,'min',-2.2*pi);
set(hObject,'max',2.2*pi);
set(hObject,'value',0);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_p560;
global g_qn;
g_qn = handles.h_qn;
axes(handles.axes1);
cla reset
g_p560.plot(g_qn);
set(handles.slider1,'value',g_qn(1));
set(handles.slider2,'value',g_qn(2));
set(handles.slider3,'value',g_qn(3));
set(handles.slider4,'value',g_qn(4));
set(handles.slider5,'value',g_qn(5));
set(handles.slider6,'value',g_qn(6));
set(handles.edit_x_d,'string','0.5');
set(handles.edit_y_d,'string','0');
set(handles.edit_z_d,'string','0');
set(handles.edit_x1_d,'string','0');
set(handles.edit_y1_d,'string','0.5');
set(handles.edit_z1_d,'string','0.5');

axes(handles.axes2)
cla reset
axes(handles.axes5)
cla reset
axes(handels.axes6)
cla reset

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

    set(handles.text_state,'string','加载模型中...');
    
    set(handles.radiobutton1,'value',1);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
    
   mdl_puma560
   p560
   global g_p560;
   g_p560 = p560;
   global g_qn;
   g_qn = qn;
   handles.h_qn = qn;
   guidata(hObject,handles); 
   axes(handles.axes1);
   cla reset
   g_p560.plot(g_qn)
   set(handles.slider1,'value',g_qn(1));
   set(handles.slider2,'value',g_qn(2));
   set(handles.slider3,'value',g_qn(3));
   set(handles.slider4,'value',g_qn(4));
   set(handles.slider5,'value',g_qn(5));
   set(handles.slider6,'value',g_qn(6));

    set(handles.text_state,'string','');

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
 set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',1);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',0);
img = imread('img.jfif');
axes(handles.axes1);
imshow(img);
% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
 set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',1);
    set(handles.radiobutton4,'value',0);
img = imread('img.jfif');
axes(handles.axes1);
imshow(img);
% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
 set(handles.radiobutton1,'value',0);
    set(handles.radiobutton2,'value',0);
    set(handles.radiobutton3,'value',0);
    set(handles.radiobutton4,'value',1);
    img = imread('img.jfif');
axes(handles.axes1);
imshow(img);




% --- Executes on button press in pushbutton_go_j.
function pushbutton_go_j_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_go_j (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_p560;
global g_qn;

set(handles.text_state,'string','请稍等');
drawnow;

X = str2double(get(handles.editX,'String'))
Y = str2double(get(handles.editY,'String'))
Z = str2double(get(handles.editZ,'String'))
time = str2double(get(handles.editT,'String'))
T0 = g_p560.fkine(g_qn);
T1 = transl(X,Y,Z);
t = 0:0.05:time;

traj = g_p560.jtraj(T0,T1,t');

set(handles.text_state,'string',' ');
drawnow;

axes(handles.axes2);
cla reset
qplot(t,traj);
title('关节角');

T = g_p560.fkine(traj);
p = transl(T);
axes(handles.axes5);
cla reset
plot(t,p);
% plot(t,p(:,1));
% hold on
% plot(t,p(:,2));
% hold on
% plot(t,p(:,3));   %两种方式添加图例的效果是相同的
legend('X','Y','Z');
title('末端执行器位置');

axes(handles.axes6)
cla reset
plot(p(:,1),p(:,2));
legend('XY');
xlabel('X');
ylabel('Y');
title('XY平面投影轨迹');

axes(handles.axes1);
plot(g_p560,traj);

g_qn = g_p560.ikine6s(T1)

set(handles.slider1,'value',g_qn(1));
set(handles.slider2,'value',g_qn(2));
set(handles.slider3,'value',g_qn(3));
set(handles.slider4,'value',g_qn(4));
set(handles.slider5,'value',g_qn(5));
set(handles.slider6,'value',g_qn(6));

function editY_Callback(hObject, eventdata, handles)
% hObject    handle to editY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editY as text
%        str2double(get(hObject,'String')) returns contents of editY as a double

tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end

% --- Executes during object creation, after setting all properties.
function editY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');


function editX_Callback(hObject, eventdata, handles)
% hObject    handle to editX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editX as text
%        str2double(get(hObject,'String')) returns contents of editX as a double

tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end

% --- Executes during object creation, after setting all properties.
function editX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0.5');


function editZ_Callback(hObject, eventdata, handles)
% hObject    handle to editZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editZ as text
%        str2double(get(hObject,'String')) returns contents of editZ as a double

tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end

% --- Executes during object creation, after setting all properties.
function editZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');


function editT_Callback(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editT as text
%        str2double(get(hObject,'String')) returns contents of editT as a double
tmp = str2double(get(hObject,'String'));
if tmp <= 1
    tmp = 1;
    set(hObject,'String',num2str(tmp));
elseif tmp >= 10
    tmp = 10;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function editT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'max',5,'min',0);
set(hObject,'String','2');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over editX.
% function editX_ButtonDownFcn(hObject, eventdata, handles)
% % hObject    handle to editX (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% set(hObject,'String','0')
% 


function edit_t_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_d as text
%        str2double(get(hObject,'String')) returns contents of edit_t_d as a double
tmp = str2double(get(hObject,'String'));
if tmp <= 1
    tmp = 1;
    set(hObject,'String',num2str(tmp));
elseif tmp >= 10
    tmp = 10;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_t_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','50');


function edit_z_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z_d as text
%        str2double(get(hObject,'String')) returns contents of edit_z_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end

% --- Executes during object creation, after setting all properties.
function edit_z_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');


function edit_x_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x_d as text
%        str2double(get(hObject,'String')) returns contents of edit_x_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_x_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0.5');


function edit_y_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y_d as text
%        str2double(get(hObject,'String')) returns contents of edit_y_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_y_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');

% --- Executes on button press in pushbutton_dke.
function pushbutton_dke_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_p560;
global g_qn;

set(handles.text_state,'string','请稍等');
drawnow;

X0 = str2double(get(handles.edit_x_d,'String'));
Y0 = str2double(get(handles.edit_y_d,'String'));
Z0 = str2double(get(handles.edit_z_d,'String'));
STEP = str2double(get(handles.edit_t_d,'String'));
t = 0 : 1 : STEP;
X1 = str2double(get(handles.edit_x1_d,'String'));
Y1 = str2double(get(handles.edit_y1_d,'String'));
Z1 = str2double(get(handles.edit_z1_d,'String'));

T0 = transl(X0,Y0,Z0);      %坐标变换为齐次变换矩阵
q0 = g_p560.ikine6s(T0);
plot(g_p560,q0);

T1 = transl(X1,Y1,Z1);  %T1 齐次变换阵

T = ctraj(T0,T1,STEP);  % T 齐次变换阵
q = g_p560.ikine6s(T);  % q 关节角度

set(handles.text_state,'string',' ');
drawnow;

axes(handles.axes2)
cla reset
qplot(q);
title('关节角')

[Xq Yq Zq] = transl(T);
axes(handles.axes6);
cla reset  %清除图窗原有内容
plot(Xq,Yq);
xlim([-1 1])
ylim([-1 1])
title('XY平面投影轨迹');

p = transl(T);
axes(handles.axes5)
cla reset
plot(p)
% plot(Xq);    % p=transl(T)和[X Y Z]=transl(T) , p和[x y z]的内容是一样的
% hold on
% plot(Yq);
% hold on
% plot(Zq)
legend('X','Y','Z')
title('末端执行器XYZ位置')

axes(handles.axes1)
plot(g_p560, q);

set(handles.edit_x_d,'string',num2str(X1));
set(handles.edit_y_d,'string',num2str(Y1));
set(handles.edit_z_d,'string',num2str(Z1));





% --- Executes on button press in pushbutton_sl_jspace.
function pushbutton_sl_jspace_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sl_jspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mdl_puma560
sl_jspace



function edit_z1_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z1_d as text
%        str2double(get(hObject,'String')) returns contents of edit_z1_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_z1_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','0.5');


function edit_x1_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x1_d as text
%        str2double(get(hObject,'String')) returns contents of edit_x1_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_x1_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','0');


function edit_y1_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y1_d as text
%        str2double(get(hObject,'String')) returns contents of edit_y1_d as a double
tmp = str2double(get(hObject,'String'));
if tmp < -0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
elseif tmp > 0.8
    tmp = 0.8;
    set(hObject,'String',num2str(tmp));
end


% --- Executes during object creation, after setting all properties.
function edit_y1_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y1_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','0.5');   %记录一个悲痛的时刻，debug一个多小时，就是找不到原因，最后发现把你写成了 0,5  fuck


% --- Executes on button press in pushbutton_draw_circle.
function pushbutton_draw_circle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_draw_circle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_p560;
r = 0.5;
step = 100;
X = zeros(1,step);
Y = zeros(1,step);
Z = zeros(1,step);
%T = zeros(1,step);
for i = 1: step
    X(i) = r * cos(2*pi/step * i);
    Y(i) = r * sin(2*pi/step * i);
   
    Z(i) = 0.1;
end

axes(handles.axes6)
plot(X,Y);
axis square
title('XY平面投影轨迹')

%T = transl(X',Y',Z');
axes(handles.axes1)
for i = 1:step
    T = transl(X(i),Y(i),Z(i));
    q = g_p560.ikine6s(T);
    plot(g_p560,q);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global g_p560;
global g_qn;
 Data = cell(6,6);
V = get(hObject,'value');
switch V
    case 2
        Data = g_p560.jacob0(g_qn);
        set(handles.uitable1,'data',Data);
    case 3
         Data = g_p560.jacobe(g_qn);
        set(handles.uitable1,'data',Data);
    case 4
        J = g_p560.jacob0(g_qn);
        J = J(1:3,:);
        J1 = g_p560.jacob0(g_qn);
        J1 = J1(4:6,:);
        
        h = figure_yoshikawa;  %多窗口编程
        h = guihandles(h);
    
        axes(h.axes1)
        cla reset
        plot_ellipse(J*J')
        
        axes(h.axes2)
        cla reset
        plot_ellipse(J1*J1')
    case 5
       data  = cell(1,1);
       data = g_p560.maniplty(g_qn,'yoshikawa');
       set(handles.uitable1,'data',data,'FontSize',11);
    case 6
        p560 = g_p560;
        qn = g_qn;
        Q = p560.gravload(qn);
        data = cell(1,6);
        data = Q;
        set(handles.uitable1,'data',data);
        
    case 7
        h = figure_grav_analy;
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'value',1);


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns
% called
set(hObject,'ColumnWidth',{80,80,80,80,80,80});


% --- Executes on button press in checkbox_jtraj.
function checkbox_jtraj_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_jtraj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_jtraj
if get(handles.checkbox_jtraj,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;

    set(handles.checkbox_jtraj,'value',1);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
                                                      
  %  global g_p560;
  %  p560 = g_p560;
   p560 = handles.p560;
    sl_jspace
    
    set(handles.text_state,'string',' ');
    drawnow;

end
% --- Executes on button press in checkbox_rrmc.
function checkbox_rrmc_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rrmc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rrmc
if get(handles.checkbox_rrmc,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                                                
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',1);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
                                                      
%     global g_p560;
%     p560 = g_p560;
    p560 = handles.p560;
    sl_rrmc
    
    set(handles.text_state,'string',' ');
    drawnow;
end
% --- Executes on button press in checkbox_rrmc2.
function checkbox_rrmc2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rrmc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rrmc2
if get(handles.checkbox_rrmc2,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                               
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',1);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
     
     p560 = handles.p560;
    sl_rrmc2
    
    set(handles.text_state,'string',' ');
    drawnow;

end


% --- Executes on button press in checkbox_torque.
function checkbox_torque_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_torque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_torque
if get(handles.checkbox_torque,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                                   
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',1);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
                                                      
%     global g_p560;
%     p560 = g_p560;
 p560 = handles.p560;
    p560 = p560.nofriction();
    sl_ctorque
    
    set(handles.text_state,'string',' ');
    drawnow;
    
end


% --- Executes on button press in checkbox_vel.
function checkbox_vel_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vel
if get(hObject,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                               
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',1);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
                                                      
%     global g_p560;
%     p560 = g_p560;
 p560 = handles.p560;
    vloop_test
    
   set(handles.text_state,'string',' ');
    drawnow;
    
end


% --- Executes on button press in checkbox_pos.
function checkbox_pos_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pos
if get(hObject,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                                   
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',1);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',0);
                                                      
%     global g_p560;
%     p560 = g_p560;
 p560 = handles.p560;
    ploop_test
    
   set(handles.text_state,'string',' ');
    drawnow;
    
end


% --- Executes on button press in checkbox_ztorque.
function checkbox_ztorque_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ztorque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ztorque
if get(hObject,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                                   
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',1);
    set(handles.checkbox_ftorque,'value',0);
                                                            
%     global g_p560;
%     p560 = g_p560;
 p560 = handles.p560;
    sl_ztorque
    
   set(handles.text_state,'string',' ');
    drawnow;
    
end


% --- Executes on button press in checkbox_ftorque.
function checkbox_ftorque_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ftorque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ftorque
if get(hObject,'value')
    set(handles.text_state,'string','请稍等');
    drawnow;
                                                   
    set(handles.checkbox_jtraj,'value',0);
    set(handles.checkbox_rrmc,'value',0);
    set(handles.checkbox_rrmc2,'value',0);
    set(handles.checkbox_torque,'value',0);
    set(handles.checkbox_vel,'value',0);
    set(handles.checkbox_pos,'value',0);
    set(handles.checkbox_ztorque,'value',0);
    set(handles.checkbox_ftorque,'value',1);
% 
%     global g_p560;
%     p560 = g_p560;
 p560 = handles.p560;
    sl_fforward
    
   set(handles.text_state,'string',' ');
    drawnow;
    
end
