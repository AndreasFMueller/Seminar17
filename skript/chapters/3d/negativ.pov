//
// negativ.pov -- Visualisierung des Paralleltransports
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.57;

camera {
	location <4, 2, 1.5>
	look_at <0.0, 0.67, 0>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <5, 8, 10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}

mesh {
#include "pseudosphaere.inc"
	pigment { color rgb<0.8,0.8,1> }
}

#declare griddiameter = 0.003;

#macro kreis(U)
union {
	#declare V = 0;
	#declare Vstep = pi / 100;
	#while (V < 2 * pi - Vstep/2)
		sphere { pseudosphaere(U, V), griddiameter }
		cylinder {
			pseudosphaere(U, V),
			pseudosphaere(U, V + Vstep), griddiameter
		}
		#declare V = V + Vstep;
	#end
	pigment { color rgb<1,1,0> }
}
#end

#declare U = 3.5;
#while (U > 0)
	kreis(U)
	#declare U = U - 0.2;
#end

#macro merdian(V)
union {
	#declare U = 3.5;
	#declare Ustep = 0.01;
	#while (U > Ustep)
		sphere { pseudosphaere(U, V), griddiameter }
		cylinder {
			pseudosphaere(U, V),
			pseudosphaere(U - Ustep, V), griddiameter
		}
		#declare U = U - Ustep;
	#end
	pigment { color rgb<1,1,0> }
}
#end

#declare V = 0;
#declare Vstep = 2 * pi / 15;
#while (V < 2 * pi - Vstep/2)
	merdian(V)
	#declare V = V + Vstep;
#end

#declare curveradius = 0.007;

union {
#include "curve1.inc"
        pigment { color rgb<1,0,0> }
}

union {
#include "curve2.inc"
        pigment { color rgb<1,0,0> }
}

union {
#include "curve3.inc"
        pigment { color rgb<1,0,0> }
}

