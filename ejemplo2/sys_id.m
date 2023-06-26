function J=sys_id(par,t,real)
%parametros
kl=par(1); a=par(2); k=par(3); O3_x=par(4);
%Condicion inicial
O3_o=par(5);
%definicion de f(x,t)
fvdp = @(t,O3) -k*O3^3+kl*a*(O3_x-O3);
[t,y] = ode45(fvdp, t, O3_o);
J=sqrt(mean((real - y).^2));
end