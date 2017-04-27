//
// pringles.pov -- pringles surface 
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.15;

#declare Umax = 1;
#declare griddiameter = 0.004;
#declare curvediameter = 0.008;
#declare N = 2;

#if (kruemmung > 0)
#declare R = 1 / kruemmung;
#declare a = 0;
#end
#if (kruemmung < 0)
#declare a = -kruemmung;
#declare R = 0;
#end


camera {
	location <8, 4, -4>
	look_at <0.0, -0.2, 0.0>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <5, 8, -10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}

#macro f(U, V)
#if (R)
	<R * sin(U / R) * cos(V), -R * (1 - cos(U / R)),  R * sin(U / R) * sin(V)>
#else
	<U * cos(V), a * U * U * sin(N * V), U * sin(V)>
#end
#end

mesh {
	#declare V = 0;
	#declare Vstep = pi / 400;
	#while (V < 2 * pi - Vstep / 2)
		#declare U = 0;
		#declare Ustep = 0.01;
		#while (U < Umax - Ustep/2)
			triangle {
				f(U        , V        ),
				f(U + Ustep, V        ),
				f(U + Ustep, V + Vstep)
			}
			triangle {
				f(U        , V        ),
				f(U + Ustep, V + Vstep)
				f(U        , V + Vstep)
			}
			#declare U = U + Ustep;
		#end
		#declare V = V + Vstep;
	#end
	
	pigment { color rgb<0.8,0.8,1> }
}

#macro kreis(U, c, von, bis, d)
union {
	#declare V = von;
	#declare Vstep = pi / 400;
	#while (V < bis - Vstep/2)
		sphere { f(U, V), d }
		cylinder { f(U, V), f(U, V + Vstep), d }
		#declare V = V + Vstep;
	#end
	sphere { f(U, V), d }
	pigment { color c }
}
#end

#declare U = 0.2;
#while (U <= Umax)
	kreis(U, rgb<1,1,0>, 0, 2 * pi, griddiameter)
	#declare U = U + 0.2;
#end

#macro merdian(V, c, d)
union {
	#declare U = 0;
	#declare Ustep = 0.01;
	#while (U < Umax - Ustep/2)
		sphere { f(U, V), d }
		cylinder { f(U, V), f(U - Ustep, V), d }
		#declare U = U + Ustep;
	#end
	pigment { color c }
}
#end

#declare V = 0;
#declare Vstep = 2 * pi / 20;
#while (V < 2 * pi - Vstep/2)
	merdian(V, rgb<1,1,0>, griddiameter)
	#declare V = V + Vstep;
#end

#declare curveradius = 0.007;

kreis(1, rgb<0,0,1>, -pi / 10, pi / 10, curvediameter)

merdian(       0, rgb<1,0,0>, curvediameter)
merdian(-pi / 10, rgb<1,0,0>, curvediameter)
merdian( pi / 10, rgb<1,0,0>, curvediameter)

#declare a = 0;
#declare R = 0;

kreis(1, rgb<0.6,0.6,1>, -pi / 10, pi / 10, curvediameter * 0.99)

merdian(       0, rgb<1,0.8,0.8>, curvediameter * 0.99)
merdian(-pi / 10, rgb<1,0.8,0.8>, curvediameter * 0.99)
merdian( pi / 10, rgb<1,0.8,0.8>, curvediameter * 0.99)

sphere { <0,0,0>, 0.02
	pigment { color rgb<1,1,0> }
}


