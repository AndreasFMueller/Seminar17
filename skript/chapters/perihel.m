#
# perihel.m -- numerische Berechnung der Periheldrehung 
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global rg = 1;

source("christoffel-schwarzschild.m")
source("geodesic.m")
source("apsiden.m")
source("beispiele.m")

xa = mnormalize(x3);

xa

umlaufzeit = 2 * pi / xa(8,1);

phi0 = 0;
counter = 0;
deltaphisum = 0;
while phi0 < 100
	# vorwärts weg von der aktuellen Apsidenposition
	xa = geodesic_advance(xa, umlaufzeit / 10);

	# nächste apsidenposition suchen
	x = nextapsid(xa, umlaufzeit);

	deltaphi = x(5) - phi0
	deltaphisum += deltaphi;
	phi0 = x(1,5)
	counter++;
	xa = x(1,2:9)';
endwhile

averagedeltaphi = deltaphisum / counter

printf("Vorrücken der Apside pro halber Umdrehung: %.4f%%\n", 100 * (averagedeltaphi - pi) / pi)
printf("Vorrücken der Apside pro Umdrehung (Winkelsekunden): %.1f\"\n", 360 * 60 * 60 * (averagedeltaphi - pi) / pi)
