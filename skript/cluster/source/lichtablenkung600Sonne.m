
%% Lichtablenkung an der Sonne

pkg load odepkg

%close all

c = 299792458;         % Lichtgeschwindigkeit
ly = 9460730472580800; % Lichtjahr
xc = 149.6e9;          % Abstand Sonne-Erde ~150e6km
K = 6.67408e-11;       % Gravitationskonstante
Msun = 1.99e30;        % Sonnenmasse

Rsun = 696.342e6;      % Sonnenradius ~700e3km

M = 600*Msun;            % Linsenmasse
deg = atan(Rsun/xc);   % Blickrichtung


diffSy = @(l,x) [x(2);
                 (4*x(2)*x(3)*x(4)*K*M)/(c^2*(x(3)^2+(x(1)-xc)^2)^(3/2))-(2*(x(4)^2-x(2)^2)*(x(1)-xc)*K*M)/(c^2*(x(3)^2+(x(1)-xc)^2)^(3/2));
                 x(4);
                 (4*x(2)*x(4)*(x(1)-xc)*K*M)/(c^2*(x(3)^2+(x(1)-xc)^2)^(3/2))-(2*x(3)*(x(2)^2-x(4)^2)*K*M)/(c^2*(x(3)^2+(x(1)-xc)^2)^(3/2))];


[l,y] = ode23s (diffSy, [0,2*xc], [0, cos(deg), 0, sin(deg)]);

% csv
yy(1,:) = y(:,1);
yy(2,:) = y(:,3);
csvwrite('lichtablenkung600Sonne.csv', yy');

figure
% x-y Plot
plot(y(:,1), y(:,3), y(:,1), y(:,3), '*');

% Winkelaenderung
a = atan( (y(2,3)-y(1,3)) / (y(2,1)-y(1,1) ) );
b = atan( (y(end,3)-y(end-2,3)) / (y(end,1)-y(end-2,1) ) );
(a-b)*180/pi*60*60   % in Bogensekunden