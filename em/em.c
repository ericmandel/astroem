/* 
   em.c: routine to make life easier when using emscripten

   When running emscripten-compiled programs, we want to to avoid exiting the
   emscripten environment if the program calls exit(). So we do a setjmp and
   redefine exit to do a longjmp.

   The basic pattern is:

   if( !EM_ENTER ){
     _regcnts(i, args);
   }

   where an exit() in the program will call longjmp();

*/

#include <setjmp.h>

jmp_buf em_jmpbuf;

void em_exit(int n){
  // don't return with a 0, it will cause recursion! */
  if( n == 0 ){
    n = 1;
  }
  longjmp(em_jmpbuf, n);
}

