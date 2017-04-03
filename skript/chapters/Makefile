#
# Makefile -- build additional materials
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	makeimages robertson3.txt

makeimages:
	cd 3d; make images
	cd tikz; make images
	cd mp; make images

kugel.out:	kugel.maxima curvature.maxima
	maxima -b kugel.maxima | expand > kugel.out

robertson3.txt:	robertson3.maxima
	if type maxima; \
	then \
		maxima -b robertson3.maxima | expand > robertson3.txt; \
	fi
