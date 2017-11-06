%{
%}

/*** 
 *** Note that parentheses and brackets are merged by the lexer
 *** i.e., there are only two tokens not four
 ***/ 

%token HASH EOF SEARCH 
%token <int * int> LEFT_PAREN RIGHT_PAREN
%token QUOTE QUASIQUOTE UNQUOTE UNQUOTESPLICING DOT
%token <string> BOOL CHAR SYMBOL INT REAL STRING ERROR
%start main
%type < string > main

%%
main:
    top_level_expressions SEARCH EOF {"search run (" ^ $1 ^ ") =>* O ."} 
  | top_level_expressions EOF   {"rew run (" ^ $1 ^ ") ."}
    ;

top_level_expressions:
    top_level_expressions expression {$1 ^ ", " ^ $2}
  | expression                       {$1}
    ;
    
expressions:
   expressions expression  {$1 ^ " " ^ $2}
 | expression              {$1}
   ;

expression:
    LEFT_PAREN expressions RIGHT_PAREN        {"[" ^ $2 ^ "]"}
  | LEFT_PAREN expressions DOT expression RIGHT_PAREN 
                                              {"[" ^ $2 ^" . "^ $4 ^ "]"}
  | LEFT_PAREN RIGHT_PAREN                    {"[]"}
  | HASH LEFT_PAREN RIGHT_PAREN               {"#[]"}
  | HASH LEFT_PAREN expressions RIGHT_PAREN   {"#[" ^ $3 ^ "]"} 
  | SYMBOL                                    {"'" ^ $1}
  | INT                                       {$1}
  | REAL                                      {$1}
  | CHAR                                      {"#\\(\"" ^ $1 ^ "\")"}
  | BOOL                                      {$1}
  | STRING                                    { "{" ^ $1 ^ "}"}
  | QUOTE expression                          {"$ " ^ $2}
  | QUASIQUOTE expression                     {"! " ^ $2}
  | UNQUOTE expression                        {"!! " ^ $2}
  | UNQUOTESPLICING expression                {"!@ " ^ $2}
  | ERROR                                     {print_string $1; raise Parse_error}   
  | LEFT_PAREN expressions EOF                  {match $1 with
                                                 (line, col) -> print_string 
                                                   ("Open parenthesis on line "^
                                                    (string_of_int line) ^ " at column " 
                                                    ^ (string_of_int col) ^
                                                    " is not closed\n");
                                                  raise Parse_error}
 
  | RIGHT_PAREN error                        {match $1 with
                                                 (line, col) -> print_string 
                                                   ("Too many close parentheses on line "^
                                                    (string_of_int line) ^ " at column " 
                                                    ^ (string_of_int col) ^
                                                    "\n");
                                                  raise Parse_error}
 
    ;

