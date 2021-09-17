function [peak,index] = getPeak (name)
    [X, Fs] = audioread(name);
    L = length(X);
    Y = fft(X);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;

    f = f(1:21000);
    P1 = P1(1:21000);
    [peak, index] = max(P1);
    index = f(index);
endfunction