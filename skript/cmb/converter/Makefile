PDFS := rgb-graph.pdf converter-function.pdf

images:	$(PDFS)

converter-function.pdf:	converter-function.eps
	epstopdf $<

converter-function.eps:	converter-function.m
	octave $<

rgb-graph.pdf:	rgb-graph.eps
	epstopdf $<

rgb-graph.eps:	rgb-graph.m
	octave $<

clean:
	rm -f *.pdf *.eps *.png octave-workspace
