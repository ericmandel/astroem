astroem: libraries used in astrophysics, compiled to emscripten byte-code
-------------------------------------------------------------------------

The libraries in this repository have been compiled to byte-code using
emscripten. The byte-code files have .a extensions and are stored in the
lib subdirectory. Include files have been copied to the include subdirectory.

Current libraries:
  - cfitsio (https://heasarc.gsfc.nasa.gov/fitsio/fitsio.html)
  - wcs (http://tdc-www.harvard.edu/wcstools)
  - zlib (https://zlib.net/)
  - bzip2 (http://www.bzip.org/)

An emscripten-enabled project such as JS9 can copy the contents of the
lib and include sub-directories into their own work space and then
link against the byte-code libraries. For general emscripten build
instructions, see the documentation at:

https://kripken.github.io/emscripten-site/docs/compiling/Building-Projects.html

For an example of the use of these particular libraries, see the
[Makefile](https://github.com/ericmandel/js9/blob/master/astroem/Makefile)
in the astroem sub-directory of https://github.com/ericmandel/js9.

The libraries are compiled using the -O3 level of optimization (see
the EMFLAGS variable in the top-level Makefile).  Emscripten wants you
to use the same optimization flags throughout the project, so if you
use a different level of optimization, you probably want to change the
EMFLAGS variable and rebuild the libraries by executing *make*.

astroem is distributed under the terms of The MIT License.

Eric Mandel, Harvard-Smithsonian Center for Astrophysics

