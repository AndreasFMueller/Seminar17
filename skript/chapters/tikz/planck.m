#
# planck.m -- compute planck radition law raw data
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global h = 6.62606957e-34;
global c = 2.99792458e8;
global kB = 1.3807e-23;

function retval = U(nu, t)
	global h;
	global c;
	global kB;
	beta = 1 / (kB * t);
	C = 8 * pi * h * nu^3 / c^3;
	retval = C * h * nu / (exp(h * nu * beta) - 1);
endfunction

ntemperatures = 7;

T = zeros(1, ntemperatures);
T(1,1) = 2.73;
for i = (2:ntemperatures)
	T(1,i) = 10 * T(1,i-1);
endfor

nfrequencies = 171;
nu = zeros(nfrequencies,1);
nu(1,1) = 1e2;
for i = (2:nfrequencies)
	nu(i,1) = nu(i-1,1) * 10^(0.1);
endfor

Utable = zeros(nfrequencies, ntemperatures)

for frequency = (1:nfrequencies)
	for temperature = (1:ntemperatures)
		Uvalue = U(nu(frequency,1), T(1,temperature));
		Uvalue = log10(Uvalue);
		if (Uvalue < -300) 
			Uvalue = -300;
		endif
		Utable(frequency, temperature) = Uvalue;
	endfor
endfor

Utable

fid = fopen("planck.csv", "w");
fprintf(fid, "     t,       a,       b,       c,       d,       e,       f,       g\n");
for frequency = (1:nfrequencies)
	fprintf(fid, "%6.3f", 0.1 * log10(nu(frequency,1)));
	for temperature = (1:ntemperatures)
		Uvalue = 0.25 * 0.1 * (Utable(frequency, temperature) + 300);
		Uvalue = Uvalue - 5;
		fprintf(fid, ",%8.3f", Uvalue);
	endfor
	fprintf(fid, "\n");
endfor
fclose(fid);

