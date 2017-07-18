# emcc compiler flags
# debugging with symbols
# EMFLAGS	= -O0 -s ASSERTIONS=1
# production
EMFLAGS		= -O3

# combine into EMCC command
EMCC		= emcc $(EMFLAGS)

# needed for compilations that do not use emsconfigure
EM_CFLAGS	= ARCHIVE=emar RANLIB=emranlib

# libraries that we build, along with configuration params
CFITSIO 	= ./cfitsio
CFITSIO_CFLAGS	= $(EMFLAGS) -fno-common -D__x86_64__

WCS 		= ./wcs
WCS_CFLAGS	= $(EMFLAGS)


# build all libraries
all:		cfitsio wcs

# cfitsio library
# don't make zlib in cfitsio, we'll use the emscripten version
cfitsio:	FORCE
		@(CDIR=`pwd`; cd $(CFITSIO); \
		emconfigure ./configure; \
		emmake make ZLIB_SOURCES="" CFLAGS="$(CFITSIO_CFLAGS)" \
		clean all-nofitsio ;\
		cp -p libcfitsio.a $${CDIR}/lib;)

wcs:		FORCE
		@(CDIR=`pwd`; cd $(WCS); \
		emmake make CFLAGS="$(WCS_CFLAGS)" $(EM_CFLAGS) libwcs.a; \
		cp -p libwcs.a $${CDIR}/lib;)

include:	FORCE
		@(cp -p $(CFITSIO)/*.h include/.; \
		  cp -p $(WCS)/*.h include/.;)

clean:		FORCE
		@(rm -rf *.o *~ a.out* foo* *.map \#*  \
		astroem*.js astroem*.mem astroem.bc; \
		(cd $(CFITSIO) && test -r Makefile && make clean distclean 2>&1 >/dev/null;); \
		(cd $(WCS) && make clean 2>&1 >/dev/null;); \
		)

FORCE:
