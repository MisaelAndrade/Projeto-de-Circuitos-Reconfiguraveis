clear all; close all; clc;

% Filtro para sinais adquiridos a uma taxa de 1,2 kHz.
% Banda passante entre 100 Hz e 300 Hz.
% Ripple máximo de 0,01.
% Banda de transição máxima de 10 Hz.
%
% Especificação digital:
% Banda passante de 100/1200 a 300/1200.
% Banda de transição (frequência linear normalizada): 10/1200.
%
% Escolha da janela:
% Ripple: 0,01
% Atenuação mínima na banda de rejeição: 20log10(1/delta)=20log10(1/0,01) = 40dB
% Usaremos janela de Hann
% Cálculo do Comprimento N e da ordem No:
% 3.11pi/M <= 2*pi*10/1200; M >= (1200/(2*10))*3.11
% Usaremos M = 187
% Ordem: No = 2M = 374
% Comprimento: N = 375.

No = 374;
N = No + 1;
w = hann(N);
[h] = fir1(No, [100/1200 300/1200] * 2, w);

H = fft(h, 10000);

figure;
stem(0 : No, h);
xlabel('n');
ylabel('h[n]');
grid on;

figure;
plot(linspace(-600,600, length(H)), abs(fftshift(H)));
xlabel('Frequência (hertz)');
ylabel('|H(f)|')
grid on

figure;
plot(linspace(-600,600, length(H)), unwrap(angle(fftshift(H))));
xlabel('Frequência (hertz)');
ylabel('|H(f)|')
grid on










