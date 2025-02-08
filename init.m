clear
clc

% plant
pa.J = 2.2951e-5;
pa.B = 1.1475e-5;
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
pa.Kt = 3*pa.P/4 * pa.phi_m;
pa.Km = pa.P/2*pa.phi_m;

% pa.Kf = 0.2;
% pa.Km = .015;
% pa.Kb = .015;

% current pi controller
pa.wc = 4000;
% currentCtrlPeriod_sec =  1.0 / (pa.CarrFreq * 1000);
pa.Kp_Iq = pa.wc*pa.Lq;
pa.Ki_Iq = pa.R/pa.Lq;
pa.Kp_Id = pa.wc*pa.Ld;
pa.Ki_Id = pa.R/pa.Ld;

% speed pi controller
pa.Kp_v = 0.35;
pa.Ki_v = 140;

% speed adrc controller
pa.wo = 800;
pa.wc = 10;
pa.b0 = 1000;
pa.L1 = 2*pa.wo;
pa.L2 = pa.wo*pa.wo;
pa.kp = 2*pi*pa.wc;

% target
pa.vq_ref = 5.0;
pa.vd_ref = 1.0;
pa.iq_ref = 0.1;
pa.v_ref = 1*2*pi;