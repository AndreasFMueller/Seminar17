#
# geodesic.m -- compute geodesics
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

#
# All vectors in this file follow the same convention. The first n components
# describe the position, the next n components are the velocity. For the
# geodesics on a sphere, the vector contains the following components
#
#    [     theta     ]
#    [      phi      ]
#    [ d theta / d s ]
#    [  d phi / d s  ]
#

#
# This programm needs the functions metrik and christoffel to be
# defined, a sample can be found in the file christoffel.m, you
# would usually do this by icluding christoffel.m or your own version
# with your particular from a driver file
#
#source("christoffel.m")

#
# functions to compute position an velocity from a vectory that contains
# both parts
#
function pos = position(x)
	n = size(x)(1)/2;
	pos = x(1:n,1);
endfunction

function vel = velocity(x)
	n = size(x)(1)/2;
	vel = x((n+1):(2*n),1);
endfunction

function y = mrescale(x, s)
	y = x;
	n = size(x)(1)/2;
	y((n+1):(2*n),1) = s * velocity(x);
endfunction

#
# find the length of a vector
#
function l = mlength(x)
	l = sqrt(abs(metrik(position(x), velocity(x), velocity(x))));
	l
endfunction

#
# normalize a vector
#
function y = mnormalize(x)
	y = mrescale(x, 1 / mlength(x));
endfunction

#
# compute the derivative for the geodesic equation
#
function y = dgeodesic(x, s)
	n = size(x)(1)/2;
	y = zeros(2*n, 1);
	p = position(x);
	u = velocity(x);
	y(1:n,1) = u;
	for alpha = 1:n
		Gamma = christoffel(p, alpha);
		y(n+alpha,1) = -u' * Gamma * u;
	endfor
endfunction

#
# compute the geodesic
#
function s = geodesic(x0, s)
	s = cat(2, s', lsode("dgeodesic", x0, s));
endfunction

