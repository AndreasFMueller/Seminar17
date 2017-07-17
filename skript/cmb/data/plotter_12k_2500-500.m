load("12k2500-500.m");

C = CMB_12K;
scalefactor = 1 / 6900;

order = 55;
xmin = 3;
xmax = size(C)(2);
%ymin = 10;
%ymax = 45;

plotmax = 2100;

graphics_toolkit("gnuplot")

figure("visible", "off");

for l = xmin:xmax
	C(l) = l * (l + 1) * C(l) / (2 * pi) * scalefactor;
endfor

p = polyfit(xmin:xmax, C(xmin:xmax), order);
x = linspace(xmin, xmax, xmax - xmin + 1);
y = polyval(p, x);

xlabel("Multipole moment l");
ylabel("l(l+1)C_l/2{/Symbol p}, scaled");
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

%set(gca, 'xscale', 'log');
plot(xmin:plotmax, C(xmin:plotmax));
%plot([180, 180], [ymin,ymax], 'r');
set (0, "defaultlinelinewidth", 8);
plot(x(1:plotmax),y(1:plotmax), ";Data best fit ;");

%set(gca, 'xtick', [10 50 100 200 500 1000 2000]);
%set(gca, 'xticklabel', [10 50 100 200 500 1000 2000]);
%set(gca, 'xtick', [10 50 500 1000 1500 2000]);
%set(gca, 'xticklabel', [10 50 500 1000 1500 2000]);

set(gca, 'xtick', 0:200:xmax);

axis('tight');
axis([xmin plotmax 0 6600]);

print("12k2500-500.eps", "-depsc2", "-FScript:12");
