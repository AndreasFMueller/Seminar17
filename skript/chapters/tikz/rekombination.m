#
# rekombination.m
#
# (c) 2017 Prof Dr Andreas Mueller, Hochschule Rapperwil
#
global h = 6.62606957e-34;	# Js
global c = 2.99792458e8;	# m/s
global kB = 1.3807e-23;		# J/K
global Q  = 2.17896e-18;	# J
global zeta3 = 1.2020569;	
global me = 9.10938e-31;	# kg
global w = 3.84;
global T0 = 2.725;		# K

Trec = 3740
zrec = 3740 / T0
Eta = 5.35e-10;

w = 16 * pi * zeta3 / ((2 * pi)^(3/2))

Eta * (kB * Trec / (me * c^2))^(3/2) * exp(Q / (kB * Trec)) / w

function [ s, sprime ] = S(T, eta)
	global zeta3;
	global Q;
	global kB;
	global me;
	global h;
	global c;
	global w;
	qe = Q / (kB * T);
	q = ((kB * T) / (me * c^2))^(3/2) * exp(qe);
#	retval = 16 * pi * zeta3 * (2 * pi)^(3/2) * eta * q;
	s = w * eta * q;
	sprime = s * (3/2  - qe) / T;
endfunction

function T = Sinverse(s, eta)
	Tnew = 3000;
	counter = 0;
	do 	
		T = Tnew;
		[s1, sprime] = S(T, eta);
		deltas = s1 - s;
		Tnew = T - deltas / sprime;
		counter += 1;
	until ((abs(T - Tnew) < 0.01) || (counter > 100));
endfunction

Sinverse(2, Eta)

function T = Xinverse(x, eta)
	x
	s = (1-x) / (x^2)
	T = Sinverse(s, eta);
endfunction

T = Xinverse(0.5, Eta)
z = T / T0 - 1
T = Xinverse(0.1, Eta)
z = T / T0
T = Xinverse(0.9, Eta)
z = T / T0 - 1

function x = X(T, eta)
	[s, sprime] = S(T, eta);
	x = (-1 + sqrt(1 + 4 * s)) / (2 * s);
endfunction

N = 200;
results = zeros(N, 3);
for i = (1:N)
	z = i * 10 + 90;
	results(i, 1) = z;
	t = T0 * (1 + z);
	results(i, 2) = t;
	results(i, 3) = X(t, Eta);
	printf("%6.0f  %10.1f   %g\n", results(i,1), results(i,2), results(i,3));
endfor;

fid = fopen("rekombination.csv", "w");
fprintf(fid, "     z,      T,     X\n");
for i = (1:N)
	fprintf(fid, "%6.0f,%7.1f,%6.3f\n", results(i,1), results(i,2), results(i,3));
endfor;

fclose(fid);

results;

