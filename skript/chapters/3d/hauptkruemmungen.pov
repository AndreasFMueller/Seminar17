//
// hauptkruemmungen.pov -- Visualisierung
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
        assumed_gamma 1
}

#declare imagescale = 0.15;

camera {
        location <-10, 4, 16>
        look_at <0.0, 0.0, 0.0>
        right 16/9 * x * imagescale
        up y * imagescale
}

light_source { <1, 5, 10> color White }
sky_sphere {
        pigment {
                color <1,1,1>
        }
}

#declare a = 0.7;

#macro flaeche(U, V)
	<U, a * (U*U-V*V), V>
#end

#declare Steps = 100;

#declare Umin = -1;
#declare Umax = +1;
#declare Ustep = (Umax - Umin) / Steps;

#declare Vmin = -1;
#declare Vmax = +1;
#declare Vstep = (Vmax - Vmin) / Steps;

#macro fquad(U, V)
	triangle {
		flaeche(U, V),
		flaeche(U + Ustep, V),
		flaeche(U + Ustep, V + Vstep)
	}
	triangle {
		flaeche(U, V),
		flaeche(U + Ustep, V + Vstep),
		flaeche(U, V + Vstep)
	}
#end

mesh {
#declare U = Umin;
#while (U < Umax - Ustep/2)
	#declare V = Vmin;
	#while (V < Vmax - Vstep/2)
		fquad(U, V)
		#declare V = V + Vstep;
	#end
	#declare U = U + Ustep;
#end
	pigment {
		color rgbf<0.8,0.8,1,0.3>
	}
}

union {
	sphere { <0,0,0>, 0.03 }
	cylinder { <0,0,0>, <0,0.5,0>, 0.02 }
	cone { <0,0.5,0>, 0.04, <0,0.6,0>, 0 }
	cylinder { <0,-2,0>, <0,2,0>, 0.005 }
	pigment {
		color rgb<0,0.8,0.1>
	}
}

#declare ang = 0;

#macro kreis(ang,phi)
	rho * (<cos(ang), 0, sin(ang)> * sin(phi) + <0, 1, 0> * (1 + cos(phi)))
#end

#declare sign = function (x) {select(x,-1,0,1)};

#macro kurven(ang)

#declare Tmin = -2;
#declare Tmax = 2;
#declare Tstep = (Tmax - Tmin) / Steps;

intersection {
	union {
		#declare T = Tmin;
		#while (T < Tmax - Tstep/2)
			sphere { flaeche(T * cos(ang), T * sin(ang)), 0.01 }
			cylinder {
				flaeche(T * cos(ang), T * sin(ang)),
				flaeche((T + Tstep) * cos(ang), (T + Tstep) * sin(ang)),
				0.01
			}
				
			#declare T = T + Tstep;
		#end
	}
	box { <-1,-1,-1>, <1,1,1> }
	pigment {
		color rgb<1,0,0>
	}
}

#declare kappa2 = cos(ang) * cos(ang) - sin(ang) * sin(ang);
#declare kappa = abs(kappa2) * a * 2 * sign(kappa2);
#declare rho = 1/kappa;

#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / Steps;
union {
	sphere { <0,rho,0>, 0.03 }
#declare phi = phimin;
#while (phi < phimax - phistep/2)
	sphere { kreis(ang,phi), 0.01 * 0.8 }
	cylinder { kreis(ang,phi), kreis(ang,phi + phistep), 0.01 * 0.8 }
	#declare phi = phi + phistep;
#end
	pigment {
		color rgb<1,1,0>
	}
}

#end

kurven(0)
kurven(pi/2)
