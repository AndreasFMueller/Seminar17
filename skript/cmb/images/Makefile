.PHONY:	images

images:	12k_2500.pdf

12k_2500.eps:	plotter_12k_2500.m 12kdata_2500.m
	octave $<

12k_2500.pdf:	12k_2500.eps
	epstopdf $<

clean:
	rm *.eps *.pdf octave-workspace

