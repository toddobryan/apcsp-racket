#lang br
(require br/indent racket/contract racket/gui/base)

(define indent-width 4)
(define (left-bracket? c) (member c (list #\{ #\[)))
(define (right-bracket? c) (member c (list #\} #\])))

(define (ps-indent tbox [posn 0])
  (define prev-line (previous-line tbox posn))
  (define current-line (line tbox posn))
  (cond
    [(not prev-line) 0]
    [else
     (define prev-indent (or (line-indent tbox prev-line) 0))
     (cond
       [(left-bracket? (line-last-visible-char tbox prev-line))
        (+ prev-indent indent-width)]
       [(right-bracket? (line-first-visible-char tbox current-line))
        (- prev-indent indent-width)]
       [else prev-indent])]))

(provide
 (contract-out
  [ps-indent
   (((is-a?/c text%))
    (exact-nonnegative-integer?) . ->* . exact-nonnegative-integer?)]))
