//
// flach.pov -- Visualisierung
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.5;

camera {
	location <4, 2, 2>
	look_at <0.3333, 0.5, 0.3333>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <10, 10, 10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}

#declare achsenkopflaenge = 0.1;
#declare achsendurchmesser = 0.015;

#macro achse(from, to)
#declare dirvector = to - from;
#declare dirvector = achsenkopflaenge * vnormalize(dirvector);
        cylinder {
                from - dirvector,
                to   + dirvector,
                achsendurchmesser
        }
        cone {
                to +     dirvector, 2 * achsendurchmesser,
                to + 2 * dirvector, 0
        }
#end

union {
	achse(<0,0,0>, <1.2,0,0>)
	achse(<0,0,0>, <0,1.2,0>)
	achse(<0,0,0>, <0,0,1.2>)
	pigment {
		color White
	}
}

#declare pfaddurchmesser = 0.020;

union {
	sphere { <1,0,0>, pfaddurchmesser }
	sphere { <0,1,0>, pfaddurchmesser }
	sphere { <0,0,1>, pfaddurchmesser }
	cylinder { <1,0,0>, <0,1,0>, pfaddurchmesser }
	cylinder { <0,1,0>, <0,0,1>, pfaddurchmesser }
	cylinder { <0,0,1>, <1,0,0>, pfaddurchmesser }
	pigment {
		color Yellow
	}
}

intersection {
	plane { <1,1,1>, 1/sqrt(3) }
	plane { <-1,0,0>, 0.25 }
	plane { <0,-1,0>, 0.25 }
	plane { <0,0,-1>, 0.25 }
	pigment {
		color rgbf<0.5,0.8,0.5,0.5>
	}
}

#declare arrowradius = 0.022;
#declare arrowdirection = <-1, 0, 1>;
#declare arrowdirection = <-2/3, -1/3, 1>;

#macro arrow(p)
	sphere { p, 1.5 * arrowradius }
	cylinder { p, p + 0.2 * arrowdirection, arrowradius }
	cone {
		p + 0.2 * arrowdirection, 2 * arrowradius,
		p + 0.3 * arrowdirection, 0
	}
#end

union {
	#declare s = 0;
	#while (s < 1)
		arrow( <1,0,0> + s * <-1,0,1> )
		#declare s = s + 0.2;
	#end
	#declare s = 0;
	#while (s < 1)
		arrow( <0,0,1> + s * <0,1,-1> )
		#declare s = s + 0.2;
	#end
	#declare s = 0;
	#while (s < 1)
		arrow( <0,1,0> + s * <1,-1,0> )
		#declare s = s + 0.2;
	#end
	pigment {
		color rgbf<0.5,0.5,0.8,0>
	}
}
