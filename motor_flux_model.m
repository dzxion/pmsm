function motor_flux_model(block)
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
 
  block.InputPort(1).Dimensions        = [2,1];% iab
  block.InputPort(1).DirectFeedthrough = true;
  
  block.InputPort(2).Dimensions        = [1];% theta
  block.InputPort(2).DirectFeedthrough = true;
  
  block.OutputPort(1).Dimensions       = [2,1];% flux
  
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
  
%endfunction

function Output(block)

iab = block.InputPort(1).Data;
theta = block.InputPort(2).Data;
pa = block.DialogPrm(1).Data;

L = pa.Ls;
phi = pa.phi_m;

ctheta = [cos(theta);sin(theta)];
x = L*iab+phi*ctheta;

block.OutputPort(1).Data = x;
  
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

