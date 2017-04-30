#
# christoffel.m -- generic christoffel function
#
# This file contains a generic christoffel symbol function which
# can be used by the geodesic.m program to compute geodesics
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

function ds2 = metrik(x, u, v)
	# compute the scalar product of the two vectors at position x
	# as an example, take the metric on the sphere
	theta = x(1,1);
	ds2 = u(1,1) * v(1,1) + sin(theta)^2 * u(2,1) * v(2,1);
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
	theta = x(1,1);
	n = size(x)(1);
	Gamma = zeros(n,n);
	switch (alpha)
	case 1
		Gamma(2,2) = -sin(2 * theta) / 2;
	case 2
		Gamma(1,2) = cot(theta);
		Gamma(2,1) = cot(theta);
	otherwise
	endswitch
endfunction


