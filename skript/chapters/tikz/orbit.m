#
# orbit.m -- numerische Berechnung der Periheldrehung 
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global rg = 1;

source("../christoffel-schwarzschild.m")
source("../geodesic.m")
source("../beispiele.m")

## Orbit für eine Bahn nahe dem schwarzen Loch
#x0 = zeros(8,1);
#
#x0(1,1) = 0;
#x0(2,1) = 20;
#x0(3,1) = pi/2;
#x0(4,1) = 0;
#x0(5,1) = 0.5;
#x0(6,1) = 0;
#x0(7,1) = 0;
#x0(8,1) = 4e-3;
#
## Orbit für eien "normale" Planetenbahn
#x1 = zeros(8,1);
#
#x1(1,1) = 0;
#x1(2,1) = 1e6;
#x1(3,1) = pi/2;
#x1(4,1) = 0;
#x1(5,1) = 0.5;
#x1(6,1) = 0;
#x1(7,1) = 0;
#x1(8,1) = 3.5e-10;
#
## Sehr enger und sehr elliptisher Orbit
#x2 = zeros(8,1);
#
#x2(1,1) = 0;
#x2(2,1) = 4;
#x2(3,1) = pi/2;
#x2(4,1) = 0;
#x2(5,1) = 0.5;
#x2(6,1) = 0;
#x2(7,1) = 0;
#x2(8,1) = 0.0434;
#
## Noch engerer und sehr elliptisher Orbit
#x3 = zeros(8,1);
#
#x3(1,1) = 0;
#x3(2,1) = 10;
#x3(3,1) = pi/2;
#x3(4,1) = 0;
#x3(5,1) = 0.5;
#x3(6,1) = 0;
#x3(7,1) = 0;
#x3(8,1) = 0.00868;
#
## Orbit für eien "normale" Planetenbahn
#x4 = zeros(8,1);
#
#x4(1,1) = 0;
#x4(2,1) = 100;
#x4(3,1) = pi/2;
#x4(4,1) = 0;
#x4(5,1) = 0.5;
#x4(6,1) = 0;
#x4(7,1) = 0;
#x4(8,1) = 0.00019;
#
#source("../beispiele.m")

xa = mnormalize(x4);
xa

norbits = 1;

orbitsteps = 2000;

umlaufzeit = 2 * pi / xa(8,1)
sstep = umlaufzeit / orbitsteps

s = sstep * (0:(norbits * orbitsteps));

xa = geodesic_advance(xa, -umlaufzeit / 10)

solution = geodesic(xa, s);

solution;

fid = fopen("orbit.csv", "w");

fprintf(fid, "%9.9s,%9.9s,%9.9s,%9.9s,%9.9s,%9.9s\n", "s", "t", "r", "phi", "x", "y")
for i = 1:(norbits*orbitsteps + 1)
	r = solution(i, 3);
	phi = solution(i, 5);
	fprintf(fid, "%9.3f,%9.3f,%9.5f,%9.5f", solution(i,1), solution(i,2), r, phi)
	fprintf(fid, ",%9.4f,%9.4f\n", r * cos(phi), r * sin(phi));
endfor

fclose(fid);
