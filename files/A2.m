clc
clear
pkg load signal
[X, Fs] = audioread("voices/v3.wav");
L = length(X);

Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

f = f(1:21000);
P1 = P1(1:21000);
figure(1)
plot(f,(P1.^2) /L );
set(gcf,'position',[10,10,1024,720])

title('Power Spectrum for man sound')
xlabel('f (Hz)')
ylabel('Power')

[W, WFs] = audioread("voices/v10.wav");
WL = length(W);

WY = fft(W);
WP2 = abs(WY/WL);
WP1 = WP2(1:WL/2+1);
WP1(2:end-1) = 2*WP1(2:end-1);
Wf = WFs*(0:(WL/2))/WL;

Wf = Wf(1:21000);
WP1 = WP1(1:21000);
figure(2)
plot(Wf,(WP1.^2) /WL );
set(gcf,'position',[1024,720,1024,720])

title('Power Spectrum for woman sound')
xlabel('f (Hz)')
ylabel('Power')