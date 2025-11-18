#lang info
(define collection 'multi)

(define deps '("base"
               "compatibility-lib"
               "apcsp-signature"
               "errortrace-lib"
               "htdp-lib"
               "pconvert-lib"
               "scheme-lib"
               "simple-tree-text-markup-lib"
               "string-constants-lib"
               "trace"
               "gui-lib"
               "wxme-lib"
               "snip-lib"
               "draw-lib"))

(define build-deps '("at-exp-lib"
                     "racket-index"
                     "rackunit-lib"))

(define pkg-desc "Racket for AP Computer Science Principles")

(define implies '("apcsp-racket-signature"))

(define pkg-authors '(toddobryan))

(define license
  '(Apache-2.0 OR MIT))