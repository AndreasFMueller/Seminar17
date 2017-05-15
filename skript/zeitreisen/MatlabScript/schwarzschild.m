% 
%  schwarzschild.m -- compute geodesics for the schwarzschild metric
% 
%  (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
% 
%  Adaptet in Matlab by Sascha Jecklin, Hochschule Rapperswil

% Eventhorizion rg
global rg;
rg=1;

%Steps
N = 2000;
%Time parameter
s = 1 * (0:0.5:N);

%  Kreisbahn 
% x0(1,1) = 0;
% x0(2,1) = 2; 
% x0(3,1) = pi/2;
% x0(4,1) = 0;
% x0(5,1) = 0.5;
% x0(6,1) = 0;
% x0(7,1) = 0;
% x0(8,1) = 0.125;

% Orbit for Planet like course
% x4(1,1) = 0;
% x4(2,1) = 100;
% x4(3,1) = pi/2;
% x4(4,1) = 0;
% x4(5,1) = 0.5;
% x4(6,1) = 0;
% x4(7,1) = 0;
% x4(8,1) = 0.00019;

% elliptical orbit
% x3(1,1) = 0;
% x3(2,1) = 10;
% x3(3,1) = pi/2;
% x3(4,1) = 0;
% x3(5,1) = 0.5;
% x3(6,1) = 0;
% x3(7,1) = 0;
% x3(8,1) = 0.00868;

% default initial conditions
x0 = zeros(8,1);
x0(1,1) = 0;      %time
x0(2,1) = 20;       %start distance
x0(3,1) = pi/2;     %theta
x0(4,1) = 0;        %start phi
x0(5,1) = 0.5;      %derived time
x0(6,1) = 0;        %radial velocity
x0(7,1) = 0;        %derived theta
x0(8,1) = 0.0004;   %angualr velocity

x0 = mnormalize(x0);
x0
dgeodesic(0, x0) 
solution = geodesic(x0, s)
myui(solution, x0,s)




 
 


