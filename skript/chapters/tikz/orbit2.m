#
# orbit.m -- numerische Berechnung der Periheldrehung 
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global rg = 1;

source("../christoffel-schwarzschild.m")
source("../geodesic.m")
source("../beispiele.m")

xa = mnormalize(x3);
xa

norbits = 1;

orbitsteps = 2000;

umlaufzeit = 2 * pi / xa(8,1)
sstep = umlaufzeit / orbitsteps

s = sstep * (0:(norbits * orbitsteps));

xa = geodesic_advance(xa, -umlaufzeit / 10)

solution = geodesic(xa, s);

solution;

fid = fopen("orbit2.csv", "w");

fprintf(fid, "%9.9s,%9.9s,%9.9s,%9.9s,%9.9s,%9.9s\n", "s", "t", "r", "phi", "x", "y")
for i = 1:(norbits*orbitsteps + 1)
	r = solution(i, 3);
	phi = solution(i, 5);
	fprintf(fid, "%9.3f,%9.3f,%9.5f,%9.5f", solution(i,1), solution(i,2), r, phi)
	fprintf(fid, ",%9.4f,%9.4f\n", r * cos(phi), r * sin(phi));
endfor

fclose(fid);
