CC =		/Users/eric/soft/emsdk/upstream/emscripten/emcc
CFLAGS =	-g -O2
AC_FLAGS =	-DPACKAGE_NAME=\"util\" -DPACKAGE_TARNAME=\"util\" -DPACKAGE_VERSION=\"1.0\" -DPACKAGE_STRING=\"util\ 1.0\" -DPACKAGE_BUGREPORT=\"saord@cfa.harvard.edu\" -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_MALLOC_H=1 -DHAVE_GETOPT_H=1 
RANLIB =	/Users/eric/soft/emsdk/upstream/emscripten/emranlib
ARCHIVE =	/Users/eric/soft/emsdk/upstream/emscripten/emar

INCS =		-I.

CC_SW =		 ${CFLAGS} ${AC_FLAGS} ${INCS}

OBJS =		file.o find.o macro.o mkrtemp.o \
		strtod.o swap.o word.o xalloc.o xerror.o

all:		libutil.a

libutil.a:	$(OBJS)
		$(or $(ARCHIVE),ar) rv $@ $?
		$(or $(RANLIB),ranlib) $@

file.o:		file.c
		$(CC) -c $(CC_SW) -o $@ $?

find.o:		find.c
		$(CC) -c $(CC_SW) -o $@ $?

macro.o:	macro.c
		$(CC) -c $(CC_SW) -o $@ $?

mkrtemp.o:	mkrtemp.c
		$(CC) -c $(CC_SW) -o $@ $?

strtod.o:	strtod.c
		$(CC) -c $(CC_SW) -o $@ $?

swap.o:		swap.c
		$(CC) -c $(CC_SW) -o $@ $?

word.o:		word.c
		$(CC) -c $(CC_SW) -o $@ $?

xalloc.o:	xalloc.c
		$(CC) -c $(CC_SW) -o $@ $?

xerror.o:	xerror.c
		$(CC) -c $(CC_SW) -o $@ $?

clean:		FORCE
		rm -rf *.o *.a *~ a.out* config.log config.status

FORCE:
