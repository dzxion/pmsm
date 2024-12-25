function voltage_equation_abc(block)
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
 
  block.InputPort(1).Dimensions        = [3,1];
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [2,1];
  block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [3,1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 3;
  
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
block.ContStates.Data = [0;0;0];
  
%endfunction

function Output(block)

block.OutputPort(1).Data = block.ContStates.Data;
  
%endfunction

function Derivative(block)

vabc = block.InputPort(1).Data;
theta_r = block.InputPort(2).Data(1);
wr = block.InputPort(2).Data(2);
x = block.ContStates.Data;
pa = block.DialogPrm(1).Data;
R = pa.R;
P = pa.P;
Lms = pa.Lms;
Lls = pa.Lls;
Ldelta = pa.Ldelta;
phi_m = pa.phi_m;
we = P/2 * wr;
theta_e = P/2 * theta_r;

Labc = [Lms+Lls -1/2*Lms -1/2*Lms;
        -1/2*Lms Lms+Lls -1/2*Lms;
        -1/2*Lms -1/2*Lms Lms+Lls];

% spmsm代数法求电感逆矩阵
% gamma = 2*Lls/Lms;
% Labc_inv = 2/(Lms*((2+gamma)^3-3*(2+gamma)-2))*[(2+gamma)^2-1 3+gamma 3+gamma;
%                                                  3+gamma (2+gamma)^2-1 3+gamma;
%                                                  3+gamma 3+gamma (2+gamma)^2-1];

% spmsm直接求电感逆矩阵
% Labc_inv = inv(Labc);

% ipmsm电感矩阵
Lrlc = [cos(2*theta_e) cos(2*theta_e-2*pi/3) cos(2*theta_e+2*pi/3);
        cos(2*theta_e-2*pi/3) cos(2*theta_e+2*pi/3) cos(2*theta_e);
        cos(2*theta_e+2*pi/3) cos(2*theta_e) cos(2*theta_e-2*pi/3)];
Labcs = Labc - Ldelta*Lrlc;
Labc_inv = inv(Labcs);

A = -R*Labc_inv;
B = Labc_inv;
u = vabc;
d = we*phi_m*Labc_inv*[sin(theta_e);sin(theta_e-2*pi/3);sin(theta_e+2*pi/3)];

x_dot = A * x + B * u + d;
block.Derivatives.Data = x_dot;

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

