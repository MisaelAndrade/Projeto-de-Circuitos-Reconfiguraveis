clear all; close all; clc;

N = 101;
No = N - 1; % order

% Retangular
w1 = ones(N, 1);
w1_zero_padded = w1;
w1_zero_padded(10000) = 0;
W1 = fft(w1_zero_padded);
% Equivalent to: W1 = fft(w1, 1000);
plot(linspace(-0.5, 0.5, length(W1)), abs(fftshift(W1)));
title('DTFT of the retangular window');
xlabel('Normalized Linear Frequency (f)')
ylabel('|W_1(f)|')
a = axis();
grid on;

% Hann
w1 = hann(N);
W1 = fft(w1, 10000);
figure;
plot(linspace(-0.5, 0.5, length(W1)), abs(fftshift(W1)));
title('DTFT of the Hann window');
xlabel('Normalized Linear Frequency (f)')
ylabel('|W_1(f)|')
grid on;

% Hamming
w1 = hamming(N);
W1 = fft(w1, 10000);
figure;
plot(linspace(-0.5, 0.5, length(W1)), abs(fftshift(W1)));
title('DTFT of the Hamming window');
xlabel('Normalized Linear Frequency (f)')
ylabel('|W_1(f)|')
grid on;

% Blackman
w1 = blackman(N);
W1 = fft(w1, 10000);
figure;
plot(linspace(-0.5, 0.5, length(W1)), abs(fftshift(W1)));
title('DTFT of the Blackman window');
xlabel('Normalized Linear Frequency (f)')
ylabel('|W_1(f)|')
grid on;
