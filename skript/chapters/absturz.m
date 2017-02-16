#
# absturz.m -- Absturz eines Teilchens durch den Ereignis-Horizont
#              in Finkelstein-Koordinaten
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

#
# Koordinaten [ tau; R; dot tau; dot r ]
#
#
global rg = 1;
global c = 1;

function radius = R(r)
	global rg;
	radius = (2/3) * r^(3/2) / sqrt(rg);
endfunction

function radius = r(tau, r)
	global rg;
	global c;
	radius = (3/2 * (r - c * tau))^(2/3) * rg^(1/3);
endfunction

r(0, R(rg))

function der = f(x)
	global rg, global c;
	der = zeros(4, 1);
	der(1) = x(3);
	der(2) = x(4);
	der(3) = (2^(2/3) * rg^(2/3) / (3 * (x(2) - c * x(1)))^(5/3)) * x(3)^2;
	der(4) = 1/(3 * (x(2) - c * x(1))) * (2 * x(3) - x(4)) * x(4);
endfunction

#x0 = [ 0; R(3 * rg); 1; -1 ]
#t = linspace(0, 3.017645, 100);

#x0 = [ 0; R(3 * rg); 1; -0.0001 ]
#t = linspace(0, 6.887, 100);

steps = 1000

x0 = [ 0; R(1.5 * rg); 1; -0.0001 ]
t = linspace(0, 0.89117, steps);

x = lsode("f", x0, t);

X = zeros(steps, 6);
X(:,1) = t;
X(:,2:5) = x;

for i = 1:steps
	X(i, 6) = r(x(i, 1), x(i, 2));
endfor

X
