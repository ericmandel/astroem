# EMCC compiler
EMCC		= emcc

# emcc compiler flags
# debugging with symbols
# EMFLAGS	= -O0 -s ASSERTIONS=1
# production
EMFLAGS		= -O3

# needed for compilations that don't use emconfigure or don't use macros
EM_CFLAGS	= CC=$(EMCC) CFLAGS="$(EMFLAGS)" ARCHIVE=emar RANLIB=emranlib AR=emar ARFLAGS=cruv
# same but builds shared library
EM_SHARED	= -s MAIN_MODULE=2
EM_SHARED_EXT	= _shared.a
EM_CFLAGS_SO	= CC=$(EMCC) CFLAGS="$(EMFLAGS) $(EM_SHARED)" ARCHIVE=emar RANLIB=emranlib AR=emar ARFLAGS=cruv

# flags to pass when we rebuild the emsripten cache
EMCACHE_FLAGS	= -s USE_ZLIB=1 -s USE_BZIP2=1

# libraries that we build, along with configuration params as needed:
BZIP2 		= ./bzip2

EMCACHE		= ./emcache

CFITSIO 	= ./cfitsio
CFITSIO_CFLAGS	= $(EMFLAGS) -D__x86_64__ -Wno-deprecated-non-prototype

EM 		= ./em

REGIONS		= ./regions
REGIONS_CFLAGS	= $(EMFLAGS) -I./util -I../include  -D'exit(n)=em_exit(n)'
REGINCL		= regions.h regionsP.h \
		imfilter_c.h imregions_c.h imregions.h imregions_h.h

UTIL		= ./util
UTIL_CFLAGS	= $(EMFLAGS) -D'exit(n)=em_exit(n)'

WCS 		= ./wcs

ZLIB 		= ./zlib

guard:		FORCE
		@(echo "use 'make all' to build all libraries")

# build all libraries
all:		cfitsio util wcs em regions

# clear and then remake the emscripten system cache
emcache:	FORCE
		@(CDIR=`pwd`; cd $(EMCACHE);       		\
		  emcc --version; 		   		\
		  echo "clearing emscripten system cache"; 	\
		  emcc --clear-cache; 				\
		  echo "rebuilding emscripten system cache"; 	\
		  emcc $(EMFLAGS) $(EMCACHE_FLAGS) hello.c; 	\
		  echo "cleaning up emscripten files"; 		\
		  rm -rf a.out.js  a.out.wasm)

cfitsio:	FORCE
		@(CDIR=`pwd`; cd $(CFITSIO);       \
		FC=none LDFLAGS="-s USE_ZLIB=1" emconfigure ./configure --disable-curl; \
		sed 's/ \-DCFITSIO_HAVE_CURL=1//;s/ \-DHAVE_NET_SERVICES=1//' < Makefile > nMakefile && mv nMakefile Makefile;     \
		emmake make CFLAGS="$(CFITSIO_CFLAGS)" clean libcfitsio.a; \
		cp -p libcfitsio.a $${CDIR}/lib;   \
		emmake make CFLAGS="$(CFITSIO_CFLAGS) $(EM_SHARED)" clean libcfitsio.a; \
		cp -p libcfitsio.a $${CDIR}/lib/libcfitsio$(EM_SHARED_EXT);   \
	        cp -p *.h $${CDIR}/include)

em:		FORCE
		@(CDIR=`pwd`; cd $(EM);            \
		emmake make $(EM_CFLAGS) libem.a;  \
		cp -p libem.a $${CDIR}/lib;        \
		emmake make $(EM_CFLAGS_SO) clean libem.a;  \
		cp -p libem.a $${CDIR}/lib/libem$(EM_SHARED_EXT);  \
	        cp -p *.h $${CDIR}/include)

regions:	FORCE
		@(CDIR=`pwd`; cd $(REGIONS);        \
		emconfigure ./configure --with-cfitsio=..; \
		emmake make clean CFLAGS="$(REGIONS_CFLAGS)" emlib; \
		cp -p libregions.a $${CDIR}/lib;    \
		emmake make clean CFLAGS="$(REGIONS_CFLAGS) $(EM_SHARED)" emlib; \
		cp -p libregions.a $${CDIR}/lib/libregions$(EM_SHARED_EXT);    \
	        cp -p $(REGINCL) $${CDIR}/include)

util:		FORCE
		@(CDIR=`pwd`; cd $(UTIL);          \
		emconfigure ./configure;           \
		emmake make clean CFLAGS="$(UTIL_CFLAGS)" all;             \
		cp -p libutil.a $${CDIR}/lib;      \
		emmake make clean CFLAGS="$(UTIL_CFLAGS) $(EM_SHARED)" all; \
		cp -p libutil.a $${CDIR}/lib/libutil$(EM_SHARED_EXT);      \
	        cp -p *.h $${CDIR}/include)

wcs:		FORCE
		@(CDIR=`pwd`; cd $(WCS);           \
		$(eval EMFLAGS += -Wno-deprecated-non-prototype) \
		emmake make $(EM_CFLAGS) libwcs.a; \
		cp -p libwcs.a $${CDIR}/lib;       \
		emmake make $(EM_CFLAGS_SO) clean libwcs.a;  \
		cp -p libwcs.a $${CDIR}/lib/libwcs$(EM_SHARED_EXT); \
	        cp -p *.h $${CDIR}/include)

bzip2:		FORCE
		@(CDIR=`pwd`; cd $(BZIP2);         \
		emmake make $(EM_CFLAGS) libbz2.a; \
		cp -p libbz2.a $${CDIR}/lib;       \
		emmake make $(EM_CFLAGS_SO) clean libbz2.a;  \
		cp -p libbz2.a $${CDIR}/lib/libbz2$(EM_SHARED_EXT); \
	        cp -p *.h $${CDIR}/include)

zlib:		FORCE
		@(CDIR=`pwd`; cd $(ZLIB);          \
		emconfigure ./configure --static;  \
		emmake make $(EM_CFLAGS) libz.a;   \
		cp -p libz.a $${CDIR}/lib;         \
		emmake make $(EM_CFLAGS_SO) clean libz.a; \
		cp -p libz.a $${CDIR}/lib/libz$(EM_SHARED_EXT);  \
	        cp -p *.h $${CDIR}/include)

clean:		FORCE
		@(rm -rf *.o *~ a.out* foo* *.map \#*         \
		*/*~ */*.wasm astroem*.js astroem*.mem astroem.bc; \
		(cd $(EM) && make clean 2>&1 >/dev/null;);    \
		(cd $(CFITSIO) && rm -rf config.log a.out* && test -r Makefile && make clean distclean 2>&1 >/dev/null;); \
		(cd $(REGIONS) && make clean 2>&1 >/dev/null;);   \
		(cd $(UTIL) && make clean 2>&1 >/dev/null;);   \
		(cd $(WCS) && make clean 2>&1 >/dev/null;);    \
		(cd $(BZIP2) && make clean 2>&1 >/dev/null;); \
		(cd $(ZLIB) && rm -rf *.js && make distclean 2>&1 >/dev/null;);)

FORCE:
