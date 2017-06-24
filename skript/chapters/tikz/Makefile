#
# Makefile -- baue TIKZ-Bilder
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	lagrange.pdf lichtkegel.pdf absturz.pdf interferometer.pdf \
	galilei.pdf labor.pdf expansion1.pdf expansion2.pdf robertson.pdf \
	friedmann-materie.pdf friedmann-strahlung.pdf friedmann-leer.pdf \
	darkenergy.pdf orbit.pdf orbit2.pdf lichtablenkung.pdf dipol1.pdf \
	dipol2.pdf ionisation.pdf kreisbogen.pdf tangente.pdf kruemmung.pdf \
	wald.pdf 4pifu2.pdf

images:	all

absturz.pdf:	absturz.tex
	pdflatex absturz.tex

lichtkegel.pdf:	lichtkegel.tex
	pdflatex lichtkegel.tex

lagrange.pdf:	lagrange.tex
	pdflatex lagrange.tex

interferometer.pdf:	interferometer.tex
	pdflatex interferometer.tex

galilei.pdf:	galilei.tex
	pdflatex galilei.tex

labor.pdf:	labor.tex
	pdflatex labor.tex

expansion1.pdf:	expansion1.tex expansion-common.tex
	pdflatex expansion1.tex

expansion2.pdf:	expansion2.tex expansion-common.tex
	pdflatex expansion2.tex

robertson.pdf:	robertson.tex
	pdflatex robertson.tex

friedmann-materie.pdf:	friedmann-materie.tex
	pdflatex friedmann-materie.tex

friedmann-strahlung.pdf:	friedmann-strahlung.tex
	pdflatex friedmann-strahlung.tex

friedmann-leer.pdf:	friedmann-leer.tex
	pdflatex friedmann-leer.tex

darkenergy.pdf:	darkenergy.tex darkenergy.csv
	pdflatex darkenergy.tex

orbit.pdf:	orbit.tex orbit.csv
	pdflatex orbit.tex

orbit2.pdf:	orbit2.tex orbit2.csv
	pdflatex orbit2.tex

lichtablenkung.pdf:	lichtablenkung.tex lichtablenkung.csv
	pdflatex lichtablenkung.tex

dipol1.pdf:	dipol1.tex 
	pdflatex dipol1.tex

dipol2.pdf:	dipol2.tex 
	pdflatex dipol2.tex

ionisation.pdf:	ionisation.tex 
	pdflatex ionisation.tex

kreisbogen.pdf:	kreisbogen.tex
	pdflatex kreisbogen.tex

tangente.pdf:	tangente.tex
	pdflatex tangente.tex

kruemmung.pdf:	kruemmung.tex
	pdflatex kruemmung.tex

wald.pdf:	wald.tex waldbaeume.tex
	pdflatex wald.tex

4pifu2.pdf:	4pifu2.tex
	pdflatex 4pifu2.tex
