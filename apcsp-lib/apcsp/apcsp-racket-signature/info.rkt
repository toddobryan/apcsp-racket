#lang info

(define collection 'multi)

(define deps '("base"
               "compatibility-lib"
               "drracket-plugin-lib"
               "gui-lib"
               "htdp-lib"
               "scheme-lib"
               "srfi-lib"
               "string-constants-lib"))

(define pkg-desc "Signature support for AP Computer Science Principles Racket libraries")

(define pkg-authors '(toddobryan))

(define license
  '(Apache-2.0 OR MIT))