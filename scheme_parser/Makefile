.PHONY : all lex parse clean

##
## to compile to byte code comment the next line
## and uncomment the line after
##
OCAMLC=ocamlopt
#OCAMLC=ocamlc
YACC=ocamlyacc
LEX=ocamllex


##
## output name
##
OUTPUT=scheme_parser

##
## flags
##
OCAMLCFLAGS=-o ${OUTPUT}
YACCFLAGS=
LEXFLAGS=

##
## source files
##
OCAMLINTERFACES=scheme_parser.mli
##OCAMLINTERFACES=
OCAMLSOURCE=scheme_parser.ml scheme_lexer.ml
LEXSOURCE=scheme_lexer.mll
YACCSOURCE=scheme_parser.mly

##
## rules
##
all : ${OCAMLSOURCE} ${OCAMLINTERFACES}	
	${OCAMLC} ${OCAMLCFLAGS} ${OCAMLINTERFACES} ${OCAMLSOURCE}	

${OCAMLSOURCE} : lex parse

lex : parse ${OCAMLINTERFACES} ${LEXSOURCE}
	${LEX} ${LEXFLAGS} ${LEXSOURCE}

parse : ${YACCSOURCE}
	${YACC} ${YACCFLAGS} ${YACCSOURCE}

clean:
	rm *.ml *.mli *.cmi *.cmx ${OUTPUT} *.o
	
