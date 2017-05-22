#
# wald.m
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
global N = 600;
global d = 0.01;

baeume = rand(N,2) * 4 - 2;

function l = strahl(baeume, angle, fid)
	global N;
	global d;
	l = 10;
	v = [ cos(angle),  sin(angle) ];
	n = [ sin(angle), -cos(angle) ];
	L = abs(baeume * n') < d;
	B = baeume(L,:);
	n = size(B)(1);
	if n > 0
		L = B * v';
		B = B(L > 0,:);
		L = L(L > 0,:);
		n = size(B)(1);
		if (n > 0)
			l = min(L);
		end
	end
	p = l * v;
	fprintf(fid, "\\draw[line width=0.1] (0,0)--(%.4f,%.4f);\n", p(1,1), p(1,2));
endfunction

fid = fopen("waldbaeume.tex", "w");

angle = 0;
while angle <= 2 * pi
	strahl(baeume, angle, fid);
	angle = angle + 0.0005;
end

for i = (1:N)
	fprintf(fid, "\\draw[line width=0,fill=white] (%.4f,%.4f) circle[radius=%.4f] {};\n", baeume(i,1), baeume(i,2), d);
end

fclose(fid);

