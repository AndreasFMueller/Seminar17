#
# Makefile
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	transport kurve lichtkegel geodaete blackhole flach sphere

w = 3840
h = 2160
scale=50

#w = 1920
#h = 1080
#scale=100

dimensions = -W$(w) -H$(h)
povrayoptions = +A0.1

flach:	flach.jpg
flach.png:	flach.pov
	sh ../../../povray $(povrayoptions) $(dimensions) -Oflach.png 	\
		flach.pov
flach.jpg:	flach.png
	convert -extract 2376x2160+775+0 flach.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		flach.jpg

sphere:	sphere.jpg
sphere.png:	sphere.pov
	sh ../../../povray $(povrayoptions) $(dimensions) -Osphere.png 	\
		sphere.pov
sphere.jpg:	sphere.png
	convert -extract 2420x2160+735+0 sphere.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		sphere.jpg

blackhole:	blackhole.jpg
blackhole.png:	blackhole.pov
	sh ../../../povray $(povrayoptions) $(dimensions) -Oblackhole.png \
		blackhole.pov
blackhole.jpg:	blackhole.png
	convert -extract 2572x2160+860+0 blackhole.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		blackhole.jpg

lichtkegel:	lichtkegel.jpg
lichtkegel.jpg: lichtkegel.png
	convert -extract 2750x2160+610+0 lichtkegel.png \
		-units PixelsPerInch -density 300 \
		-scale 50% lichtkegel.jpg
lichtkegel.png: lichtkegel.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Olichtkegel.png \
		lichtkegel.pov

geodaete:	geodaete.jpg
geodaete.jpg:   geodaete.png
	convert -extract 3104x2070+416+0 geodaete.png \
		-units PixelsPerInch -density 300 \
		-scale 50% geodaete.jpg
geodaete.png:   geodaete.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Ogeodaete.png \
		geodaete.pov

kurve:	kurve.jpg
kurve.jpg:   kurve.png
	convert -extract 3104x2070+416+0 kurve.png \
		-units PixelsPerInch -density 300 \
		-scale 50% kurve.jpg
kurve.png:   kurve.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Okurve.png \
		kurve.pov

transport:	transport.jpg
transport.jpg:   transport.png
	convert -extract 2328x2160+912+0 transport.png \
		-units PixelsPerInch -density 300 \
		-scale 50% transport.jpg
transport.png:   transport.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Otransport.png \
		transport.pov

