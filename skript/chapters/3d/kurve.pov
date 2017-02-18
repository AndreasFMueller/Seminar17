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

#declare imagescale = 0.155;

camera {
	location <-16, 4, 8>
	look_at <0.0, -0.07, 0.3333>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <1, 5, 10> color White }
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
	achse(<-1.1,0,0>, <1.1,0,0>)
	achse(<0,-1.1,0>, <0,1.1,0>)
	achse(<0,0,-0.1>, <0,0,1.1>)
	pigment {
		color White
	}
}

#declare pfaddurchmesser = 0.020;

#macro kurve1(a)
<a, a * a * a, a * a>
#end

#macro kurve2(a)
<a, 0, a * a>
#end

#declare amin = -1;
#declare amax = +1;
#declare astep = (amax - amin) / 100.;

union {
	#declare a = amin;
	#declare nextpoint = kurve1(a);
	sphere { nextpoint, pfaddurchmesser }
	#while (a < amax - astep/2)
		#declare previouspoint = nextpoint;
		#declare a = a + astep;
		#declare nextpoint = kurve1(a);
		sphere { nextpoint, pfaddurchmesser }
		cylinder {
			previouspoint, nextpoint, pfaddurchmesser
		}
	#end
	pigment {
		color Yellow
	}
}

union {
	#declare a = amin;
	#declare nextpoint = kurve2(a);
	sphere { nextpoint, pfaddurchmesser }
	#while (a < amax - astep/2)
		#declare previouspoint = nextpoint;
		#declare a = a + astep;
		#declare nextpoint = kurve2(a);
		sphere { nextpoint, pfaddurchmesser }
		cylinder {
			previouspoint, nextpoint, pfaddurchmesser
		}
	#end
	pigment {
		color Red
	}
}

#declare astep = (amax - amin) / 20.;

union {
	#declare a = amin;
	#while (a < amax + astep/2)
		#if (a = 0) 
			sphere { kurve1(a), pfaddurchmesser/2 }
		#else
			cylinder { kurve1(a), kurve2(a), pfaddurchmesser/2 }
		#end
		#declare a = a + astep;
	#end
	pigment {
		color rgbf<0.5,0.8,0.6,0.5>
	}
}

