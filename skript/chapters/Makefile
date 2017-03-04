#
# Makefile -- build additional materials
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	images

images:
	cd 3d; make images
	cd tikz; make images
	cd mp; make images

kugel.out:	kugel.maxima curvature.maxima
	maxima -b kugel.maxima | expand > kugel.out
