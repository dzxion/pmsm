function nonlinear_observer(block)
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
  
  block.OutputPort(1).Dimensions       = [2,1];

  % block.OutputPort(2).Dimensions       = [2,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 2;
  
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
block.ContStates.Data = [0;
                         0];
  
%endfunction

function Output(block)

x_hat = block.ContStates.Data;
block.OutputPort(1).Data = x_hat;
  
%endfunction

function Derivative(block)

pa = block.DialogPrm(1).Data;
uab = block.InputPort(1).Data;
iab = block.InputPort(2).Data;
x_hat = block.ContStates.Data;
gamma = pa.gamma;
phi = pa.phi_m;
L = pa.Ls;
Rs = pa.R;

y12 = -Rs*iab+uab;
x_hat_dot = y12 + gamma/2*(x_hat-L*iab)*(phi^2-(x_hat-L*iab)'*(x_hat-L*iab));
block.Derivatives.Data = x_hat_dot;

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

