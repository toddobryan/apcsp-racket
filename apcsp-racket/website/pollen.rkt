#lang racket/base
(require pollen/decode pollen/misc/tutorial txexpr)
(provide (all-defined-out))

(define (title . elements)
  (txexpr 'h2 empty elements))

(define (section . elements)
  (txexpr 'div '((class "section-header")) elements))

(define (subsection . elements)
  (txexpr 'div '((class "subsection-header")) elements))

(define (screen . elements)
  (txexpr 'span '((class "screen")) elements))

(define (prog . elements)
  `(pre ,@elements))

(define (pict src)
  (txexpr 'img (list (list 'src src)) empty))

(define (math elements)
  (txexpr 'span '((class "math")) (list (string-append "\\(" elements "\\)"))))

(define (MATH elements)
  (txexpr 'div '((class "math")) (list (string-append "\\[" elements "\\]"))))
  
(define (root . elements)
  (txexpr 
    'root
    empty
    (decode-elements
      elements
      #:exclude-tags '(pre code)
      #:txexpr-elements-proc 
        (λ (elts)
          (decode-paragraphs 
            elts
            #:linebreak-proc
              (λ (lns)
                (decode-linebreaks lns " "))))
            #:string-proc (compose1 smart-quotes smart-dashes))))

(module setup racket/base
    (require pollen/setup)
    (provide extra-path?)

    
    (define pubdir (build-path (find-system-path 'home-dir) default-publish-directory))

    (define to-publish 
      (map 
        (λ (f) (build-path pubdir f))
        '(
          "apcsp.rkt"
        )))

  
    (define (extra-path? p)
      (member p to-publish)))
