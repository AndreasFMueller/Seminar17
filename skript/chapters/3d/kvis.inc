/*
 * kvis.inc
 *
 * (c) 2017 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#version 3.7;
#include "colors.inc"
global_settings {
        assumed_gamma 1
}

#declare imagescale = 0.27;

camera {
        location <4, 2, 1.5>
        look_at <0.0, -0.2, 0>
        right 16/9 * x * imagescale
        up y * imagescale
}

light_source { <5, 8, -10> color White }
sky_sphere {
        pigment {
                color <1,1,1>
        }
}

#macro f(xx, yy)
	-(k1 * xx * xx + k2 * yy * yy)
#end

#macro g(r, phi)
	<r * cos(phi), f(r * cos(phi), r * sin(phi)), r * sin(phi)>
#end

#declare curveradius = 0.02;

#declare phisteps = 200;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;

#declare rsteps = 100;
#declare rmin = 0.01;
#declare rmax = 1;
#declare rstep = (rmax - rmin) / rsteps;

mesh {
	#declare rr = rmin;
	#while (rr < rmax - rstep/2)
		#declare phi = phimin;
		#while (phi < phimax - phistep / 2)
			triangle {
				g(rr        , phi          ),
				g(rr        , phi + phistep),
				g(rr + rstep, phi + phistep)
			}
			triangle {
				g(rr        , phi          ),
				g(rr + rstep, phi + phistep),
				g(rr + rstep, phi          )
			}
			#declare phi = phi + phistep;
		#end
		#declare rr = rr + rstep;
	#end
	pigment {
		color rgb<0.8,0.8,1>
	}
}

union {
	#declare rr = rmax;
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		sphere { g(rr,phi), curveradius }
		cylinder { g(rr,phi), g(rr,phi + phistep), curveradius }
		#declare phi = phi + phistep;
	#end
	pigment {
		color rgb<1,0,0>
	}
}

sphere { <0,0,0>, 2 * curveradius
	pigment {
		color rgb<1,1,1>
	}
}
