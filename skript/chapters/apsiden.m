#
# apsiden.m -- Hilfsfunktionen zur Berechnung der nächsten Apsidenposition
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

#
# Finde die erste Apsidenposition zwischen den Zustandsvektoren x1 und x2
#
# Diese Funktion ruft sich rekursiv immer wieder auf bis der Apsidenwinkel
# mit einer Genauigkeit < 1e^-6 bestimmt werden konnte
#
function x = apsidbetween(x1, x2)
	phistep = (x2(5) - x1(5));
	# Wenn die Schrittweite klein genug ist, Rekursion terminieren
	# und interpolieren
	if (phistep < 1e-6)
		rdot1 = x1(7);
		rdot2 = x2(7);
		if (rdot1 * rdot2 > 0) 
			printf("Fehler: keine Nullstelle\n");
			return
		endif
		t1 = abs(rdot1);
		t2 = abs(rdot2);
		
		x = (t2 * x1 + t1 * x2) / (t1 + t2);
		return
	endif
	step = (x2(1) - x1(1)) / 10;
	s = step * (0:20);
	solution = geodesic(x1(1,2:9)', s);
	# finde den ersten Vorzeichenwechsel
	rdot1 = solution(1, 7);
	for i = 2:20
		rdot2 = solution(i, 7);
		if (rdot1 * rdot2 < 0)
			x = apsidbetween(solution(i-1,:), solution(i,:));
			return
		endif
	endfor
	printf("keine Nullstelle gefunden\n");
endfunction

#
# Finde die nächste Apsidenposition ausgehend vom Zustand x0
#
function x = nextapsid(x0, sstep)
	s = sstep * (0:1);
	solution = geodesic(x0, s);
	x = apsidbetween(solution(1,:), solution(2,:));
endfunction

#
# Sicherstellen dass die Berechnungsgenauigkeit gut genug ist
# um Apsiden-Winkel mit hoher Genauigkeit zu finden
#
lsode_options("relative tolerance", 1e-10);

