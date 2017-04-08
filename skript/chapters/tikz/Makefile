#
# Makefile -- baue TIKZ-Bilder
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	lagrange.pdf lichtkegel.pdf absturz.pdf interferometer.pdf \
	galilei.pdf labor.pdf expansion1.pdf expansion2.pdf robertson.pdf

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
