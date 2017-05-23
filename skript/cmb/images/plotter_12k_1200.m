load("12kdata_1200.m");

A = CMB_12K_1200;

order = 19;
xmin = 3;
xmax = size(A)(2);
%ymin = 10;
%ymax = 45;

graphics_toolkit("gnuplot")

figure("visible", "off");

for l = xmin:xmax
	A(l) = (l - 1) / (2 * pi) * (l + 1) / (2 * l + 1) * A(l);
endfor

p = polyfit(xmin:xmax, A(xmin:xmax), order);
x = linspace(xmin, xmax, xmax - xmin + 1);
y = polyval(p, x);

set(gca,'xscale','log');

hold on;
grid on;
axis([xmin xmax])
set (0, "defaultlinelinewidth", 2);
plot(xmin:xmax, A(xmin:xmax));
%plot([180, 180], [ymin,ymax], 'r');
set (0, "defaultlinelinewidth", 6);
plot(x,y);
print -depsc2 12k_1200.eps;
