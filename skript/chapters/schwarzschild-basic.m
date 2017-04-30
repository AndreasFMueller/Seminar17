#
# schwarzschild.m - vierdimensionale Rechnung für Geodäten in der
#                   Schwarzschild-Metrik
#
# (c) 2017 Prof Dr Andreas Mueller, Hochschule Rapperswil
#
global rg = 1;

function retval = schwarzschild(x, u, v)
	global rg;
	r = x(2,1);
	theta = x(3,1);
	x = rg / r;
	s = 1 - x;
	g00 = -s;
	g11 = 1/s;
	g22 = r^2;
	g33 = r^2 * sin(theta)^2;
	retval = g00 * u(1,1) * v(1,1);
	retval = retval + g11 * u(2,1) * v(2,1);
	retval = retval + g22 * u(3,1) * v(3,1);
	retval = retval + g33 * u(4,1) * v(4,1);
endfunction

function retval = schwarzschildnormalize(x, u)
	factor = sqrt(abs(schwarzschild(x, u, u)));
	retval = u / factor;
endfunction

function retval = dfdx(x, s)
	global rg;
	retval = zeros(8,1);
	retval(1:4,1) = x(5:8,1);

	r = x(2, 1);
	q = rg / r;
	s = 1 - q;
	theta = x(3,1);

	dott = x(5,1);
	dotr = x(6,1);
	dottheta = x(7,1);
	dotphi = x(8,1);

	retval(5,1) = (1/s) * q * (1/r) * dott * dotr;
	retval(6,1) = s * q * (1/(2*r)) * dott^2 - (1/s) * q * 1/(2*r) * dotr^2 + (rg - r) * dottheta^2 + (rg - r) * sin(theta)^2 * dotphi^2;
	retval(7,1) = (2/r) * dotr * dottheta - cos(theta) * sin(theta) * dotphi^2;
	retval(8,1) = (2/r) * dotr * dotphi + 2 * cot(theta) * dottheta * dotphi;

	retval(5:8,1) = -retval(5:8,1);
endfunction

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

x0

x0(5:8,1) = schwarzschildnormalize(x0(1:4,1), x0(5:8,1))

printf("dfdx\n")
dfdx(x0, 0)

N = 800;

s = 1 * (0:N);

solution = cat(2, s', lsode("dfdx", x0, s));

solution




