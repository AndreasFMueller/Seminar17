#
# rekombination.m
#
# (c) 2017 Prof Dr Andreas Mueller, Hochschule Rapperwil
#
global h = 6.62606957e-34;
global c = 2.99792458e8;
global kB = 1.3807e-23;
global Q  = 2.17896e-17;
global zeta3 = 1.2020569;
global me = 9.10938e-31;
Trec = 3740
Eta = 5.5e-10;

# 16 * pi * zeta3 * (2 * pi)^(3/2)
Eta * (kB * Trec / (me * c^2))^(3/2) * exp(Q / (kB * Trec)) / 3.84

exit

function retval = S(T, eta)
	global zeta3;
	global Q;
	global kB;
	global me;
	global h;
	global c;
	q = ((kB * T) / (me * c^2))^(3/2) * exp(Q / (kB * T));
#	retval = 16 * pi * zeta3 * (2 * pi)^(3/2) * eta * q;
	retval = 3.84 * eta * q;
endfunction

function x = X(T, eta)
	s = S(T, eta);
	x = (-1 + sqrt(1 + 4 * s)) / (2 * s);
endfunction


N = 400;
results = zeros(N, 3);
for i = (1:N)
	z = i * 100;
	results(i, 1) = z;
	t = 2.7 * (1 + z);
	results(i, 2) = t;
	results(i, 3) = X(t, Eta);
	printf("%6.0f  %10.1f   %g\n", results(i,1), results(i,2), results(i,3));
endfor;

results;

