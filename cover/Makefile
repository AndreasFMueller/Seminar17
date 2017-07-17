#
# Makefile
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
buchcover.pdf:	buchcover.tex
	pdflatex buchcover.tex

cdcover.pdf:	cdcover.tex
	pdflatex cdcover.tex

kugel.png:      kugel.pov
	bash ../povray $(povrayoptions) +W1920 +H1080 -Okugel.png kugel.pov

kugel2.png:      kugel.pov
	bash ../povray $(povrayoptions) +W3840 +H2160 -Okugel2.png kugel.pov

kugel4.png:      kugel.pov
	bash ../povray $(povrayoptions) +W7680 +H4320 -Okugel4.png kugel.pov

kugel.jpg:      kugel.png
	convert kugel.png -density 300 -units PixelsPerInch kugel.jpg


