#
# kugel.m -- compute geodesics using the generic functions
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

source("christoffel.m")
source("geodesic.m")

N = 201;
s = 0.01 * (0:N);

x0 = zeros(4,1);
x0(1,1) = pi / 2;
x0(3,1) = 1;
x0(4,1) = 1;
x0 = mnormalize(x0);
x0
x0 = mrescale(x0, pi);

x0

dgeodesic(x0, 0)

solution = geodesic(x0, s)
