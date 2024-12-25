clear
clc

% plant
pa.J = 0.1;
pa.B = 1;
pa.Lms = 300e-6; % gap crossing inductance
pa.Lls = 10e-6;% leakage inductance
pa.Ldelta = 20e-6;
Ls = 3/2*pa.Lms + pa.Lls;
% pa.Ld = Ls - 3/2*pa.Ldelta;
% pa.Lq = Ls + 3/2*pa.Ldelta;
pa.Lq = 2.39e-3;
pa.Ld = 2.10e-3;
pa.phi_m = 0.00469;
pa.P = 14;% number of pole
pa.R = 5.2;
pa.dc = 24;
pa.CarrFreq = 10;

% pa.Kf = 0.2;
% pa.Km = .015;
% pa.Kb = .015;

% controller
pa.wc = 100;
% currentCtrlPeriod_sec =  1.0 / (pa.CarrFreq * 1000);
pa.Kp_Iq = pa.wc*pa.Lq;
pa.Ki_Iq = pa.R/pa.Lq;
pa.Kp_Id = pa.wc*pa.Ld;
pa.Ki_Id = pa.R/pa.Ld;

% pa.Kp_Id = 1;
% pa.Ki_Id = 1;
% 
% pa.Kp_Iq = 1;
% pa.Ki_Iq = 1;

% target
pa.iq_ref = 1;
pa.id_ref = 1;