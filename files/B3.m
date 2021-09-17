pkg load communications

[X, Fs] = audioread("Test.wav");





X1 = awgn(X, 35);
output1 = SSA(X1, Fs, .25);
figure(1);
subplot (2, 1, 1)
plot(output1);
title("Noisy Signal - SNR = 35")
subplot (2, 1, 2)
plot(X1);
title("Enhanced Signal")


X2 = awgn(X, 40);
output2 = SSA(X2, Fs, .25);
figure(2);
subplot (2, 1, 1)
plot(output2);
title("Noisy Signal - SNR = 40")
subplot (2, 1, 2)
plot(X2);
title("Enhanced Signal")



X3 = awgn(X, 50);
output3 = SSA(X3, Fs, .25);
figure(3);
subplot (2, 1, 1)
plot(output3);
title("Noisy Signal - SNR = 50")
subplot (2, 1, 2)
plot(X3);
title("Enhanced Signal")



X4 = awgn(X, 30);
output4 = SSA(X4, Fs, .25);
figure(4);
subplot (2, 1, 1)
plot(output4);
title("Noisy Signal - SNR = 30")
subplot (2, 1, 2)
plot(X4);
title("Enhanced Signal")




