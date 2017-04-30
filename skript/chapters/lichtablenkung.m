#
# lichtablenkung.m -- Berechnung der Lichtablenkung bei einer Entfernung
#                     von n Gravitationsradien, also r = n r_g
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global R = 1000;


function y = dudphi(x, u)
	y = zeros(2,1);
	y(1,1) = x(2,1);
	y(2,1) = (2/x(1,1)) * x(2,1)^2 + x(1,1) - 0.5;
endfunction

u0 = [ R; 0 ];

phisteps = 100;
phi = ((pi/2) / phisteps) * (0:(phisteps-0));

usolution = cat(2, phi', lsode("dudphi", u0, phi))


phi0 = [
	usolution(phisteps + 1, 1);
	1/usolution(phisteps + 1, 3)
]

rsteps = 1000;
u = usolution(phisteps + 1, 2) + R * (0:rsteps);;

function y = dphidu(x, u)
	y = zeros(2,1);
	y(1,1) = x(2,1);
	y(2,1) = -(2/u) * x(2,1) - (2*u-3)/2 * x(2,1)^3;
endfunction

phisolution = cat(2, u', lsode("dphidu", phi0, u))

angle = (phisolution(phisteps + 1, 2) - pi/2);
angle * 60 * 60 * 180 / pi
