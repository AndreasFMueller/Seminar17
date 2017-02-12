#
# Makefile
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	flach sphere

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
	convert flach.png -scale $(scale)% -density 300 -units PixelsPerInch \
		flach.jpg

sphere:	sphere.jpg
sphere.png:	sphere.pov
	sh ../../../povray $(povrayoptions) $(dimensions) -Osphere.png 	\
		sphere.pov
sphere.jpg:	sphere.png
	convert sphere.png -scale $(scale)% -density 300 -units PixelsPerInch \
		sphere.jpg

