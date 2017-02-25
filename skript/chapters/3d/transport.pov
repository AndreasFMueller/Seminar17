//
// transport.pov -- Visualisierung des Paralleltransports
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
	assumed_gamma 1
}

#declare imagescale = 0.288;

camera {
	location <4, 2, 1.5>
	look_at <0.0, 0.175, 0.2>
	right 16/9 * x * imagescale
	up y * imagescale
}

light_source { <5, 8, 10> color White }
sky_sphere {
	pigment {
		color <1,1,1>
	}
}

#declare koordliniendurchmesser = 0.007;
#declare pfaddurchmesser = 0.014;
#declare arrowradius = 0.012;

#macro kugel(theta, phi)
	<sin(theta) * cos(phi), cos(theta), sin(theta) * sin(phi)>
#end

#macro thetasegment(thetafrom, thetato, phi)
	sphere {
		kugel(thetafrom, phi),
		koordliniendurchmesser
	}
	cylinder {
		kugel(thetafrom, phi),
		kugel(thetato, phi),
		koordliniendurchmesser
	}
#end

#macro phisegment(phifrom, phito, theta)
	sphere {
		kugel(theta, phifrom),
		koordliniendurchmesser
	}
	cylinder {
		kugel(theta, phifrom),
		kugel(theta, phito),
		koordliniendurchmesser
	}
#end

#declare phisteps = 30;
#declare phigridsteps = 5;
#declare phimin = 0;
#declare phimax = pi / 2;
#declare phistep = (phimax - phimin) / phisteps;
#declare phigridstep = (phimax - phimin) / phigridsteps;

#macro thetacurve(phi)
	#declare theta = thetamin;
	#while (theta < thetamax - thetastep / 2)
		thetasegment(theta, theta + thetastep, phi)
		#declare theta = theta + thetastep;
	#end
	sphere { kugel(theta, phi), koordliniendurchmesser }
#end

#declare thetasteps = 30;
#declare thetagridsteps = 5;
#declare thetamin = pi / 6;
#declare thetamax = pi / 2;
#declare thetastep = (thetamax - thetamin) / thetasteps;
#declare thetagridstep = (thetamax - thetamin) / thetagridsteps;

#macro phicurve(theta)
	#declare phi = phimin;
	#while (phi < phimax - phistep / 2)
		phisegment(phi, phi + phistep, theta)
		#declare phi = phi + phistep;
	#end
	sphere { kugel(theta, phi), koordliniendurchmesser }
#end

union {
	#declare phi = phimin;
	#while (phi < phimax - phigridstep / 2)
		thetacurve(phi)
		#declare phi = phi + phigridstep;
	#end
	thetacurve(phi)

	#declare theta = thetamin;
	#while (theta < thetamax - thetagridstep / 2)
		phicurve(theta)
		#declare theta = theta + thetagridstep;
	#end
	phicurve(theta)

	pigment {
		color Yellow
	}
}

#macro kugelquad(theta, phi)
	triangle {
		kugel(theta            , phi          ),
		kugel(theta + thetastep, phi          ),
		kugel(theta + thetastep, phi + phistep)
	}
	triangle {
		kugel(theta            , phi          ),
		kugel(theta + thetastep, phi + phistep),
		kugel(theta            , phi + phistep)
	}
#end

union {
	#declare phi = phimin;
	#while (phi < phimax - phistep / 2)
		#declare theta = thetamin;
		#while (theta < thetamax - thetastep / 2)
			kugelquad(theta, phi)
			#declare theta = theta + thetastep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color rgb<0.5,0.5,0.8>
	}
}


#declare rangle = -40;

#declare arrowdirection = <-1, 0, 1>;
#declare arrowdirection = <-2/3, -1/3, 1>;

#macro arrow(p, d)
	union {
		sphere {
			p, 1.5 * arrowradius
		}
		cylinder {
			p, p + (1 - 4 * arrowradius / vlength(d)) * d, arrowradius
		}
		cone {
			p + (1 - 4 * arrowradius / vlength(d)) * d, 2 * arrowradius,
			p + d, 0
		}
	}
#end

#macro farrow(tt)
	arrow(kugel(pi/2, tt), 0.2 * <-sin(tt), 1, cos(tt)>)
#end

#declare tmin =     pi / 12;
#declare tmax = 5 * pi / 12;
#declare tsteps = 100;
#declare tstep = (tmax - tmin) / tsteps;

#macro tsegment(p)
	sphere {
		kugel(pi/2, p), pfaddurchmesser
		rotate <rangle, 0, 0>
	}
	cylinder {
		kugel(pi/2, p),
		kugel(pi/2, p + tstep),
		pfaddurchmesser
		rotate <rangle, 0, 0>
	}
#end

union {
#declare tt = tmin;
#while (tt < tmax - tstep / 2)
	tsegment(tt)
	#declare tt = tt + tstep;
#end
	sphere {
		kugel(pi/2, tmin), 2 * pfaddurchmesser
		rotate <rangle, 0, 0>
	}
	sphere {
		kugel(pi/2, tmax), 2 * pfaddurchmesser
		rotate <rangle, 0, 0>
	}
	pigment {
		color rgb<0.9,0.3,0.3>
	}
} 

#declare tsteps = 5;
#declare tt = tmin;
#declare tstep = (tmax - tmin) / tsteps;
union {
#while (tt < tmax + tstep / 2)
	farrow(tt)
	#declare tt = tt + tstep;
#end
	rotate <rangle,0,0>
	pigment {
		color rgb<0.3,0.9,0.4>
	}
}




