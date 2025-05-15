function position_dynamic(block)
% Level-2 MATLAB file S-Function.

%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  %% Register number of dialog parameters   
  block.NumDialogPrms = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [1];
  block.InputPort(1).DirectFeedthrough = false;
  
  % block.InputPort(2).Dimensions        = [1];
  % block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [1];
  
  %% Set block sample time to continuous
  block.SampleTimes = [0 0];
  
  %% Setup Dwork
  block.NumContStates = 1;
  
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
block.ContStates.Data = [0];
  
%endfunction

function Output(block)

theta = block.ContStates.Data;

% if theta > pi
%     theta = theta - 2*pi;
%     disp(['大于pi']);
% elseif theta < -pi
%     theta = theta + 2*pi;
%     disp(['小于-pi']);
% else
%     theta = theta;
%     disp(['区间范围内']);
% end

% disp(['theta：', num2str(theta)]);
% disp(['ContStates：', num2str(block.ContStates.Data)]);
% disp(newline);

% block.ContStates.Data = theta;
theta = mod(block.ContStates.Data,2*pi);

block.OutputPort(1).Data = theta;
  
%endfunction

function Derivative(block)

w = block.InputPort(1).Data;
pa = block.DialogPrm(1).Data;
n = pa.P/2;

% c = pa.c;
% TL = c*omega^2;
theta_dot = n*w;
block.Derivatives.Data = theta_dot;

% machanical equation 

%endfunction

function Update(block)

%   block.Dwork(1).Data = block.InputPort(1).Data;
  
%endfunction

