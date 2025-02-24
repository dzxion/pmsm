
s = tf('s');
ST0 = slTuner('sl_pmsm',{'C_v','C_i'});

% use tunable parameter
kp_v = realp('kp_v', 1);
ki_v = realp('ki_v', 1);
kp_i = realp('kp_i', 1);
ki_i = realp('ki_i', 1); 
PI_v = tf([kp_v ki_v],[1 0]);
PI_i = tf([kp_i ki_i],[1 0]);
setBlockParam(ST0,'C_v',PI_v);
setBlockParam(ST0,'C_i',PI_i);

showTunable(ST0)

% Design Requirements
T1=ST0.getIOTransfer('v_{ref}','e');% tracking
T2=ST0.getIOTransfer('n_{v}','u'); % roll-off
T3=ST0.getIOTransfer('d','u'); % margins

W1 = 15*((s/(s+0.05))*(5/(s+5)))^2;
W2 = (s/(s+8))*(((1/8^2)*s^2+(2^0.5/8)*s+1)/((1/800^2)*s^2+(2^0.5/800)*s+1));
W3 = 0.8;

% Autopilot Tuning
H0 = blkdiag(W1*T1, W2*T2, W3*T3);
H = hinfstruct(H0); %H is tuned versionof H0
showTunable(H)
ST0.setBlockValue(H);
T = getIOTransfer(ST0,'v_{ref}','v_{fed}');  % transfer Nzc -> Nz
figure
step(T)
