#
# Makefile
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
images:	hf

hf_images = hf-1.pdf
hf:	$(hf_images)

$(hf_images):	hf.mp
	TEX=latex mpost hf.mp
	for f in hf.*; \
	do \
		mptopdf $${f}; \
	done

	
