//
// kugel.pov -- Textur auf Kugeloberfläche
//
// (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
//
#version 3.7;
#include "colors.inc"
global_settings {
        assumed_gamma 1
}

#declare imagescale = 0.08;

camera {
        location <16, 8, 6>
        look_at <0, 0.30, 0>
        right 16/9 * x * imagescale
        up y * imagescale
}

light_source {
	<15, 5, -1> color 1.5 * White
	shadowless
}
sky_sphere {
        pigment {
                color <0,0,1>
        }
}

#declare rad = function(d) { d * pi / 180 }

#declare gridradius = 0.004;

#macro kugel(theta, phi) 
	<sin(theta) * cos(phi), cos(theta), sin(theta) * sin(phi)>
#end

#macro breitenkreis(theta, von, bis)
	#declare phi = von;
	#declare phistep = (bis - von) / 100;
	#while (phi < bis - phistep/2)
		sphere { kugel(theta, phi), gridradius }
		cylinder {
			kugel(theta, phi),
			kugel(theta, phi + phistep),
			gridradius
		}
		#declare phi = phi + phistep;
	#end
	sphere { kugel(theta, phi), gridradius }
#end

#macro meridian(phi)
	#declare theta = 0;
	#declare thetastep = pi / 100;
	#while (theta < pi - thetastep/2)
		sphere { kugel(theta, phi), gridradius }
		cylinder {
			kugel(theta, phi),
			kugel(theta + thetastep, phi),
			gridradius
		}
		#declare theta = theta + thetastep;
	#end
#end

#macro grid(von, bis)
union {
#declare thetastep = pi / 12;
#declare theta = thetastep;
#while (theta < pi - thetastep/2)
	breitenkreis(theta, von, bis)
	#declare theta = theta + thetastep;
#end
#declare phi = von;
#declare phistep = pi / 12;
#while (phi < bis - phistep / 2)
	meridian(phi)
	#declare phi = phi + phistep;
#end
	pigment { color rgb<0.9,0.9,0.9> }
}
#end

#macro sector(a, b)
intersection {
	plane { <1,0,0>, 0 }
	plane { <1,0,0>, 0
		rotate<0,a,0>
	}
	pigment { color rgb<0.8,0.8,1> }
	rotate <0,b,0>
}
#end

grid(rad(70), rad(290))
//difference {
//	grid()
//	sector(40,160)
//	pigment {
//		color rgb<0.8,0.8,1>
//	}
//}

difference {
	difference {
		sphere {
			<0,0,0>, 1
			pigment {
			//	image_map {
			//		jpeg "planck.jpg"
			//		map_type 1
			//	}
				color rgb<0.8,0.8,1>
			}
			//finish { ambient 0.3 }
			rotate <0,180,0>
		}
		sphere {
			<0,0,0>, 0.999
			pigment {
				image_map {
					jpeg "planck.jpg"
					map_type 1
				}
			}
			//finish { ambient 0.3 }
			//rotate <0,180,0>
		}
	}
	sector(40,160)
//	box { <0,-1,0>, <1,1,1>
//		rotate <0,45,0>
//	}
}

sphere {
	<0,0,0>, 0.15
	pigment {
		//color rgb<0.5,0.5,1>
		image_map {
			jpeg "tc-earth_daymap.jpg"
			map_type 1
		}
	}
//	finish { ambient 0.7 }
	rotate <0,-200,0>
	rotate <0,0,-23>
}

#declare theta0 = 0.32 * pi;
#declare theta1 = theta0 + 0.02 * pi;
#declare phi0 = 0.48 * pi;
#declare phi1 = phi0 - 0.02 * pi;

intersection {
	sphere {
		<0,0,0>, 1.1
		pigment {
			color rgb<0.6,0.0,0.0>
		}
	}
	union {
		union {
			cylinder { <0,0,0>, 1.1 * kugel(theta0, phi0), 0.005 }
			cylinder { <0,0,0>, 1.1 * kugel(theta1, phi1), 0.005 }
			pigment {
				color rgb<0.6,0.0,0.0>
			}
		}
		mesh {
			triangle {
				<0,0,0>,
				1.1 * kugel(theta0, phi0),
				1.1 * kugel(theta1, phi1)
			}
			pigment {
				color rgbt<1,0.4,0.4,0.7>
			}
		}
	}
}

union {
	#declare massstab = 0.008;
	sphere { kugel(theta0, phi0), massstab }
	sphere { kugel(theta1, phi1), massstab }
	cylinder { kugel(theta0, phi0), kugel(theta1, phi1), massstab }
	pigment {
		color rgb<0,0,0.6>
	}
}
