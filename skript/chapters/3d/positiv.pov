//
// positiv.pov -- Visualisierung des Paralleltransports
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.13;

camera {
	location <4, 2, 1.5>
	look_at <0.0, -0.2, 0>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <5, 8, 10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}

#declare griddiameter = 0.001;
#declare R = 0.45;
#declare Umax = 1 / R;
#declare curveradius = 0.0025;
#declare Vdelta = (1 * pi / 15) / sin(Umax);

#macro sphaere(U, V)
	R * <sin(U) * cos(V), cos(U), sin(U) * sin(V)>
#end

#macro kreis(U)
union {
	#declare V = 0;
	#declare Vstep = pi / 100;
	#while (V < 2 * pi - Vstep/2)
		sphere { sphaere(U, V), griddiameter }
		cylinder {
			sphaere(U, V),
			sphaere(U, V + Vstep), griddiameter
		}
		#declare V = V + Vstep;
	#end
	pigment { color rgb<1,1,0> }
}
#end

#macro meridian(V, d, c)
union {
	#declare U = 0;
	#declare Ustep = 0.01;
	#while (U < Umax - Ustep/2)
		sphere { sphaere(U, V), d }
		cylinder {
			sphaere(U, V),
			sphaere(U + Ustep, V), d
		}
		#declare U = U + Ustep;
	#end
	pigment { color c }
}
#end

union {

intersection {
	difference {
		sphere { <0, 0, 0>, R }
		sphere { <0, 0, 0>, R - 0.001 }
	}
	plane { <0,-1,0>, -R * cos(Umax) }
	pigment { color rgbt<0.8,0.8,1,0.7> }
}

#declare U = 0.2;
#while (U < Umax)
	kreis(U)
	#declare U = U + 0.2;
#end

#declare V = 0;
#declare Vstep = 2 * pi / 15;
#while (V < 2 * pi - Vstep/2)
	meridian(V, griddiameter, rgb<1,1,0>)
	#declare V = V + Vstep;
#end


meridian(      0, curveradius, rgb<1,0,0>)
meridian( Vdelta, curveradius, rgb<1,0,0>)
meridian(-Vdelta, curveradius, rgb<1,0,0>)

	rotate<0,0,-60>
}
