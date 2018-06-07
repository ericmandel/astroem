OBJS =		em.o

libem.a:	$(OBJS)
		$(or $(ARCHIVE),ar) rv $@ $?
		$(or $(RANLIB),ranlib) $@

em.o:		em.c em.h

clean:
		rm -f *.a *.o *~

