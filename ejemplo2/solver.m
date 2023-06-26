clearvars
close all

file=sprintf('parametros.csv'); %we upload the data
[time,C] = csvimport(file, 'columns', {'Time','Concentration'});

options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);
rng default % For reproducibility
x = ga(@(par) sys_id(par,time,C),5,[],[],[],[],[-0.05;-0.05;-0.001;-0.001;0],[0.001;0.001;0.001;0.001;0],[],options);

%x= fmincon(@(par) sys_id(par,time,C),[0.5;0.5;0.5;0.5;0],[],[],[],[],[-0.5;-0.5;-0.5;-0.5;0],[0.5;0.5;0.5;0.5;0],[]);

%parametros
kl=x(1); a=x(2); k=x(3); O3_x=x(4);
%Condicion inicial
O3_o=x(5);
%definicion de f(x,t)
fvdp = @(t,O3) -k*O3^3+kl*a*(O3_x-O3);
%solucion
[t,y] = ode45(fvdp, time, O3_o);
%plot(t,y,'LineWidth',2)
%hold on
plot(time,C,'r','LineWidth',2)
hold on
%p = polyfit(time,C,4);
%f1 = polyval(p,time);
plot(t,y,'b--','LineWidth',2)
legend('real','estimated')
xlabel('t (s)','Interpreter','Latex','FontSize', 12)
ylabel('$[O_3](t)$','Interpreter','Latex','FontSize', 12)
set(gcf,'color','w');