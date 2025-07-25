close all

% plant (radar25)
% pa.J = 2.2951e-5;
% pa.B = 1.1475e-5;
pa.Lms = 300e-6; % gap crossing inductance
pa.Lls = 10e-6;% leakage inductance
pa.Ldelta = 20e-6;
% pa.Ls = 3/2*pa.Lms + pa.Lls;
% % pa.Ld = pa.Ls - 3/2*pa.Ldelta;
% % pa.Lq = pa.Ls + 3/2*pa.Ldelta;
% pa.Lq = 1.3e-3;
% pa.Ld = 1.15e-3;
% pa.phi_m = 0.00469;
% pa.P = 14;% number of pole
% pa.R = 5.2;
% pa.dc = 24;
% pa.CarrFreq = 10;
% pa.Kt = 3*pa.P/4 * pa.phi_m;
% pa.Km = pa.P/2*pa.phi_m;

% plant (m100)
% pa.J = 2.2951e-5;
% pa.B = 1.1475e-5;
% pa.Lms = 300e-6; % gap crossing inductance
% pa.Lls = 10e-6;% leakage inductance
% pa.Ldelta = 20e-6;
% pa.Ls = 3/2*pa.Lms + pa.Lls;
% % pa.Ld = pa.Ls - 3/2*pa.Ldelta;
% % pa.Lq = pa.Ls + 3/2*pa.Ldelta;
% pa.Lq = 19.0e-6;
% pa.Ld = 13.5e-6;
% pa.phi_m = 0.000487;
% pa.P = 14;% number of pole
% pa.R = 0.12;
% pa.dc = 12;
% pa.CarrFreq = 10;
% pa.Kt = 3*pa.P/4 * pa.phi_m;
% pa.Km = pa.P/2*pa.phi_m;
% pa.c = 7.5e-8;

% plant (Bobtsov2015 ijacsp)
pa.J = 60e-6;
pa.B = 0;
pa.Ls = 40.03e-3;
pa.Ld = pa.Ls;
pa.Lq = pa.Ls;
pa.phi_m = 0.2086;% Magnetic flux (Wb)
pa.P = 10;        % number of pole
pa.R = 8.875;

% pa.Kf = 0.2;
% pa.Km = .015;
% pa.Kb = .015;

% current pi controller
pa.wc = 4000;
% currentCtrlPeriod_sec =  1.0 / (pa.CarrFreq * 1000);
pa.Kp_Iq = pa.wc*pa.Lq;
pa.Ki_Iq = 0.8*pa.R/pa.Lq;
pa.Kp_Id = pa.wc*pa.Ld;
pa.Ki_Id = 0.8*pa.R/pa.Ld;

% speed pi controller
pa.Kp_w = 0.05;
pa.Ki_w = 20;

% speed adrc controller
% pa.wo = 800;
% pa.wc = 100;
% pa.b0 = 800000;
pa.wo = 4.37;
pa.wc = 2.66;
pa.b0 = 9210;
pa.L1 = 2*pa.wo;
pa.L2 = pa.wo*pa.wo;
pa.kp = 2*pi*pa.wc;

pa.l1 = pa.kp;
pa.beta1 = pa.L1;
pa.beta2 = pa.L2;

% voltage controller
pa.Ki_v = 500;

% position controller
pa.Kp_p = 1.0;

% % tunable parameter
% pa.Kp_v_tune = 1;
% pa.Ki_v_tune = 1;
% pa.Kp_Iq_tune= 1;
% pa.Ki_Iq_tune = 1;

% observer ortega2011
pa.gamma = 100;

% observer Bobtsov2015 ijacsp
% pa.alpha = 500;
% pa.Gamma = diag([50,20,20,20]);

% observer Bobtsov2015 auto
pa.alpha = 100;
pa.Gamma = diag([0.1,0.1]);

% target
pa.p_vef = 1.0;
pa.vq_ref = 1.0;
pa.vd_ref = 0.0;
pa.iq_ref = 0.1;
pa.v_ref = 1.0;