CS = imread("../images/color-strip-full.png");

N = length(CS);

r = zeros(N, 1);
g = zeros(N, 1);
b = zeros(N, 1);

s = zeros(N, 1);

%graphics_toolkit("gnuplot");

%figure("visible", "off");

for k = 1:N
	r(k) = mean(CS(1:end, k, 1));
	g(k) = mean(CS(1:end, k, 2));
	b(k) = mean(CS(1:end, k, 3));
end

x = linspace(-500, 500, N);

hold on;
grid on;
set (0, "defaultlinelinewidth", 2);
axis([-500 500]);

plot(x, g, 'g');
plot(x, b, 'b');
plot(x, r, 'r');

print("rgb-graph.eps", "-depsc2", "-FScript:12");
