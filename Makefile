# EMCC compiler
EMCC		= emcc

# emcc compiler flags
# debugging with symbols
# EMFLAGS	= -O0 -s ASSERTIONS=1
# production
EMFLAGS		= -O3

# needed for compilations that don't use emconfigure or done use macros
EM_CFLAGS	= CC=$(EMCC) CFLAGS=$(EMFLAGS) ARCHIVE=emar RANLIB=emranlib AR=emar ARFLAGS=cruv

# libraries that we build, along with configuration params as needed:
CFITSIO 	= ./cfitsio
CFITSIO_CFLAGS	= $(EMFLAGS) -fno-common -D__x86_64__

WCS 		= ./wcs

ZLIB 		= ./zlib

BZIP2 		= ./bzip2

# build all libraries
all:		cfitsio wcs zlib bzip2

cfitsio:	FORCE
		@(CDIR=`pwd`; cd $(CFITSIO);       \
		emconfigure ./configure;           \
		emmake make ZLIB_SOURCES="" CFLAGS="$(CFITSIO_CFLAGS)" \
		clean all-nofitsio ;               \
		cp -p libcfitsio.a $${CDIR}/lib;   \
	        cp -p *.h $${CDIR}/include;)

wcs:		FORCE
		@(CDIR=`pwd`; cd $(WCS);           \
		emmake make $(EM_CFLAGS) libwcs.a; \
		cp -p libwcs.a $${CDIR}/lib;       \
	        cp -p *.h $${CDIR}/include;)

zlib:		FORCE
		@(CDIR=`pwd`; cd $(ZLIB);          \
		emconfigure ./configure --static;  \
		emmake make $(EM_CFLAGS) libz.a;   \
		cp -p libz.a $${CDIR}/lib;         \
	        cp -p *.h $${CDIR}/include;)


bzip2:		FORCE
		@(CDIR=`pwd`; cd $(BZIP2);         \
		emmake make $(EM_CFLAGS) libbz2.a; \
		cp -p libbz2.a $${CDIR}/lib;       \
	        cp -p *.h $${CDIR}/include;)

clean:		FORCE
		@(rm -rf *.o *~ a.out* foo* *.map \#*         \
		astroem*.js astroem*.mem astroem.bc;          \
		(cd $(CFITSIO) && rm -rf a.out* && test -r Makefile && make clean distclean 2>&1 >/dev/null;); \
		(cd $(WCS) && make clean 2>&1 >/dev/null;);   \
		(cd $(ZLIB) && rm -rf *.js && make distclean 2>&1 >/dev/null;); \
		(cd $(BZIP2) && make clean 2>&1 >/dev/null;); \
		)

FORCE:
