#include "colors.inc"

#declare        axisthickness = 0.040;
#declare        arrowheadlength = 0.25;

#declare d = 0.02;
#declare nsteps = 100;

#declare si = 2.5;

#declare xmin = -si;
#declare xmax =  si;
#declare xstep = xmax / (2 * nsteps);

#declare ymin = -si;
#declare ymax =  si;
#declare ystep = ymax / nsteps;

#declare zmin = 0;
#declare zmax = si;

#declare imagescale = 0.35;

camera {
        location <+7, 4.5, -9.2>
        look_at <(xmin + xmax)/2, zmax/2-0.05, (ymin + ymax)/2-0.15>
        right 16/9 * x * imagescale
        up y * imagescale
}

light_source { <-5, 10, -30> color White }
//light_source { <5, -5, -30> color White }
sky_sphere {
        pigment {
                color <1,1,1>
        }
}

#macro arrow(from, to)
#declare dirvector = to - from;
#declare dirvector = arrowheadlength * vnormalize(dirvector);
        cylinder {
                from - dirvector,
                to   + dirvector,
                axisthickness
        }
        cone {
                to +     dirvector, 2 * axisthickness,
                to + 2 * dirvector, 0
        }
#end

union {
        arrow(<xmin, 0, 0>, <xmax, 0, 0>)
        arrow(<0, 0, 0>, <0, zmax, 0>)
        arrow(<0, 0, ymin>, <0, 0, ymax>)
        sphere { <0, 0, 0>, axisthickness }
        pigment {
                color rgb<0.7, 0.7, 0.7>
        }
        finish {
                specular 0.9
                metallic
        }
}

#declare p = 0.1;

#declare r = 3;

#macro kugelpunkt(phi, ttheta)
	<r * cos(phi * 3.14159 / 180) * sin(ttheta * 3.14159 / 180),
	 r * cos(ttheta * 3.14159 / 180),
	 r * sin(phi * 3.14159 / 180) * sin(ttheta * 3.14159 / 180)>
#end

sphere {
	<0,0,0>, r
        pigment {
                color rgb<0.7, 0.7, 0.8>
        }
        finish {
                specular 0.9
                metallic
        }
}

union {
	sphere { kugelpunkt(-10, 70), p }
	sphere { kugelpunkt(-10, 30), p }
        pigment {
                color rgb<1, 1, 0>
        }
        finish {
                specular 0.9
                metallic
        }
	rotate 20 * kugelpunkt(-10, 30)
	rotate <0, 20, 0>
	rotate <10, 0, 10>
}

declare p = 0.5 * p;

union {
#declare theta = 30;
	sphere { kugelpunkt(-10, theta), p }
#while (theta < 69.5)
	cylinder {
		kugelpunkt(-10, theta),
		kugelpunkt(-10, theta + 1),
		p
	}
#declare theta = theta + 1;
	sphere { kugelpunkt(-10, theta), p }
#end
        pigment {
                color rgb<1, 0, 0>
        }
        finish {
                specular 0.9
                metallic
        }
	rotate 20 * kugelpunkt(-10, 30)
	rotate <0, 20, 0>
	rotate <10, 0, 10>
}

#macro angleoffset(ttheta, ampl)
	(ampl * (ttheta - 30) * (ttheta - 70))
#end

#declare p = 0.7 * p;

union {
#declare ampl = -0.18;
#while (ampl < 0.19)
#declare theta = 30;
	sphere { kugelpunkt(-10 + angleoffset(theta, ampl), theta), p }
#while (theta < 69.5)
	cylinder {
		kugelpunkt(-10 + angleoffset(theta, ampl), theta),
		kugelpunkt(-10 + angleoffset(theta + 1, ampl), theta + 1),
		p
	}
#declare theta = theta + 1;
	sphere { kugelpunkt(-10 + angleoffset(theta, ampl), theta), p }
#end
#declare ampl = ampl + 0.04;
#end
        pigment {
                color rgb<0, 0, 1>
        }
        finish {
                specular 0.9
                metallic
        }
	rotate 20 * kugelpunkt(-10, 30)
	rotate <0, 20, 0>
	rotate <10, 0, 10>
}
