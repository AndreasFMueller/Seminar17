% Shows the Apsidal precession

x3(1,1) = 0;
x3(2,1) = 10;
x3(3,1) = pi/2;
x3(4,1) = 0;
x3(5,1) = 0.5;
x3(6,1) = 0;
x3(7,1) = 0;
x3(8,1) = 0.00868;

xa = mnormalize(x3);
xa

norbits = 1;

orbitsteps = 2000;

umlaufzeit = 2 * pi / xa(8,1)
sstep = umlaufzeit / orbitsteps

s2 = sstep * (0:(norbits * orbitsteps));

xa = geodesic_advance(xa, -umlaufzeit / 10)
 
solution2 = geodesic(xa, s2);
 
solution2;
polarplot(solution2(:,5),solution2(:,3))
 
