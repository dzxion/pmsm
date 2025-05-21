function Animation(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

% persistent h_x h_xhat;
global h_x h_xhat h_phi;

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [2,1];
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = [2,1];
  block.InputPort(2).DirectFeedthrough = true;

  block.InputPort(3).Dimensions        = [1];
  block.InputPort(3).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 0;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
  % block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
  
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
%   block.NumDworks = 1;
%   block.Dwork(1).Name = 'x0'; 
%   block.Dwork(1).Dimensions      = 1;
%   block.Dwork(1).DatatypeID      = 0;
%   block.Dwork(1).Complexity      = 'Real';
%   block.Dwork(1).UsedAsDiscState = true;

%endfunction

function InitConditions(block)

%% Initialize Dwork
%   block.Dwork(1).Data = block.DialogPrm(1).Data;
% block.ContStates.Data = [0;
%                          0;
%                          0;];

global h_x h_xhat h_phi;

pa = block.DialogPrm(1).Data;
phi = pa.phi_m;
% 创建图形和箭头对象
fig = figure('Name','Real-Time Position Visualization');
ax = axes(fig);
h_x = quiver(ax, 0,0,0,0, 'AutoScale','off', 'MaxHeadSize',0.5); 
hold(ax, 'on');
h_xhat = quiver(ax, 0,0,0,0, 'AutoScale','off', 'MaxHeadSize',0.5); 
hold(ax, 'on');
h_phi = quiver(ax, 0,0,0,0, 'AutoScale','off', 'MaxHeadSize',0.5); 
plot(ax, phi*cos(0:0.01:2*pi), phi*sin(0:0.01:2*pi), '--'); % 参考圆
% axis(ax, [-1.5 1.5 -1.5 1.5]);
grid(ax, 'on');
title(ax, 'Real-Time Vector Tracking');
% arrow = struct('arrow_x', h_x, 'axes', ax);

% % 将图形句柄存储为块用户数据
% block.UserData = struct('figure', fig, 'quiver', h);

  
%endfunction

function Output(block)

global h_x h_xhat h_phi;

% x = block.InputPort(1).Data;
% iab = block.InputPort(2).Data;
pa = block.DialogPrm(1).Data;
phi = pa.phi_m;
% 
% L = pa.Ls;
% theta_hat = atan2(x(2)-L*iab(2),x(1)-L*iab(1));
% 
% block.OutputPort(1).Data = mod(theta_hat, 2*pi);

% 获取当前输入位置
pos = block.InputPort(1).Data;
x = pos(1);
y = pos(2);

pos_hat = block.InputPort(2).Data;
x_hat = pos_hat(1);
y_hat = pos_hat(2);

theta = block.InputPort(3).Data;
ctheta = [cos(theta);sin(theta)];
phi_v = phi*ctheta;

% % 计算速度矢量（导数）
% persistent prev_pos;
% if isempty(prev_pos)
%    prev_pos = [x; y];
% end
% dx = x - prev_pos(1);
% dy = y - prev_pos(2);
% prev_pos = [x; y];
% 
% % 更新箭头图形
% quiver(0, 0, x, y);
% drawnow limitrate;

% 更新箭头属性
% h_x = arrow.arrow_x;
set(h_x, 'UData', x, 'VData', y);  % 箭头终点为(x,y)
set(h_xhat, 'UData', x_hat, 'VData', y_hat);  % 箭头终点为(x,y)
set(h_phi, 'UData', phi_v(1), 'VData', phi_v(2));  % 箭头终点为(x,y)
drawnow limitrate;
  
%endfunction

function Derivative(block)

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

% function SetInputPortSamplingMode(block, idx, fd)
% 
% block.InputPort(idx).SamplingMode = fd;
% block.InputPort(idx).SamplingMode = fd;
% 
% block.OutputPort(1).SamplingMode = fd;
% block.OutputPort(2).SamplingMode = fd;

%endfunction

