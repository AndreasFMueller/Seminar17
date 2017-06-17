N = 1530;
M = 34;

RGB = zeros(M, N, 3, 'uint8');

m = 0;

for k = 1:floor(N/6)
	for j = 1:M
	RGB(j, k, 3) = m;
	RGB(j, k, 2) = 0;
	RGB(j, k, 1) = 0;
	end
	m = m + 1;
end

m = 0;

for k = floor(N/6):floor(N/3)
	for j = 1:M
	RGB(j, k, 3) = 255;
	RGB(j, k, 2) = m;
	RGB(j, k, 1) = 0;
	end
	m = m + 1;
end

m = 0;

for k = floor(N/3):floor(N/2)
	for j = 1:M
	RGB(j, k, 3) = 255;
	RGB(j, k, 2) = 255;
	RGB(j, k, 1) = m;
	end
	m = m + 1;
end

m = 0;

for k = floor(N/2):floor(2*N/3)
	for j = 1:M
	RGB(j, k, 3) = 255 - m;
	RGB(j, k, 2) = 255;
	RGB(j, k, 1) = 255;
	end
	m = m + 1;
end

m = 0;

for k = floor(2*N/3):floor(5*N/6)
	for j = 1:M
	RGB(j, k, 3) = 0;
	RGB(j, k, 2) = 255 - m;
	RGB(j, k, 1) = 255;
	end
	m = m + 1;
end

m = 0;

for k = floor(5*N/6):N
	for j = 1:M
	RGB(j, k, 3) = 0;
	RGB(j, k, 2) = 0;
	RGB(j, k, 1) = 255 - m;
	end
	m = m + 1;
end

imwrite(RGB, "converter-function-strip.png");

x = linspace(-500, 500, N);

hold on;
grid on;
set (0, "defaultlinelinewidth", 2);
axis([-500 500 0 300]);

plot(x, RGB(1,1:end,2), 'g');
plot(x, RGB(1,1:end,3), 'b');
plot(x, RGB(1,1:end,1), 'r');

print("converter-function.eps", "-depsc2", "-FScript:12");
