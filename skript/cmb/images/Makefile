.PHONY:	images

images:	12k.pdf 12k_1000.pdf 12k_1200.pdf

12k.pdf:	12k.eps
	epstopdf $<

12k.eps:	plotter_12k.m 12kdata.m
	octave $<

12k_1000.pdf:	12k_1000.eps
	epstopdf $<

12k_1000.eps:	plotter_12k_1000.m 12kdata_1000.m
	octave $<

12k_1200.pdf:	12k_1200.eps
	epstopdf $<

12k_1200.eps:	plotter_12k_1200.m 12kdata_1200.m
	octave $<

clean:
	rm *.eps *.pdf octave-workspace
