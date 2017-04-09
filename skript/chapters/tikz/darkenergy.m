#
# darkenergy.m -- simulation of a dark energy dominated universe
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
global Lambda = 1.5;

function retval = adot(a,t)
	global Lambda;
	x = (1-Lambda/3)/a + (Lambda/3) * a^2;
	if (x > 0)
		retval = sqrt(x);
	else
		retval = 0;
	endif
endfunction

function retval = f(x,t)
	retval = adot(x(1),t);
endfunction


function solution = darkenergy(N)
	a0 = ones(1);
	tfuture = (2 / N) * (0:N);
	tpast = 2 * ones(1,N + 1) - tfuture;

	afuture = lsode("f", a0, tfuture);
	apast = lsode("f", a0, tpast);


	for i = 1:N
		if (apast(i,1) < 1e-3)
			apast(i,1) = 0;
		endif
	endfor

	solution = zeros(2 * N + 1, 2);

	solution(N+1:2*N+1, 1) = tfuture;
	solution(N+1:2*N+1, 2) = afuture;

	solution(1:N,1) = -flipud(tpast(1:N));
	solution(1:N,2) =  flipud(apast(2:N+1));
endfunction

N = 200;
s = zeros(2 * N + 1, 10);
Lambda = 0;
solution = darkenergy(N);
s(:,1:2) = solution(:,1:2);

for l = (3:10)
	Lambda = (l - 2) / 2;
	solution = darkenergy(N);
	s(:,l) = solution(:,2);
endfor

s

fid = fopen("darkenergy.csv", "w");
fprintf(fid, "      t,      a,      b,      c,      d,      e,      f,      g,      h,      i\n");

for i = (1:2*N+1)
	fprintf(fid, "%7.4f", s(i,1));
	for j = (2:10)
		fprintf(fid, ",%7.4f", s(i, j));
	endfor
	fprintf(fid, "\n");
endfor
fclose(fid);

