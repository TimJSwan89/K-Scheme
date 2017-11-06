{
    open Scheme_parser

    let update_position lex_buf =
        let pos = lex_buf.Lexing.lex_curr_p in
           lex_buf.Lexing.lex_curr_p 
               <- { pos with 
                      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
                      Lexing.pos_bol = pos.Lexing.pos_cnum} ;;
}

(***
 *** syntax non-terminal names stolen from R5RS
 ***)
let digit = ['0'-'9']


let letter = ['a'-'z''A'-'Z'] 
let special_initial = '!' | '$' | '%' 
                       | '&' | '*' | '/' 
                       | ':' | '<' | '=' 
                       | '>' | '?' | '^' 
                       | '_' | '~' 
let initial = letter | special_initial
let peculiar_identifier = '+' | '-' | "..."
let special_subsequent  = '+' | '-' | '.' | '@'
let subsequent = initial | digit | special_subsequent    
let identifier = initial subsequent* | peculiar_identifier
     

rule tokens = parse
   (' ' | '\t')               {tokens lexbuf}
 | '\n'                       {update_position lexbuf; tokens lexbuf}
 | "SEARCH"                   {SEARCH}
 | ("#t" | "#f") as b         {BOOL(b)}
 | ("#\\") (_ as c)           {let str = " " in str.[0] <- c; CHAR(str)}
 | digit+ as num              {INT(num)}
 | (digit+ '.' digit*) as num {REAL(num)}
 | identifier as sym          {SYMBOL(sym)}
 | ('"' [^'\n']* '"') as str  {STRING(str)}
 | '.'                        {DOT}
 | ('(' | '[')                {let pos = lexbuf.Lexing.lex_curr_p in
                               LEFT_PAREN(
                                           pos.Lexing.pos_lnum, 
                                           (pos.Lexing.pos_cnum -
                                           pos.Lexing.pos_bol)
                                         )}
 | (')' | ']')                {let pos = lexbuf.Lexing.lex_curr_p in
                               RIGHT_PAREN(
                                           pos.Lexing.pos_lnum, 
                                           (pos.Lexing.pos_cnum -
                                           pos.Lexing.pos_bol)
                                         )}

 | '#'                        {HASH}
 | eof                        {EOF}
 | "'"                        {QUOTE}
 | "`"                        {QUASIQUOTE}
 | ","                        {UNQUOTE}
 | ",@"                       {UNQUOTESPLICING}
 | ";;;"                      {comments lexbuf}
 (***
  *** ridiculously convoluted error handling
  ***)
 | _ as error                {let pos = lexbuf.Lexing.lex_curr_p in
                              let tmp = "unexpected symbol: 'q'" in
                                tmp.[(String.length tmp) - 2] <- error;
                                ERROR(tmp ^ " at line " ^
                                (string_of_int pos.Lexing.pos_lnum)^
                                " and column "^ (string_of_int 
                                (pos.Lexing.pos_cnum - pos.Lexing.pos_bol) ^ "\n"))}
and comments = parse
 '\n'                       {update_position lexbuf ; tokens lexbuf}
 | eof                      {EOF}
 | _                        {comments lexbuf}

{
  let _ = 
      let lb = Lexing.from_channel (open_in Sys.argv.(1)) in
         try
           print_string ((Scheme_parser.main tokens lb) ^ "\n" )
         with _ -> exit 1
         
 }
 
