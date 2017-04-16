umlaufzeit = 2 * pi / xa(8,1);

phi0 = 0;
counter = 0;
deltaphisum = 0;
while phi0 < 100
        # vorwaerts weg von der aktuellen Apsidenposition
        xa = geodesic_advance(xa, umlaufzeit / 10);

        # naechste apsidenposition suchen
        x = nextapsid(xa, umlaufzeit);

        deltaphi = x(5) - phi0
        deltaphisum += deltaphi;
        phi0 = x(1,5);
        counter++;
        xa = x(1,2:9)';
endwhile

