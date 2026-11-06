#lang br
(require "lexer.rkt" brag/support)
(provide ps-color)

(define (ps-color port)
  (define (handle-lexer-error excn)
    (define excn-srclocs (exn:fail:read-srclocs excn))
    (srcloc-token (token 'ERROR) (car excn-srclocs)))
  (define srcloc-tok
    (with-handlers ([exn:fail:read? handle-lexer-error])
      (ps-lexer port)))
  (match srcloc-tok
    [(? eof-object?) (values srcloc-tok 'eof #f #f #f)]
    [else
     (match-define
       (srcloc-token
        (token-struct type val _ _ _ _ _)
        (srcloc _ _ _ posn span)) srcloc-tok)
     (define start posn)
     (define end (+ start span))
     (match-define (list cat paren)
       (match type
         ['STRING '(string #f)]
         ['ID '(symbol #f)]
         ['COMMENT '(sexp-comment #f)]
         ['ASSIGN '(no-color #f)]
         [(or 'TRUE 'FALSE) '(constant #f)]
         [(or 'PLUS 'MINUS 'TIMES 'DIV 'AND 'OR 'NOT) '(hash-colon-keyword #f)]
         [(or 'NE 'LE 'GE 'EQ 'GT 'LT) '(comment #f)]
         [else (match val
                 [(? number?) '(constant #f)]
                 ["(" '(parenthesis |(|)]
                 [")" '(parenthesis |)|)]
                 ["{" '(parenthesis |(|)]
                 ["}" '(parenthesis |)|)]
                 ["[" '(parenthesis |(|)]
                 ["]" '(parenthesis |)|)]
                 [else '(no-color #f)])]))
     (values val cat paren start end)]))