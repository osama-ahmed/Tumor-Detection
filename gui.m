function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 15-Dec-2015 03:44:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in segmentButton.
function segmentButton_Callback(hObject, eventdata, handles)
% hObject    handle to segmentButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filtered;
global segmented;

filtered=im2double(filtered);
maxValue=max(filtered(:));

if maxValue>.8
    T=maxValue*.7;
   elseif maxValue<.6
        T=.6;
    else
        T=maxValue*.6;
end

segmented=im2bw(filtered,T);

axes(handles.segmentedImage);
imshow(segmented);

% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global segmented;

k=ones(5);
opened=imopen(segmented,k);

axes(handles.openedImage);
imshow(opened);

imwrite(opened,'result.jpg');

[rows,cols]=size(opened);
count=0;
for i=1:rows
    for j=1:cols
        if opened(i,j)==1
            count=count+1;
        end
    end
end

if count>=1
    report='Enchondroma tumor detected';
else
    report='Enchondroma tumor not detected';
end

set(handles.resultText,'String',report);

fid = fopen('report.doc','wt');
fprintf(fid, report);
fclose(fid);

% --- Executes on button press in allStepsButton.
function allStepsButton_Callback(hObject, eventdata, handles)
% hObject    handle to allStepsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filtered;

filtered=im2double(filtered);
maxValue=max(filtered(:));

if maxValue>.8
    T=maxValue*.7;
   elseif maxValue<.6
        T=.6;
    else
        T=maxValue*.6;
end

segmented=im2bw(filtered,T);
        
axes(handles.segmentedImage);
imshow(segmented);

k=ones(5);
opened=imopen(segmented,k);

axes(handles.openedImage);
imshow(opened);

imwrite(opened,'result.jpg');

[rows,cols]=size(opened);
count=0;
for i=1:rows
    for j=1:cols
        if opened(i,j)==1
            count=count+1;
        end
    end
end

if count>=1
    report='Enchondroma tumor detected';
else
    report='Enchondroma tumor not detected';
end

set(handles.resultText,'String',report);

fid = fopen('report.doc','wt');
fprintf(fid, report);
fclose(fid);

% --- Executes on button press in bilateralFilterButton.
function bilateralFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to bilateralFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img;
global filtered;
A = double(img)/255;
B = bilateralFilter(A,3,2,30);
filtered=rgb2gray(B);

axes(handles.filteredImage);
imshow(filtered);

% --- Executes on button press in averageFilterButton.
function averageFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to averageFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gimg;
global filtered;
meanFilter = fspecial('average', [3 3]);   
filtered=imfilter(gimg,meanFilter);
axes(handles.filteredImage);
imshow(filtered);

% --- Executes on button press in selectButton.
function selectButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img;
[file,path]=uigetfile('*','choose orginal image');
file=[path file];

img=imread(file);

axes(handles.orginalImage);
imshow(img);

global gimg;
gimg=rgb2gray(img);

axes(handles.grayImage);
imshow(gimg);
