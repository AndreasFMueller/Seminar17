//
// blackhole.pov -- Visualisierung
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.77;

camera {
	location <4, 2, -1>
	look_at <0, 0.65, 0>
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
	achse(<-1.5,0,   0>, <1.5,0,  0>)
	achse(<   0,0,   0>, <  0,2,  0>)
	achse(<   0,0,-1.5>, <  0,0,1.5>)
	pigment {
		color White
	}
}

cylinder {
	<0,0,0>, <0,1.4,0>, 1
	pigment {
		color rgbf<0.7,0.7,0.9,0.5>
	}
}

#declare R0 = function(r) { 2/3 * pow(r, 3/2) }
#declare rss = function(R, tau) { pow(3/2 * (R - tau), 2/3) }

#declare trackdiameter = 0.01;
#declare a = pi / 3;
#declare r0 = 2;
#declare taumax = R0(r0);
#declare taustep = taumax / 200;
#declare tau = taustep;
union {
	#declare nextpoint = <r0 * cos(a), 0, r0 * sin(a)>;
	sphere { nextpoint, trackdiameter }
	#while (tau < taumax - taustep/2)
		#declare previouspoint = nextpoint;
		#declare rad = rss(taumax, tau);
		#declare nextpoint = <rad * cos(a), tau, rad * sin(a)>;
		sphere { nextpoint, trackdiameter }
		cylinder { previouspoint, nextpoint, trackdiameter }
	#declare tau = tau + taustep;
	#end
	#declare previouspoint = nextpoint;
	#declare nextpoint = <0, taumax, 0>;
	sphere { nextpoint, trackdiameter }
	cylinder { previouspoint, nextpoint, trackdiameter }
	pigment {
		color rgb<0.9,0.3,0.3>
	}
}

#declare conelength = 0.2;

#macro lightcone(r, a, tau)
	#declare apex = <r * cos(a), tau, r * sin(a)>;

	#declare p = 1/sqrt(r) * (1/sqrt(r) - 1);
	#declare p = sqrt(r) * (sqrt(r) - 1);
	#declare plusdirection = <p * cos(a), 1, p * sin(a)>;
	#declare plusdirection = vnormalize(plusdirection);

	#declare n = 1/sqrt(r) * (-1/sqrt(r) - 1);
	#declare n = sqrt(r) * (-sqrt(r) - 1);
	#declare minusdirection = <n * cos(a), 1, n * sin(a)>;
	#declare minusdirection = vnormalize(minusdirection);

	#declare coneaxis = vnormalize(0.5 * (plusdirection + minusdirection));
	#declare coneradius = conelength * sin(acos(vdot(coneaxis, plusdirection)));
	union {
		cone { apex, 0, apex + conelength * coneaxis, coneradius }
		cone { apex, 0, apex - conelength * coneaxis, coneradius }
		pigment {
			color rgbf<0.9,0.8,0.2,0.5>
		}
	}
#end

#declare tau = 0;
#declare taustep = 0.41;
#while (tau < 1.7)
	#declare lightconeradius = rss(taumax, tau);
	lightcone(lightconeradius, a, tau)
	#declare tau = tau + taustep;
#end






