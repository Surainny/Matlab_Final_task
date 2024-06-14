function varargout = fianlwork(varargin)
% FIANLWORK MATLAB code for fianlwork.fig
%      FIANLWORK, by itself, creates a new FIANLWORK or raises the existing
%      singleton*.
%
%      H = FIANLWORK returns the handle to a new FIANLWORK or the handle to
%      the existing singleton*.
%
%      FIANLWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIANLWORK.M with the given input arguments.
%
%      FIANLWORK('Property','Value',...) creates a new FIANLWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fianlwork_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fianlwork_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fianlwork

% Last Modified by GUIDE v2.5 24-Jun-2023 22:23:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fianlwork_OpeningFcn, ...
                   'gui_OutputFcn',  @fianlwork_OutputFcn, ...
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


% --- Executes just before fianlwork is made visible.
function fianlwork_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fianlwork (see VARARGIN)

% Choose default command line output for fianlwork
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fianlwork wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fianlwork_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.listbox2,'string',['均值滤波';'中值滤波';'高斯滤波']);
%使列表框开始就显示第一个菜单的内容而不是显示"列表框"
set(handles.slider2,'value',0.5);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, '选择图像文件');
raw= imread(fullfile(pathname, filename));
axes(handles.axes1);
imshow(raw);
axes(handles.axes2);
imshow(raw);%创建对话框导入图像并展示在两个axes中
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sig=get(handles.popupmenu1,'value');
tar=get(handles.listbox2,'value');
raw=getimage(handles.axes1);
switch sig
    case 1
        switch tar
        case 1
        H = fspecial('average',[3,3]);
        outcome = imfilter(raw,H);
        axes(handles.axes2);
        imshow(outcome);
        case 2
        outcome(:,:,1)=medfilt2(raw(:,:,1),[3 3]);
        outcome(:,:,2)=medfilt2(raw(:,:,2),[3 3]);
        outcome(:,:,3)=medfilt2(raw(:,:,3),[3 3]);
        axes(handles.axes2);
        imshow(outcome);
        case 3
        W = fspecial('gaussian',[3,3],1); 
        outcome(:,:,1)=imfilter(raw(:,:,1), W, 'replicate');
        outcome(:,:,2)=imfilter(raw(:,:,2), W, 'replicate');
        outcome(:,:,3)=imfilter(raw(:,:,3), W, 'replicate');
        axes(handles.axes2);
        imshow(outcome);
        end
    case 2
        switch tar
        case 1
        outcome=rgb2gray(raw);
        axes(handles.axes2);
        imshow(outcome);
        case 2
        mid=rgb2gray(raw);
        outcome=histeq(mid);
        axes(handles.axes2);
        imshow(outcome);
        case 3
        mid=rgb2gray(raw);
        outcome=imadjust(mid);
        axes(handles.axes2);
        imshow(outcome);
        end
    case 3
        switch tar
        case 1
        mid(:,:,1)=medfilt2(raw(:,:,1),[3 3]);
        mid(:,:,2)=medfilt2(raw(:,:,2),[3 3]);
        mid(:,:,3)=medfilt2(raw(:,:,3),[3 3]);
        %高斯滤波，去除噪点
        mid=rgb2gray(mid);
        outcome=imbinarize(mid);
        axes(handles.axes2);
        imshow(outcome);
        case 2
        mid(:,:,1)=medfilt2(raw(:,:,1),[3 3]);
        mid(:,:,2)=medfilt2(raw(:,:,2),[3 3]);
        mid(:,:,3)=medfilt2(raw(:,:,3),[3 3]);
        %高斯滤波，去除噪点
        mid=rgb2gray(mid);
        outcome=edge(mid,'canny');
        axes(handles.axes2);
        imshow(outcome);
        end
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
sig=get(hObject,'value');
switch sig
    case 1
        set(handles.listbox2,'string',['均值滤波';'中值滤波';'高斯滤波']);
    case 2
        set(handles.listbox2,'string',['灰度转换  ';'直方图均衡化';'对比度增强 '])
    case 3
        set(handles.listbox2,'string',['阈值分割';'边缘检测';'    '])
end

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
pic=getimage(handles.axes2);
pic=flip(pic,2);
axes(handles.axes2);
imshow(pic);%左右翻转模块的实现

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
pic=getimage(handles.axes2);
pic=flip(pic,1);
axes(handles.axes2);
imshow(pic);%上下翻转模块的实现

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=get(hObject,'value');
angle=val*360;
sub=getimage(handles.axes1);
outcome=imrotate(sub,angle,'bilinear');
imshow(outcome);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=get(hObject,'value');
if val>0.5
muti=val*4-1;
else
muti=val*2;
end%缩小倍率0~1；放大倍率1~3
sub=getimage(handles.axes1);
outcome=imresize(sub,muti,'bilinear');
save=gca;
xlim=get(save,'xlim');
ylim=get(save,'ylim');
imshow(outcome);
set(save,'xlim',xlim);
set(save,'ylim',ylim);%使x,y轴与图片的比例保持不变，避免出现像素点变化而图片大小没变的情况

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deltax=0;deltay=-10;
T=maketform('affine',[1 0 0;0 1 0;deltax deltay 1]);
sub=getimage(handles.axes2);
outcome=imtransform(sub,T,'XData',[1 size(sub,2)],'YData',[1,size(sub,1)],'FillValue',255);
imshow(outcome);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deltax=-10;deltay=0;
T=maketform('affine',[1 0 0;0 1 0;deltax deltay 1]);
sub=getimage(handles.axes2);
outcome=imtransform(sub,T,'XData',[1 size(sub,2)],'YData',[1,size(sub,1)],'FillValue',255);
imshow(outcome);



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deltax=0;deltay=10;
T=maketform('affine',[1 0 0;0 1 0;deltax deltay 1]);
sub=getimage(handles.axes2);
outcome=imtransform(sub,T,'XData',[1 size(sub,2)],'YData',[1,size(sub,1)],'FillValue',255);
imshow(outcome);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
deltax=10;deltay=0;
T=maketform('affine',[1 0 0;0 1 0;deltax deltay 1]);
sub=getimage(handles.axes2);
outcome=imtransform(sub,T,'XData',[1 size(sub,2)],'YData',[1,size(sub,1)],'FillValue',255);
imshow(outcome);

% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename2, pathname2] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, '选择图像文件');
pic1=getimage(handles.axes1);
pic2= imread(fullfile(pathname2, filename2));
[r1,l1]=size(pic1);
[r2,l2]=size(pic2);
imresize(pic2,[r1 l1]);
outcome=imadd(pic1,pic2,'uint16');
axes(handles.axes2);
imshow(outcome);
