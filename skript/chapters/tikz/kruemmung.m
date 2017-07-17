#
# kruemmung.m -- Kruemmung
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
function retval = c(t)
	retval = zeros(2,1);
	retval(1,1) = t;
	retval(2,1) = sin(t);
endfunction

function retval = cdot(t)
	retval = zeros(2,1);
	retval(1,1) = 1;
	retval(2,1) = cos(t);
endfunction

function retval = e1(t)
	retval = cdot(t);
	retval = retval * (1 / norm(retval));
endfunction

function retval = cddot(t)
	retval = zeros(2,1);
	retval(1,1) = 0;
	retval(2,1) = -sin(t);
endfunction

function retval = kappa(t)
	retval = -sin(t) / (1 + cos(t)^2)^(3/2);
endfunction

function retval = e2(t)
	retval = cddot(t) - (e1(t)' * cddot(t)) * e1(t);
	retval = retval / norm(retval);
endfunction

N = 33;
r = zeros(N,14);

for i = (1:N)
	t = 0.1 * (i-1);
	r(i, 1) = t;
	r(i, 2:3) = c(t)';
	r(i, 4:5) = cdot(t);
	r(i, 6:7) = e1(t);
	r(i, 8:9) = cddot(t);
	r(i, 10:11) = e2(t);
	r(i, 12) = kappa(t);
	r(i, 13:14) = (c(t) - e2(t) / kappa(t))';
end

r


