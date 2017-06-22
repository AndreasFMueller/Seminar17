load("vect")$
f(x,y) := k1 * x^2 + k2 * y^2;
g(x,y) := [x, y, f(x,y)];

/* Laenge des Tangentialvektors */
tangentialvektor: diff(g(R * cos(t), R * sin(t)), t);
laenge: sqrt(tangentialvektor.tangentialvektor);

/* Taylor-Entwicklung der Laenge */
laengetaylor: taylor(laenge, R, 0, 3);

/* ersetze sin(t)^2 + cos(t)^2 = 1 */
laengetaylor: subst(1, sin(t)^2 + cos(t)^2, laengetaylor);

/* Wegintegral ergibt Umfang */
U: ratsimp(integrate(laengetaylor, t, 0, 2 * %pi));
ratsimp(U^2);
