load("2k900-500.m");

C = CMB_2K;
scalefactor = 1 / 1085;

order = 55;
xmin = 3;
xmax = size(C)(2);
%ymin = 10;
%ymax = 45;

graphics_toolkit("gnuplot")

figure("visible", "off");

for l = xmin:xmax
	C(l) = l * (l + 1) * C(l) / (2 * pi) * scalefactor;
endfor

p = polyfit(xmin:xmax, C(xmin:xmax), order);
x = linspace(xmin, xmax, xmax - xmin + 1);
y = polyval(p, x);

xlabel("l");
ylabel("l(l+1)C_l/2{/Symbol p} -> skaliert");
title("CMB Leistungsspektrum");

hold on;
grid on;
grid minor;

set (0, "defaultlinelinewidth", 2);

start = xmin - 1;
lmax = size(C)(2) - 1;

xline = zeros(size(C)(2));

for k = 1:lmax+1
	xline(k) = 180 / k;	
endfor

plot(xmin:xmax, C(xmin:xmax));
%plot([180, 180], [ymin,ymax], 'r');
set (0, "defaultlinelinewidth", 8);
plot(x,y, ";data best fit ;");

%set(gca, 'xscale', 'log');
%set(gca, 'xtick', [10 50 100 200 300 500 1000 2500]);
%set(gca, 'xticklabel', [10 50 100 200 300 500 1000 2500]);

set(gca, 'xtick', 0:200:xmax);

axis('tight');
axis([xmin 750 0 6600])

print("2k900-500.eps", "-depsc2", "-FScript:12");
