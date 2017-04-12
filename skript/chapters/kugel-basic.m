#
# kugel-basic.m -- Berechnung von Geodäten auf der Kugeloberfläche
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

function retval = kugelmetrik(x, u, v)
	theta = x(1,1);
	phi = x(2,1);
	g11 = u(1,1) * v(1,1);
	g22 = sin(theta)^2 * u(2,1) * v(2,1);
	retval = g11 + g22;
endfunction

function retval = kugelnormalize(x, u)
	factor = sqrt(kugelmetrik(x, u, u));
	retval = u / factor;
endfunction

function retval = dfdx(x, s)
	retval = zeros(4,1);
	retval(1:2,1) = x(3:4,1);
	theta = x(1,1);

	dottheta = x(3,1);
	dotphi = x(4,1);

	retval(3,1) = 1/2 * sin(2 * theta) * dotphi^2;
	retval(4,1) = -2 * cot(theta) * dottheta * dotphi;
endfunction

N = 201;
s = 0.01 * (0:N);

x0 = zeros(4,1);
x0(1,1) = pi / 2;
x0(3,1) = 1;
x0(4,1) = 1;
x0(3:4,1) = kugelnormalize(x0(1:2,1), x0(3:4,1));
x0(3:4,1) = pi * x0(3:4,1);

x0

dfdx(x0, 0)

solution = cat(2, s', lsode("dfdx", x0, s))
