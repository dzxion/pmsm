function nonlinear_observer_Bobtsov2015_ijacsp(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 4;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  block.InputPort(1).Dimensions        = [2,1];% uab
  block.InputPort(1).DirectFeedthrough = false;
 
  block.InputPort(2).Dimensions        = [2,1];% iab
  block.InputPort(2).DirectFeedthrough = false;
  
  block.InputPort(3).Dimensions        = [1];% w
  block.InputPort(3).DirectFeedthrough = false;
%   
  block.InputPort(4).Dimensions        = [2,1];% y
  block.InputPort(4).DirectFeedthrough = true;
  
%   block.InputPort(5).Dimensions        = [3,1];
%   block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [4,1];% [R_hat;L_hat]

  % block.OutputPort(2).Dimensions       = [2,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 16;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
%   block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
  
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

% theta = pi/2;
% ctheta = [cos(theta);sin(theta)];
pa = block.DialogPrm(1).Data;
L = pa.Ls;
R = pa.R;
eta3 = 1/L;
eta4 = R/L;

block.ContStates.Data = [zeros(12,1);1;-1;eta3;eta4];

% block.ContStates.Data = [0;
%                          0];
  
%endfunction

function Output(block)

eta_hat = block.ContStates.Data(13:16);
% para_hat = 1/eta_hat(3)*[eta_hat(4);1];
block.OutputPort(1).Data = eta_hat;
  
%endfunction

function Derivative(block)

pa = block.DialogPrm(1).Data;
v = block.InputPort(1).Data;
i = block.InputPort(2).Data;
w = block.InputPort(3).Data;
y = block.InputPort(4).Data;
z1 = block.ContStates.Data(1:2);
z2 = block.ContStates.Data(3:4);
phi_f_vec = block.ContStates.Data(5:12);
eta_hat = block.ContStates.Data(13:16);
alpha = pa.alpha;
Gamma = pa.Gamma;
np = pa.P/2;

J = [0 -1;1 0];
phi = [-np*w*J v-np*w*J*z1 np*w*J*z2-i];
phi_f = [phi_f_vec(1) phi_f_vec(2) phi_f_vec(3) phi_f_vec(4);
         phi_f_vec(5) phi_f_vec(6) phi_f_vec(7) phi_f_vec(8);];

phif_dot = -alpha*(phi_f+phi);
eta_dot = Gamma*phi_f'*(y-phi_f*eta_hat);

phif_vec_dot = [phif_dot(1,1);
                phif_dot(1,2);
                phif_dot(1,3);
                phif_dot(1,4);
                phif_dot(2,1);
                phif_dot(2,2);
                phif_dot(2,3);
                phif_dot(2,4);];
block.Derivatives.Data = [v;i;phif_vec_dot;eta_dot];

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
% block.OutputPort(3).SamplingMode = fd;

%endfunction

