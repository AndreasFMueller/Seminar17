#
# christoffel-schwarzschild3.m -- christoffel symbols for Schwarzschild
#                                 metrik in polar coordinates
#
# This file contains a christoffel symbol function which can be used
# by the geodesic.m program to compute geodesics of the Schwarzschild
# metric in polar coordinates
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

function ds2 = metrik(x, u, v)
	global rg;
	# position
	r = x(2,1)

	q = rg / r;
	s = 1 - q;

	g00 = -s;
	g11 = 1/s;
	g22 = r^2;

	ds2 = g00 * u(1,1) * v(1,1);
	ds2 = ds2 + g11 * u(2,1) * v(2,1);
	ds2 = ds2 + g22 * u(3,1) * v(3,1);
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
	case 3
		Gamma(2,3) = 1/r;
		Gamma(3,2) = Gamma(2,3);
	otherwise
	endswitch
endfunction


