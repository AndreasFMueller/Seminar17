#
# christoffel-schwarzschild.m -- christoffel symbols for 
#
# This file contains a generic christoffel symbol function which
# can be used by the geodesic.m program to compute geodesics
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

function ds2 = metrik(x, u, v)
	global rg;
	# position
	r = x(2,1)
	theta = x(3,1);

	q = rg / r;
	s = 1 - q;

	g00 = -s;
	g11 = 1/s;
	g22 = r^2;
	g33 = r^2 * sin(theta)^2;

	ds2 = g00 * u(1,1) * v(1,1);
	ds2 = ds2 + g11 * u(2,1) * v(2,1);
	ds2 = ds2 + g22 * u(3,1) * v(3,1);
	ds2 = ds2 + g33 * u(4,1) * v(4,1);
endfunction

#
# The christoffel function computes the value of the
# christoffel-symbol \Gamma^\alpha_{\mu\nu} at position x
# the return value is a nxn matrix with indizes \mu\nu
#
# the example provided gives christoffel symbols for the
# metric on a sphere
#
function Gamma = christoffel(x, alpha)
	global rg;
	n = size(x)(1);
	Gamma = zeros(n,n);

	r = x(2,1);
	theta = x(3,1);

	q = rg / r;
	s = 1 - q;

	switch (alpha)
	case 1
		Gamma(1,2) = (1/s) * q * 1/(2*r);
		Gamma(2,1) = Gamma(1,2);
	case 2
		Gamma(1,1) = s * q * 1/(2*r);
		Gamma(2,2) = -(1/s) * q * 1/(2*r);
		Gamma(3,3) = rg - r;
		Gamma(4,4) = (rg - r) * sin(theta)^2;
	case 3
		Gamma(2,3) = 1/r;
		Gamma(3,2) = Gamma(2,3);
		Gamma(4,4) = -cos(theta) * sin(theta);
	case 4
		Gamma(2,4) = 1/r;
		Gamma(4,2) = Gamma(2,4);
		Gamma(3,4) = cot(theta);
		Gamma(4,3) = Gamma(3,4);
	otherwise
	endswitch
endfunction


