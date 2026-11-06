#lang racket/base
;; The module language behind #lang apcsp/bsl: htdp/bsl plus private/extras.rkt.
;; Where the two export the same name, the extras win.
(require (except-in lang/htdp-beginner rational? integer? image? eof-object?)
         "private/extras.rkt")
(provide (all-from-out lang/htdp-beginner "private/extras.rkt"))
