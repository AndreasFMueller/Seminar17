load("vect")$

f(x,y) := k1 * x^2 + k2 * y^2;

g(x,y) := [x, y, f(x,y)];

tangentialvektor: diff(g(R * cos(t), R * sin(t)), t);

t1: sqrt(tangentialvektor.tangentialvektor);
t2: taylor(t1, R, 0, 3);
t2: subst(1, sin(t)^2 + cos(t)^2, t2);

U: integrate(t2, t, 0, 2 * %pi);
U: ratsimp(U);
ratsimp(U^2);

n: express(diff(g(x,y), x) ~ diff(g(x,y), y));

n1: sqrt(n.n);

n2: subst(r * cos(phi), x, subst(r * sin(phi), y, n1));

n3: taylor(r * n2, r, 0, 3);

F: integrate(n3, r, 0, R);

F: ratsimp(integrate(F, phi, 0, 2 * %pi));
F: ratsimp(F);

taylor((4 * %pi * F) / (U * U), R, 0, 3);
