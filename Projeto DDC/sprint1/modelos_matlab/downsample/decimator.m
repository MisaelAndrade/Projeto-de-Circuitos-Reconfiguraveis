% Modelo de referência para o downsample do DDC
% Misael de Andrade 
% maio de 2019

clc;
clear all;
close all;

N = 2; % escolha do fator de downsample

%Loop de leitura da amostra 
cnt = 0;

while 1
    xbin = '111111111111'; % amostra de 12 bits de entrada
    
    if (cnt == 0) %caso da primeira amostra
        ybin = xbin;
        cnt = cnt + 1;
    elseif (cnt == N) %caso para as demais amostras a cada passo de N
        ybin = xbin;
        cnt = 1; % reinicia contador
    else
        cnt = cnt + 1;
    end
end



