# Orbit für eine Bahn nahe dem schwarzen Loch
x0 = zeros(8,1);

x0(1,1) = 0;
x0(2,1) = 20;
x0(3,1) = pi/2;
x0(4,1) = 0;
x0(5,1) = 0.5;
x0(6,1) = 0;
x0(7,1) = 0;
x0(8,1) = 4e-3;

# Orbit für eien "normale" Planetenbahn
x1 = zeros(8,1);

x1(1,1) = 0;
x1(2,1) = 1e6;
x1(3,1) = pi/2;
x1(4,1) = 0;
x1(5,1) = 0.5;
x1(6,1) = 0;
x1(7,1) = 0;
x1(8,1) = 3.5e-10;

# Sehr enger und sehr elliptisher Orbit
x2 = zeros(8,1);

x2(1,1) = 0;
x2(2,1) = 4;
x2(3,1) = pi/2;
x2(4,1) = 0;
x2(5,1) = 0.5;
x2(6,1) = 0;
x2(7,1) = 0;
x2(8,1) = 0.0434;

# Noch engerer und sehr elliptisher Orbit
x3 = zeros(8,1);

x3(1,1) = 0;
x3(2,1) = 10;
x3(3,1) = pi/2;
x3(4,1) = 0;
x3(5,1) = 0.5;
x3(6,1) = 0;
x3(7,1) = 0;
x3(8,1) = 0.00868;

# Orbit für eien "normale" Planetenbahn
x4 = zeros(8,1);

x4(1,1) = 0;
x4(2,1) = 100;
x4(3,1) = pi/2;
x4(4,1) = 0;
x4(5,1) = 0.5;
x4(6,1) = 0;
x4(7,1) = 0;
x4(8,1) = 0.00019;

