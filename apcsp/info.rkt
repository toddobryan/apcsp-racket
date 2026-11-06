#lang info
(define collection "apcsp")
(define version "0.3")
(define pkg-desc "Racket languages for AP Computer Science Principles")
(define pkg-authors '(toddobryan))
(define license 'MIT)
(define scribblings '(("pseudocode/scribblings/apcsp-pseudocode.scrbl")))
(define deps '("base"
               "beautiful-racket-lib"
               "brag-lib"
               "data-lib"
               "deinprogramm-signature"
               "gui-lib"
               "htdp-lib"
               "pconvert-lib"
               "rackunit-lib"))
(define build-deps '("racket-doc"
                     "scribble-lib"))
