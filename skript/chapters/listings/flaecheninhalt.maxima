load("vect")$
f(x,y) := k1 * x^2 + k2 * y^2;
g(x,y) := [x, y, f(x,y)];

/* Kreuzprodukt ergibt Normalenvektor */
n: express(diff(g(x,y), x) ~ diff(g(x,y), y));

/* Laenge des Normalenvektors */
laenge: sqrt(n.n);

/* Uebergang zu Polarkoordinaten */
laengepolar: subst(r * cos(phi), x, subst(r * sin(phi), y, laenge));

/* Taylorentwicklung des Integranden nach r */
laengetaylor: taylor(r * laengepolar, r, 0, 3);

/* Integration und Vereinfachung */
F: integrate(laengetaylor, r, 0, R);
F: ratsimp(integrate(F, phi, 0, 2 * %pi));

