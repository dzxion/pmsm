function voltage_dynamic_ab_rp(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.

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
 
  block.InputPort(1).Dimensions        = [2,1];% vab
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [1];% angular velocity
  block.InputPort(2).DirectFeedthrough = false;

  block.InputPort(3).Dimensions        = [1];% rotor flux angle
  block.InputPort(3).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [2,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 6;
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Register methods
%   block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
%   block.RegBlockMethod('Update',                  @Update); 
  block.RegBlockMethod('Derivatives',             @Derivative);
  
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
block.ContStates.Data = zeros(6,1);
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data(5:6);
  
%endfunction

function Derivative(block)

v = block.InputPort(1).Data;
w = block.InputPort(2).Data;
theta = block.InputPort(3).Data;

z1 = block.ContStates.Data(1:2);
z2 = block.ContStates.Data(3:4);
i = block.ContStates.Data(5:6);
pa = block.DialogPrm(1).Data;

R = pa.R;
np = pa.P/2;
phi_m = pa.phi_m;
L = pa.Ls;
lamda0 = phi_m*[1;0];

J = [0 -1;1 0];
phi = [-np*w*J v-np*w*J*z1 np*w*J*z2-i];
eta = 1/L*[lamda0;1;R];

i_dot = phi*eta + np*w*J*i;

block.Derivatives.Data = [v;i;i_dot];

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

