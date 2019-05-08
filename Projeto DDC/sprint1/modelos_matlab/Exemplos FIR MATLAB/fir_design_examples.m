clear all; close all; clc;

% Ideal filter specification:
%    Gain of 1 in the frequency range [0.2, 0.3]
%            0 in the remaining ranges

N = 31;
No = N - 1;
w = ones(N, 1);
h = fir1(No, [0.2 0.3] * 2, w);

stem(0 : N - 1, h)
xlabel('n');
ylabel('h[n]')
title('Impulse response of a bandpass filter designed using the windowing method (with order No = 30)');
grid on

figure;
H = fft(h, 10000);
plot(linspace(-0.5, 0.5, length(H)), abs(fftshift(H)));
a = axis();
axis([0 0.5 a(3) a(4)]);
xlabel('Normalized Linear Frequency (f)')
ylabel('|H(f)|')
title('Frequency response (in magnitude) of a bandpass filter designed using the windowing method (with order No = 30)');
grid on;
hold on;
plot(0.2, 0.5, 'xr', 'markersize', 10)
plot(0.3, 0.5, 'xr', 'markersize', 10)

N = 501;
No = N - 1;
w = ones(N, 1);
h = fir1(No, [0.2 0.3] * 2, w);

figure;
stem(0 : N - 1, h)
xlabel('n');
ylabel('h[n]')
title('Impulse response of a bandpass filter designed using the windowing method (with order No = 500)');
grid on

figure;
H = fft(h, 10000);
plot(linspace(-0.5, 0.5, length(H)), abs(fftshift(H)));
a = axis();
axis([0 0.5 a(3) a(4)]);
xlabel('Normalized Linear Frequency (f)')
ylabel('|H(f)|')
title('Frequency response (in magnitude) of a bandpass filter designed using the windowing method (with order No = 500)');
grid on;

N = 10001;
No = N - 1;
w = ones(N, 1);
h = fir1(No, [0.2 0.3] * 2, w);

figure;
stem(0 : N - 1, h)
xlabel('n');
ylabel('h[n]')
title('Impulse response of a bandpass filter designed using the windowing method (with order No = 10000)');
grid on

figure;
H = fft(h, 10000);
plot(linspace(-0.5, 0.5, length(H)), abs(fftshift(H)));
a = axis();
axis([0 0.5 a(3) a(4)]);
xlabel('Normalized Linear Frequency (f)')
ylabel('|H(f)|')
title('Frequency response (in magnitude) of a bandpass filter designed using the windowing method (with order No = 10000)');
grid on;

N = 501;
No = N - 1;
w = blackman(N);
h = fir1(No, [0.2 0.3] * 2, w);

figure;
stem(0 : N - 1, h)
xlabel('n');
ylabel('h[n]')
title('Impulse response of a bandpass filter designed using the windowing method (with order No = 500); Blackman window');
grid on

figure;
H = fft(h, 10000);
plot(linspace(-0.5, 0.5, length(H)), abs(fftshift(H)));
a = axis();
axis([0 0.5 a(3) a(4)]);
xlabel('Normalized Linear Frequency (f)')
ylabel('|H(f)|')
title('Frequency response (in magnitude) of a bandpass filter designed using the windowing method (with order No = 500); Blackman window');
grid on;
