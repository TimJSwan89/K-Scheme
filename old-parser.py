#!/usr/bin/python
#this is a driver for the maude definition of scheme
#it "parses" normal scheme input and formats it for
#the definition.  This consists of changing
#parentheses to brackets (i.e. "(" to "["), putting
#commas between expressions, prefixing names with
#quotes, replacing ' with $, ` with ! and , with !!
import sys
import string
import re

#input file
input = open(sys.argv[1])

#this is our output buffer
buffer = "red run( "

#this is the current word being processed
word = ""

#this is a regular expression used to match
#numerical constants
num_const_re = re.compile("-?[0-9]+")

#this count tells us when we need to emit a comma
#as we need commas between expressions
paren_count = 0

#this flag tells us if the current quote is an open
#or close quote, so we know whether to use { or }
quote_flag = True

#python doesn't have switch statements
#we use a dictionary to achieve the same
#effect.  This is for deciding if a word is
#a keyword or not.  If it is not
#we must add a quote (sometimes keywords
#need quotes too, i.e. '+)

#all keywords must be defined here.  The
#left is the scheme version of the keyword,
#the right is the maude defintion version. In
#most cases these will be the same
word_case = { "#t": "#t",
              "#f": "#f",
	      #a
	      "and" : "and",
	      "append" : "append",
	      "apply" : "apply",
	      #b
	      "begin" : "begin",
	      "boolean?" : "boolean?",
	      #c
	      "char?" : "char?",
	      "call-with-current-continuation" : 
	         "call-with-current-continuation",
	      "call-with-values" : "call-with-values",
	      "car" : "car",
	      "cdr" : "cdr",
	      "cadr" : "cadr",
	      "cddr" : "cddr",
	      "cdar" : "cdar",
	      "caar" : "caar", 
	      "cond" : "cond",
	      "cons" : "cons",
	      #d
	      "define" : "define",
	      "define-syntax" : "define-syntax",
              "syntax-rules" : "syntax-rules",
              "delay" : "delay",
	      "display" : "display",
	      "do" : "do", 
              "dynamic-wind" : "dynamic-wind",
	      #e
	      "else" : "else",
	      "eqv?" : "eqv?",
	      "eq?" : "eq?",
	      "equal?" : "equal?",
	      "eval" : "eval",
              "expt" : "expt",
              #f
	      "first" : "first",
	      "force" : "force",
              #g
	      "if" : "if",
	      #l
	      "lambda" : "lambda",
	      "let" : "let",
	      "let*" : "let*",
	      "letrec" : "letrec",
	      "letrec*" : "letrec*",
	      "list" : "list",
	      #m
	      "make-vector" : "make-vector",
	      "make-string" : "make-string",
              #n
	      "not" : "not",
              "null?" : "null?",
	      "number?" : "number?",
	      #o
	      "or" : "or",
	      #p
	      "pair?" : "pair?", 
	      "procedure?" : "procedure?", 
	      #q
	      "quote" : "quote",
	      "quasiquote" : "quasiquote",
	      #r
	      "rest" : "rest",
	      #s
	      "second" : "second",
	      "set!" : "set!",
	      "set-car!" : "set-car!",
              "set-cdr!" : "set-cdr!",
	      "string?" : "string?",
	      "string-length" : "string-length",
	      "string-ref" : "string-ref",
	      "string-set!" : "string-set!",
              "symbol?" : "symbol?", 
	      #u
	      "unquote" : "unquote",
              "unquote-splicing": "unquote-splicing",
	      #v
	      "values" : "values",
	      "vector?" : "vector?",
	      "vector-length" : "vector-length",
              "vector-ref" : "vector-ref",
	      "vector-set!" : "vector-set!",
	      
	      #these actually change
	      "+" : "'+",
              "-" : "'-",
              "*" : "'*",
	      "/" : "'/",
	      "<" : "'<",
	      ">" : "'>",
	      "<=" : "'<=",
	      ">=" : "'>=",
	      "."  : ".",
              ","  : "!!",
              ",@" : "!@",
              "#" : "#"
		}


#generic delimiter function
#we can use the same function for all word boundaries
#(which are open paren, close paren, space, tab, and new line)
def delimiter(str):
  global word, word_case, num_const_re
  #this marks the possible end of a token
  #so strip the current word and map
  #it into the internal representation
  #note that the word might be "" and that
  #this will not be a problem
  word = string.strip(word)
  try:
    ret = word_case[word] + str
  #default case requires catching KeyError
  except KeyError:
    #we arrive here if this is not a key word
    #there are four possibilities
    #1) this is a numerical constant, if so
    #   emit it as is
    #2) this is a character constant, we need
    #   to put quotes around the constant
    #3) this is a blank word (can happen if white space
    #   before a close paren for example), just emit
    #   the delimiter
    #4) this is some other word, quote this as the definition
    #   expects QIDs
    if num_const_re.match(word):
      #maude likes spaces between tokens, so insert a space
      #before the delimiter
      ret = word + " " + str 
    elif len(word) == 3 and word[0] == "#" and word[1] == "\\":
      ret = "#\(\"" + word[2] + "\")" + str 
    elif word != "":
      ret = "'" + word + " " + str
    else:
      ret = " " + str
  #empty the word buffer
  word = ""
  return ret

#function for an open parenthesis
def open_paren():
  global paren_count
  paren_count += 1
  #print the current word and attach a "[" in place
  #of "("
  return delimiter("[")

#function for a close parenthesis
def close_paren():
  global paren_count
  paren_count -= 1
  #if the count is now 0 we need a comma
  if paren_count == 0:
    return delimiter("], ")
  #else no comma
  return delimiter("]")

#function for quotes (")
def quote():
  global quote_flag, word
  if quote_flag:
    quote_flag = False
    return delimiter("{\"")
  else: 
    quote_flag = True
    ret = word + "\"}"
    word = ""
    return ret

#warning, ugly hack
lookahead = ""

#only accounting for space, tab, and new line as line space
#beware!
char_case = { 
         " " : lambda : delimiter(" "),
	 "\t": lambda : delimiter("\t"),
	 "\n": lambda : delimiter("\n"), 
	 "(" : open_paren,
         ")" : close_paren,
	 "[" : open_paren,
	 "]" : close_paren,
	 "'" : lambda  : "$ ",
	 "`" : lambda  : "! ",
	 "\"": quote
       }

#parse the file
try:
  for line in input:
    for char in line:
      #call our switch statement
      #the only way to have a "default"
      #case is to catch a KeyError
      #(bad, but I love Python)
      try:
        buffer += char_case[char]()
      #our default is to add the character
      #unmodified to the current word
      except KeyError:
        word += char
#make sure no matter what that we close the file
finally:
  input.close()
  buffer = string.strip(buffer)
  if buffer[-1] == ",":
    #if the last character is a comma make sure to
    #remove it
    buffer = buffer[0:-1]
  print buffer + " ) ."
