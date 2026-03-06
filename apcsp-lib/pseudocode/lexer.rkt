#lang br
(require brag/support)

(provide ps-lexer)

(define-lex-abbrev digit (char-set "0123456789"))
(define-lex-abbrev digits (:+ digit))
(define-lex-abbrev lower-letter (char-set "abcdefghijklmnopqrstuvwxyz"))
(define-lex-abbrev upper-letter (char-set "ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(define ps-lexer
  (lexer-srcloc
   ["\n" (token 'NEWLINE lexeme)]
   [whitespace (token 'WS lexeme #:skip? #t)]
   [(from/to "//" "\n") (token 'COMMENT lexeme)] 
   [(from/to "\"" "\"")
    (token 'STRING (unescape-string lexeme))]
   ["true" (token 'TRUE lexeme)]
   ["false" (token 'FALSE lexeme)]
   [(:or "<-" "←") (token 'ASSIGN lexeme)]
   ["(" (token 'L-PAREN lexeme)]
   [")" (token 'R-PAREN lexeme)]
   ["{" (token 'L-BRACE lexeme)]
   ["}" (token 'R-BRACE lexeme)]
   ["[" (token 'L-BRACK lexeme)]
   ["]" (token 'R-BRACK lexeme)]
   [(:or "/=" "≠") (token 'NE lexeme)]
   [(:or "<=" "≤") (token 'LE lexeme)] 
   [(:or ">=" "≥") (token 'GE lexeme)]
   ["+" (token 'PLUS lexeme)]
   ["-" (token 'MINUS lexeme)]
   ["*" (token 'MUL lexeme)]
   ["/" (token 'DIV lexeme)]
   ["=" (token 'EQ lexeme)]
   [">" (token 'GT lexeme)]
   ["<" (token 'LT lexeme)]
   ["," (token 'COMMA lexeme)]
   [(:or "DISPLAY" "INPUT" "MOD" "RANDOM"
          "NOT" "AND" "OR"
          "IF" "ELSE"
          "REPEAT" "TIMES" "UNTIL"
          "REMOVE" "FOR" "EACH" "IN"
          "LENGTH" "INSERT" "APPEND" "REMOVE"
          "PROCEDURE" "RETURN"
          "DIR")
    (token lexeme lexeme)]
   [(:seq (:? "-") digits) (token 'INTEGER (string->number lexeme))]
   [(:seq (:? "-")
          (:or (:seq (:? digits) "." digits)
               (:seq digits ".")))
    (token 'DECIMAL (string->number lexeme))]
   [(:seq lower-letter (:* (:or lower-letter upper-letter digit)))
    (token 'ID (string->symbol lexeme))]))

(define (unescape-string s)
  (string-replace (substring s 1 (sub1 (string-length s)))
                  "\\n"
                  "\n"))
