OCTAVE := octave
EPSTOPDF := epstopdf
RM := rm -f

PDFS := 12k2500-500.pdf 4k1800-500.pdf 2k900-500.pdf

images:	$(PDFS)

2k900-500.pdf:	2k900-500.eps
	$(EPSTOPDF) $<

2k900-500.eps:	plotter_2k_900-500.m 2k900-500.m
	$(OCTAVE) $<

4k1800-500.pdf:	4k1800-500.eps
	$(EPSTOPDF) $<

4k1800-500.eps:	plotter_4k_1800-500.m 4k1800-500.m
	$(OCTAVE) $<

12k2500-500.pdf:	12k2500-500.eps
	$(EPSTOPDF) $<

12k2500-500.eps:	plotter_12k_2500-500.m 12k2500-500.m
	$(OCTAVE) $<

clean:
	$(RM) *.pdf *.eps
