#
# verkleinerung.m -- negative Krümmung wirkt wie eine Verkleinerungslinse
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

source("pseudosphaere.m")
source("geodesic.m")

function solution = pseudocurve(x0, N)
	x0 = mnormalize(x0);

	s = (0:N) * 0.01;

	solution = geodesic(x0, s);

	for i = (1:(N+1))
		u = solution(i,2);
		v = solution(i,3);
		solution(i, 6) = sech(u) * cos(v);
		solution(i, 7) = sech(u) * sin(v);
		solution(i, 8) = u - tanh(u);
	endfor
endfunction

function retval = writecurve(filename, solution)
	N = size(solution)(1);
	fid = fopen(filename, "w");
	i = 1;
	x1 = solution(i, 6:8);
	while (i < N)
		fprintf(fid, "\tsphere { <%.5f, %.5f, %.5f>, curveradius }\n", x1(1), x1(3), x1(2));
		i = i + 1;
		x2 = solution(i, 6:8);
		fprintf(fid, "\tcylinder { <%.5f, %.5f, %.5f>, <%.5f, %.5f, %.5f>, curveradius }\n", x1(1), x1(3), x1(2), x2(1), x2(3), x2(2));
		x1 = x2;
	endwhile
	fprintf(fid, "\tsphere { <%.5f, %.5f, %.5f>, curveradius }\n", x1(1), x1(3), x1(2));
	fclose(fid);
endfunction

x1 = zeros(4,1);
x1(1,1) =  2.7; # u
x1(2,1) =  0; # v
x1(3,1) = -1; # dotu = -1 
x1(4,1) =  0; # dotv = 0

offset = 0.85;

x2 = x1;
x2(3,1) = -1; # dotu = -1 
x2(4,1) =  offset; # dotv = 0

x3 = x1;
x3(3,1) = -1; # dotu = -1 
x3(4,1) =  -offset; # dotv = 0

N = 200;

solution1 = pseudocurve(x1, N)
solution2 = pseudocurve(x2, N)
solution3 = pseudocurve(x3, N)

writecurve("3d/curve1.inc", solution1);
writecurve("3d/curve2.inc", solution2);
writecurve("3d/curve3.inc", solution3);

