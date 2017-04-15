#
# lichtablenkung.m -- Berechnung der Lichtablenkung bei einer Entfernung
#                     von n Gravitationsradien, also r = n r_g
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#

global R = 10;
function y = dudphi(x, u)
	y = zeros(2,1);
	y(1,1) = x(2,1);
	y(2,1) = (2/x(1,1)) * x(2,1)^2 + x(1,1) - 0.5;
endfunction

u0 = [ R; 0 ];

phisteps = 300;
phi = ((pi/2) / phisteps) * (0:(phisteps-0));

usolution = cat(2, phi', lsode("dudphi", u0, phi))

fid = fopen("lichtablenkung.csv", "w");
fprintf(fid, "      phi,        r\n");
for i = 1:(phisteps + 1)
	fprintf(fid, "%10.4f,%10.4f\n", usolution(i, 1), usolution(i, 2) / R);
endfor

fclose(fid);

