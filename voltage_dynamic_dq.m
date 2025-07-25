function voltage_dynamic_dq(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.

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
 
  block.InputPort(1).Dimensions        = [2,1];
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [1];
  block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [2,1];
  
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
block.ContStates.Data = [0;0];
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

vdq = block.InputPort(1).Data;
wr = block.InputPort(2).Data;
idq = block.ContStates.Data;
pa = block.DialogPrm(1).Data;

Ld = pa.Ld;
Lq = pa.Lq;
% Lms = pa.Lms;
% Lls = pa.Lls;
R = pa.R;
P = pa.P;
phi_m = pa.phi_m;
we = P/2 * wr;
% Ls = 3/2 * Lms + Lls;
Ls = pa.Ls;

% simplify model
% A = [-R/Ld 0;
%      0 -R/Lq];
% B = [1/Ld 0;
%      0 1/Lq];
% u = vdq;
% d = [0;0];

% ipmsm
% A = [-R/Ld we*Lq/Ld;
%      -we*Ld/Lq -R/Lq];
% B = [1/Ld 0;
%      0 1/Lq];
% u = vdq;
% d = -we*phi_m/Lq*[0;1];

% spmsm
A = [-R/Ls we;
     -we -R/Ls];
B = 1/Ls;
u = vdq;
d = -we*phi_m/Ls*[0;1];

idq_dot = A * idq + B * u + d;
block.Derivatives.Data = idq_dot;

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

