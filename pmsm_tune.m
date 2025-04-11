
s = tf('s');

% PI tune
% ST0 = slTuner('sl_pmsm',{'C_v','C_i'});
% kp_v = realp('kp_v', 1);
% ki_v = realp('ki_v', 1);
% kp_i = realp('kp_i', 1);
% ki_i = realp('ki_i', 1); 
% PI_v = tf([kp_v ki_v],[1 0]);
% PI_i = tf([kp_i ki_i],[1 0]);
% setBlockParam(ST0,'C_v',PI_v);
% setBlockParam(ST0,'C_i',PI_i);

% ADRC tune
ST0 = slTuner('sl_pmsm',{'Gain_adrc_1','Gain_adrc_2','Gain_adrc_3','Gain_adrc_4','Gain_adrc_5'});
% addPoint(ST0,{'v_{ref}','v_{fed}','p_{fed}'});
% l1 = realp('l1', 1);
% beta1 = realp('beta1', 1);
% beta2 = realp('beta2', 1);

b0 = realp('b0',1);
wo = realp('wo',1);
wc = realp('wc',1);
% kp_i = realp('kp_i', 1);
% ki_i = realp('ki_i', 1);
% ADRC_C1 = tf(l1*[1 beta1 beta2],[beta1*l1+beta2 beta2*l1]);
% ADRC_C1 = l1*(s^2+beta1*s+beta2)/((beta1*l1+beta2)*s+beta2*l1);
% ADRC_C = tf([beta1*l1+beta2 beta2*l1],b0*[1 beta1+l1 0]);
% PI_i = tf([kp_i ki_i],[1 0]);
% setBlockParam(ST0,'C1',ADRC_C1);
% setBlockParam(ST0,'C',ADRC_C);

l1 = 2*pi*wc;
beta1 = 2*wo;
beta2 = wo*wo;

setBlockParam(ST0,'Gain_adrc_1',l1);
setBlockParam(ST0,'Gain_adrc_2',1/b0);
setBlockParam(ST0,'Gain_adrc_3',b0);
setBlockParam(ST0,'Gain_adrc_4',beta1);
setBlockParam(ST0,'Gain_adrc_5',beta2);
% setBlockParam(ST0,'C_i',PI_i);

showTunable(ST0)

% hinfstruct
% % T1=ST0.getIOTransfer('v_{ref}','e');% tracking
% % T2=ST0.getIOTransfer('n_{v}','u'); % roll-off
% % T3=ST0.getIOTransfer('d','u'); % margins
% 
% T=getIOTransfer(ST0,'v_{ref}','v_{fed}');% tracking
% 
% % W1 = 15*((s/(s+0.05))*(5/(s+5)))^2;
% % W2 = (s/(s+8))*(((1/8^2)*s^2+(2^0.5/8)*s+1)/((1/800^2)*s^2+(2^0.5/800)*s+1));
% % W3 = 0.8;
% W = makeweight(1,[40 3.16],100);
% W_tf = tf(W)
% 
% H0 = W_tf*T;
% H = hinfstruct(H0)%H is tuned versionof H0
% showTunable(H) 
% ST0.setBlockValue(H);
% T = getIOTransfer(ST0,'v_{ref}','v_{fed}');  % transfer Nzc -> Nz
% figure
% bode(T)
% figure
% step(T)

% systune
TrackReq = TuningGoal.StepTracking('v_{ref}','v_{fed}',0.5);
ST1 = systune(ST0,TrackReq)
showTunable(ST1)
% T0 = getIOTransfer(ST0,'v_{ref}','v_{fed}');
T1 = getIOTransfer(ST1,'v_{ref}','v_{fed}');
figure
step(T1)
figure
bode(T1)

