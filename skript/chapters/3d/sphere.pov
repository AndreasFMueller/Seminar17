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

#declare imagescale = 0.45;

camera {
	location <4, 2, 2>
	look_at <0.3333, 0.51, 0.3333>
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
	#declare astep = pi / 30;
	#declare a = 0;
	#while (a < pi / 2 - astep/2)
		sphere { <cos(a), 0, sin(a)> pfaddurchmesser }
		cylinder {
			<cos(a), 0, sin(a)>,
			<cos(a + astep), 0, sin(a + astep)>,
			pfaddurchmesser
		}
		#declare a = a + astep;
	#end
	sphere { <0,0,1> pfaddurchmesser }
	#declare a = 0;
	#while (a < pi / 2 - astep/2)
		sphere { <0, cos(a), sin(a)> pfaddurchmesser }
		cylinder {
			<0, cos(a), sin(a)>,
			<0, cos(a + astep), sin(a + astep)>,
			pfaddurchmesser
		}
		#declare a = a + astep;
	#end
	#declare a = 0;
	#while (a < pi / 2 - astep/2)
		sphere { <cos(a), sin(a), 0> pfaddurchmesser }
		cylinder {
			<cos(a), sin(a), 0>,
			<cos(a + astep), sin(a + astep), 0>,
			pfaddurchmesser
		}
		#declare a = a + astep;
	#end

	pigment {
		color Yellow
	}
}

intersection {
	sphere { <0, 0, 0>, 1 }
//	plane { <-1,0,0>, 0.25 }
//	plane { <0,-1,0>, 0.25 }
//	plane { <0,0,-1>, 0.25 }
	pigment {
		color rgbf<0.5,0.8,0.5,0.5>
	}
}

#declare arrowradius = 0.022;
#declare arrowdirection = <-1, 0, 1>;
#declare arrowdirection = <-2/3, -1/3, 1>;

#macro arrow(p, d)
	sphere { p, 1.5 * arrowradius }
	cylinder { p, p + 0.2 * d, arrowradius }
	cone {
		p + 0.2 * d, 2 * arrowradius,
		p + 0.3 * d, 0
	}
#end

union {
	#declare s = 0;
	#declare sstep = pi / 10;
	#while (s < pi / 2)
		arrow( <cos(s),0,sin(s)>, <-sin(s), 0, cos(s)> )
		#declare s = s + sstep;
	#end
	#declare s = 0;
	#while (s < pi / 2)
		arrow( <0,sin(s),cos(s)>, <-1,0,0> )
		#declare s = s + sstep / 2;
	#end
	#declare s = 0;
	#while (s < pi / 2 + sstep/2)
		arrow( <sin(s), cos(s), 0>, <-cos(s), sin(s), 0> )
		#declare s = s + sstep;
	#end
	pigment {
		color rgbf<0.5,0.5,0.8,0>
	}
}

intersection {
	sphere { <1,0,0>, 0.24 }
	plane { <1,0,0>, 1.005 }
	plane { <-1,0,0>, -0.995 }
	plane { <0,-1,0>, 0 }
	plane { <0,0,-1>, 0 }
	pigment {
		color rgb<0.9,0.1,0.1>
	}
}
