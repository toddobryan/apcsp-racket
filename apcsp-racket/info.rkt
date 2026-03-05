#lang info
(define collection 'multi)

(define deps '("base"
               "apcsp-lib"
               "apcsp-doc"
               "apcsp-test"))

(define implies '("apcsp-lib"
                  "apcsp-doc"
                  "apcsp-test"))


(define pkg-desc "Racket for AP Computer Science Principles")

(define pkg-authors '(toddobryan))

(define license '(Apache-2.0 OR MIT))
