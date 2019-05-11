clc
clear all
close all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa
% valores de entrada entre 0 e 1.0

floatxul = fopen('floatxul.txt','w');
floatxir = fopen('floatxir.txt','w');


binxul = fopen('xul.txt','w');
binxir = fopen('xir.txt','w');


% rand('seed',160015669); % seed for random number generator
rand('twister',160015669); % seed for random number generator
for i=1:N
    xul(i)=100 + 0.1*randn();
    xir(i)=100 + 0.5*randn();
    
    xulbin=float2bin(EW,FW,xul(i));
    xirbin=float2bin(EW,FW,xir(i));
    
    fprintf(floatxul,'%f\n',xul(i));
    fprintf(floatxir,'%f\n',xir(i));
    
    fprintf(binxul,'%s\n',xulbin);
    fprintf(binxir,'%s\n',xirbin);

end

fclose(floatxul);
fclose(floatxir);

fclose(binxul);
fclose(binxir);
