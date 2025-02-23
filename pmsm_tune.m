
ST0 = slTuner('sl_pmsm',{'C_v','C_i'});

% Design Requirements
T1=ST0.getIOTransfer('v_{ref}','e');% tracking
% T2=ST0.getIOTransfer('n_{v}','u'); % roll-off
% T3=ST0.getIOTransfer('d','u'); % margins
% W1 = 15*((s/(s+0.05))*(5/(s+5)))^2;
% W2 = (s/(s+8))*(((1/8^2)*s^2+(2^0.5/8)*s+1)/((1/800^2)*s^2+(2^0.5/800)*s+1));
% W3 = 0.8;