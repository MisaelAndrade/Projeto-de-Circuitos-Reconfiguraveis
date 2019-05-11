% funcao para decodificar resultados obtidos pela arquitetura de hardware
% do filtro de 2 entradas
% Estima-se o MSE usando a funcao my_filter como modelo de referencia

close all
clc
clear all
N=100; % numero de vetores de teste aleatorios
EW=8; % tamanho do expoente
FW=18; % tamanho da mantissa

sk0 = 0.1;
sz = 0.5;

sk=[];
gk=[];

bin_outfilter=textread('res_filter.txt', '%s');
xul=textread('floatxul.txt', '%f');
xir=textread('floatxir.txt', '%f');


result_hw=zeros(N,1);
result_sw=zeros(N,1);
for i=1:N
   result_hw(i,1)=bin2float(cell2mat(bin_outfilter(i)),EW,FW);  
        
   if (i == 1)
       gk(i) = sk0/(sk0+sz);
       sk(i) = sk0 - (gk(i)*sk0);
   else
       gk(i) = sk(i-1)/(sk(i-1)+sz);
       sk(i) = sk(i-1) - (gk(i)*sk(i-1));
    
   end 
   xf(i) = xul(i) + (gk(i)*(xir(i)-xul(i)));
   result_sw(i) = xf(i);
    
   erro(i) = sum((result_hw(i,:) - result_sw(i,:)).^2); 
end

Resultado_hw = result_hw(1:10,:)
Resultado_hw = result_sw(1:10,:)
MSE = sum(erro)/N
plot(erro)

