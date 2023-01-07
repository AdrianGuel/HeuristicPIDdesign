close all
clearvars
clc
%Performs model estimations imposing a linear time-delayed model, 
%the estimation of the model parameters uses a simple
%generic genetic algorithm
%Guel-Cortez 2022
% 
clearvars
close all
file=sprintf('pwm2.csv'); %we upload the data
[t,u,y] = csvimport(file, 'columns', {'Time (s)','PWM','Pressure'});
% 
% 
%% Initial experimental data
%Model estimations
%% Model 1
tx=t((t>=80)& (t<=131));
yx=y((t>=80)& (t<=131))-2.85;
ux=u((t>=80)& (t<=131));
figure
yyaxis left
plot(tx,ux)
yyaxis right
plot(tx,yx)
% 
options = optimoptions('ga','PlotFcn',"gaplotbestf",'UseParallel', true,'MaxStallGenerations',500,'MaxGenerations',1000);
[x,fval] = ga(@(K) Pestimation(tx,ux,yx,K),4,[],[],[],[],[0;0;0;0],[100;100;100;5],[],options);
% 
[ye,sol]=Pestimation(tx,ux,yx,x);
figure
yyaxis left
 plot(tx,ux,'r')
yyaxis right
 plot(tx,yx,'b')
 hold on
 plot(tx,ye,'k')
 xlim([tx(1),tx(end)])
 
num = sol(1);
den = [1 sol(2) sol(3)];
tau1=sol(4);
sys1 = tf(num,den,'InputDelay',sol(4)); %respuesta

% 
function varargout= Pestimation(t,u,y,K)
    num = K(1);
    den = [1 K(2) K(3)];
    sys = tf(num,den,'InputDelay',K(4));
    ye = lsim(sys,u,t);
    %cost = norm(y - ye,2)^2+0.5*norm(K,2)^2; 
    cost = norm(y - ye,2)^2;%+0.5*norm(K,2)^2; 

    if abs(nargout)==1
        varargout={cost};
    else
        varargout={ye,K};
    end
end
