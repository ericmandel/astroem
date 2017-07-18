astroem: astronomical libraries compiled to emscripten byte-code
----------------------------------------------------------------

The libraries in this repository have been compiled to byte-code using
emscripten. The byte-code files have .a extensions and are stored in the
lib subdirectory. Include files have been copied to the include subdirectory.

An emscripten-enabled project such as JS9 can copy the contents of the lib
and include sub-directories into their own work space and then link against
the byte-code libraries. See the 
[Makefile](https://github.com/ericmandel/js9/blob/master/astroem/Makefile)
in the astroem sub-directory of https://github.com/ericmandel/js9
for an example of use.

Note that the libraries are compiled using the -O3 level of optimization.

astroem is distributed under the terms of The MIT License.

Eric Mandel, Harvard-Smithsonian Center for Astrophysics

