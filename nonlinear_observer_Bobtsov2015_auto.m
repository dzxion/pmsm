function nonlinear_observer_Bobtsov2015_auto(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.S

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  block.InputPort(1).Dimensions        = [2,1];% uab
  block.InputPort(1).DirectFeedthrough = false;
 
  block.InputPort(2).Dimensions        = [2,1];% iab
  block.InputPort(2).DirectFeedthrough = false;
  
%   block.InputPort(3).Dimensions        = [3,1];% v
%   block.InputPort(3).DirectFeedthrough = true;
%   
%   block.InputPort(4).Dimensions        = [3,3];% R
%   block.InputPort(4).DirectFeedthrough = true;
  
%   block.InputPort(5).Dimensions        = [3,1];
%   block.InputPort(5).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [1];% theta

  % block.OutputPort(2).Dimensions       = [2,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 9;
  
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
% pa = block.DialogPrm(1).Data;
% phi = pa.phi_m;
% x = phi*ctheta;
block.ContStates.Data = zeros(9,1);

% block.ContStates.Data = [0;
%                          0];
  
%endfunction

function Output(block)

pa = block.DialogPrm(1).Data;
R = pa.R;
L = pa.Ls;
np = pa.P/2;
Xi = block.ContStates.Data;
i = block.InputPort(2).Data;
q = Xi(1:2)-R*Xi(3:4)-L*i;
theta_hat = 1/np * atan2(q2+Xi(9),q1+Xi(8));
block.OutputPort(1).Data = theta_hat;
  
%endfunction

function Derivative(block)

pa = block.DialogPrm(1).Data;
u = block.InputPort(1).Data;
i = block.InputPort(2).Data;
Xi = block.ContStates.Data;
alpha = pa.alpha;
L = pa.Ls;
R = pa.R;

Xi_dot = zeros(9,1);
Xi_dot(1:4) = [u;i];
q = Xi(1:2)-R*Xi(3:4)-L*i;
Xi_dot(5) = -alpha*(Xi(5)+q'*q);
Xi_dot(6:7) = -alpha*(Xi(6:7)-2*q);
y = -alpha*(q'*q+Xi(5));
Omega = alpha*(2*q-Xi(6:7));
Xi_dot(8:9) = Gamma*Omega*(y-Omega'*Xi(8:9));
block.Derivatives.Data = Xi_dot;

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

