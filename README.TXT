*****************************************************************
* K-Scheme README
* http://fsl.cs.uiuc.edu/K-Scheme
*****************************************************************


* Use of the definition itself (the file k-scheme.maude) 
  requries maude (maude.cs.uiuc.edu) to be installed.

* The directory examples contains all the exmaples used online.

* The directory lib contains the library for k-scheme, 
  in the file lib.scm.

* The old parser is available as old-parser.py, it has some bugs
  requiring spaces between certain tokens (such a ',').  Adding
  extra spaces should fix any errors.  It requries python to run

* The new parser is in the directory scheme_parser, it requires
  the ocaml distribution to build.  It is currently setup for
  a native build, it can be changed to use ocaml byte code by
  commenting the proper lines in the Makefile.  See
  scheme_parser/Makefile for more info.

* To run a given program p.scm:
  cat lib.scm p.scm > tmp.0
  scheme_parser/scheme_parser tmp.0 | maude
  



