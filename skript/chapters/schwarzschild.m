#
# schwarzschild.m -- compute geodesics for the schwarzschild metric
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
global rg = 1;

source("christoffel-schwarzschild.m")
source("geodesic.m")

N = 800;
s = 1 * (0:N);

x0 = zeros(8,1);

# Kreisbahn 
#x0(1,1) = 0;
#x0(2,1) = 2; 
#x0(3,1) = pi/2;
#x0(4,1) = 0;
#x0(5,1) = 0.5;
#x0(6,1) = 0;
#x0(7,1) = 0;
#x0(8,1) = 0.125;

x0(1,1) = 0;
x0(2,1) = 20;
x0(3,1) = pi/2;
x0(4,1) = 0;
x0(5,1) = 0.5;
x0(6,1) = 0;
x0(7,1) = 0;
x0(8,1) = 0.004;

x0 = mnormalize(x0);

x0

dgeodesic(x0, 0)

solution = geodesic(x0, s)
