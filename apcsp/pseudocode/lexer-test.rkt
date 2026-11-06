#lang br
(require "lexer.rkt" brag/support rackunit)

(define-syntax check-srcloc=?
  (syntax-rules ()
    [(check-srcloc=? input (tok val line col pos span) ...)
     (check-equal? (lex input)
                   (list (srcloc-token (token tok val #:skip? (if (equal? tok 'WS) #t #f))
                                       (srcloc 'string line col pos span))
                         ...))]))

(define (lex str)
  (apply-port-proc ps-lexer str))

(define (check-sl=? input tok val line col pos span)
  (check-equal? (lex input)
                (list (srcloc-token (token tok val)
                                    (srcloc 'string line col pos span)))))

(define (ws tok val line col pos span)
  (srcloc-token (token tok val)
                (srcloc 'string line col pos span #:skip? #f)))

(check-equal? (lex "") empty)

(check-equal? (lex " ")
              (list (srcloc-token (token 'WS " " #:skip? #t)
                                  (srcloc 'string 1 0 1 1))))

(check-srcloc=? "\"abc\"" ('STRING "abc" 1 0 1 5))

(check-srcloc=? "a" ('ID 'a 1 0 1 1))

(check-srcloc=? "(a+b)"
                ('L-PAREN "(" 1 0 1 1)
                ('ID 'a 1 1 2 1)
                ('PLUS "+" 1 2 3 1)
                ('ID 'b 1 3 4 1)
                ('R-PAREN ")" 1 4 5 1))

(check-srcloc=? "(a + b)"
                ('L-PAREN "(" 1 0 1 1)
                ('ID 'a 1 1 2 1)
                ('WS " " 1 2 3 1)
                ('PLUS "+" 1 3 4 1)
                ('WS " " 1 4 5 1)
                ('ID 'b 1 5 6 1)
                ('R-PAREN ")" 1 6 7 1))


