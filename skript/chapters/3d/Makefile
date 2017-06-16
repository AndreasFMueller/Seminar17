#
# Makefile
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	transport kurve lichtkegel geodaete blackhole flach sphere \
	negativ eben positiv \
	pringles-positiv pringles-negativ pringles-flach \
	schnittkruemmung hauptkruemmungen

images:	all

w = 3840
h = 2160
scale=50

ww = 1920
hh = 1080
#scale=100

highdimensions = -W$(w) -H$(h)
lowdimensions = -W$(ww) -H$(hh)
povrayoptions = +A0.1

flach:	flach.jpg
flach.png:	flach.pov
	sh ../../../povray $(povrayoptions) $(highdimensions) -Oflach.png 	\
		flach.pov || touch flach.png
flach.jpg:	flach.png
	convert -extract 2376x2160+775+0 flach.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		flach.jpg

sphere:	sphere.jpg
sphere.png:	sphere.pov
	sh ../../../povray $(povrayoptions) $(highdimensions) -Osphere.png 	\
		sphere.pov || touch sphere.png
sphere.jpg:	sphere.png
	convert -extract 2420x2160+735+0 sphere.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		sphere.jpg

blackhole:	blackhole.jpg
blackhole.png:	blackhole.pov
	sh ../../../povray $(povrayoptions) $(highdimensions) -Oblackhole.png \
		blackhole.pov || touch blackhole.png
blackhole.jpg:	blackhole.png
	convert -extract 2572x2160+860+0 blackhole.png \
		-scale $(scale)% -density 300 -units PixelsPerInch \
		blackhole.jpg

lichtkegel:	lichtkegel.jpg
lichtkegel.jpg: lichtkegel.png
	convert -extract 2750x2160+610+0 lichtkegel.png \
		-units PixelsPerInch -density 300 \
		-scale 50% lichtkegel.jpg
lichtkegel.png: lichtkegel.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Olichtkegel.png \
		lichtkegel.pov || touch lichtkegel.png

geodaete:	geodaete.jpg
geodaete.jpg:   geodaete.png
	convert -extract 3104x2070+416+0 geodaete.png \
		-units PixelsPerInch -density 300 \
		-scale 50% geodaete.jpg
geodaete.png:   geodaete.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Ogeodaete.png \
		geodaete.pov || touch geodaete.png

kurve:	kurve.jpg
kurve.jpg:   kurve.png
	convert -extract 3104x2070+416+0 kurve.png \
		-units PixelsPerInch -density 300 \
		-scale 50% kurve.jpg
kurve.png:   kurve.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Okurve.png \
		kurve.pov || touch kurve.png

transport:	transport.jpg
transport.jpg:   transport.png
	convert -extract 2328x2160+912+0 transport.png \
		-units PixelsPerInch -density 300 \
		-scale 50% transport.jpg
transport.png:   transport.pov
	sh ../../../povray $(povrayoptions) +W3840 +H2160 -Otransport.png \
		transport.pov || touch transport.png

negativ:	negativ.jpg
negativ.jpg:	negativ.png
	convert -extract 858x1080+534+0 negativ.png \
		-units PixelsPerInch -density 300 negativ.jpg
negativ.png:	negativ.pov pseudosphaere.inc curve1.inc curve2.inc curve3.inc
	sh ../../../povray $(povrayoptions) -W1920 -H1080 -Onegativ.png \
		negativ.pov || touch negativ.png

eben:	eben.jpg
eben.jpg:	eben.png
	convert -extract 706x1080+464+0 eben.png \
		-units PixelsPerInch -density 300 eben.jpg
eben.png:	eben.pov pseudosphaere.inc curve1.inc curve2.inc curve3.inc
	sh ../../../povray $(povrayoptions) -W1920 -H1080 -Oeben.png \
		eben.pov || touch eben.png

positiv:	positiv.jpg
positiv.jpg:	positiv.png
	convert -extract 806x1080+406+0 positiv.png \
		-units PixelsPerInch -density 300 positiv.jpg
positiv.png:	positiv.pov pseudosphaere.inc curve1.inc curve2.inc curve3.inc
	sh ../../../povray $(povrayoptions) -W1920 -H1080 -Opositiv.png \
		positiv.pov || touch positiv.png

pringles:	pringles.jpg
pringles.jpg:	pringles.png
	convert pringles.png \
		-units PixelsPerInch -density 300 pringles.jpg
pringles.png:	pringles.pov pseudosphaere.inc curve1.inc curve2.inc curve3.inc
	sh ../../../povray $(povrayoptions) -W1920 -H1080 -Opringles.png \
		pringles.pov || touch pringles.png

pringles-negativ:	pringles-negativ.jpg
pringles-negativ.jpg:	pringles-negativ.png
	convert -extract 3036x2016+404+28 pringles-negativ.png \
		-units PixelsPerInch -density 300 pringles-negativ.jpg
pringles-negativ.png:	pringles-negativ.pov pringles.inc
	sh ../../../povray $(povrayoptions) $(highdimensions) \
		-Opringles-negativ.png \
		pringles-negativ.pov || touch pringles-negativ.png

pringles-positiv:	pringles-positiv.jpg
pringles-positiv.jpg:	pringles-positiv.png
	convert -extract 1872x1360+1180+716 pringles-positiv.png \
		-units PixelsPerInch -density 300 pringles-positiv.jpg
pringles-positiv.png:	pringles-positiv.pov pringles.inc
	sh ../../../povray $(povrayoptions) $(highdimensions) \
		-Opringles-positiv.png \
		pringles-positiv.pov || touch pringles-positiv.png

pringles-flach:	pringles-flach.jpg
pringles-flach.jpg:	pringles-flach.png
	convert -extract 3012x1280+416+232 pringles-flach.png \
		-units PixelsPerInch -density 300 pringles-flach.jpg
pringles-flach.png:	pringles-flach.pov pringles.inc
	sh ../../../povray $(povrayoptions) $(highdimensions) \
		-Opringles-flach.png \
		pringles-flach.pov || touch pringles-flach.png

pringles-animation:
	sh ../../../povray $(povrayoptions) -W1920 -H1080 \
		-Opringles/p pringles.ini

schnittkruemmung:	schnittkruemmung.jpg
schnittkruemmung.jpg:	schnittkruemmung.png Makefile
	convert -extract 2164x1704+816+0 schnittkruemmung.png \
		-units PixelsPerInch -density 300 schnittkruemmung.jpg
schnittkruemmung.png:	schnittkruemmung.pov
	sh ../../../povray $(povrayoptions) $(highdimensions) \
		-Oschnittkruemmung.png \
		schnittkruemmung.pov || touch schnittkruemmung.png

hauptkruemmungen:	hauptkruemmungen.jpg
hauptkruemmungen.jpg:	hauptkruemmungen.png Makefile
	convert -extract 2104x1340+856+460 hauptkruemmungen.png \
		-units PixelsPerInch -density 300 hauptkruemmungen.jpg
hauptkruemmungen.png:	hauptkruemmungen.pov
	sh ../../../povray $(povrayoptions) $(highdimensions) \
		-Ohauptkruemmungen.png \
		hauptkruemmungen.pov || touch hauptkruemmungen.png







