#
# wald.m
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
global N = 400;
global d = 0.01;

baeume = rand(N,2) * 4 - 2;

function l = strahl(baeume, angle, fid)
	global N;
	global d;
	l = 10;
	p = [ 0; 0 ];
	v = [ cos(angle),  sin(angle) ];
	n = [ sin(angle), -cos(angle) ];
	for i = (1:N)
		b = baeume(i,:)';
		if abs(n * b) < d
			s = v * b;
			if (s > 0)
				if s < l
					l = s;
					p = l * v';
				end
			end
		end
	end
	if (l < 10)
		fprintf(fid, "\\draw[line width=0.1] (0,0)--(%.4f,%.4f);\n", p(1,1), p(2,1));
	else
		fprintf(fid, "\\draw[line width=0.1] (0,0)--(%.4f,%.4f);\n", l * v(1,1), l * v(1,2));
	end
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

