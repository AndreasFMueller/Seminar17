//
// eben.pov -- ebenes Universum
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.25;

camera {
	location <4, 2, 1.5>
	look_at <0.0, 0.1, 0>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <5, 8, 10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}


#declare griddiameter = 0.003;

#macro kreisscheibe(U, V)
	<U * cos(V), 0, U * sin(V)>
#end

#macro kreis(U)
union {
	#declare V = 0;
	#declare Vstep = pi / 100;
	#while (V < 2 * pi - Vstep/2)
		sphere { kreisscheibe(U, V), griddiameter }
		cylinder {
			kreisscheibe(U, V),
			kreisscheibe(U, V + Vstep), griddiameter
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
	#while (U < 1 - Ustep/2)
		sphere { kreisscheibe(U, V), d }
		cylinder {
			kreisscheibe(U, V),
			kreisscheibe(U + Ustep, V), d
		}
		#declare U = U + Ustep;
	#end
	sphere { kreisscheibe(1, V), d }
	pigment { color c }
}
#end

union {

intersection {
	plane { <0,1,0>, 0 }
	plane { <0,-1,0>, 0.001 }
	cylinder { <0,-1,0>, <0,1,0>, 1 }
	pigment { color rgb<0.8,0.8,1> }
}

#declare U = 0.2;
#while (U <= 1)
	kreis(U)
	#declare U = U + 0.2;
#end

#declare V = 0;
#declare Vstep = pi / 15;
#while (V < 2 * pi - Vstep/2)
	meridian(V, griddiameter, rgb<1,1,0>)
	#declare V = V + Vstep;
#end

#declare curveradius = 0.007;

meridian(         0, curveradius, rgb<1,0,0>)
meridian( 1 * pi/15, curveradius, rgb<1,0,0>)
meridian(-1 * pi/15, curveradius, rgb<1,0,0>)

	rotate <0,0,-60>
	translate <0,0.65,0>
}
