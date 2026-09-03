#lang racket
(define (signature-print sig port mode)
  (let* ([inputs (string-join (map symbol->string (signature-inputs sig))
                             #:before-first "(" #:after-last " -> ")]
         [str (string-join "(: " 
    
    (write "(: " port)
    (write (signature-name sig) port)
    (write " " port)
    (write (string-join (map symbol->string (signature-inputs sig)) #:before-first "(" #:after-last " -> ") port) 
    (write (signature-output sig) port)
    (write "))" port))


(struct signature (name inputs output)
  #:transparent
  #:methods gen:custom-write
  [(define write-proc signature-print)])

(define func (signature 'func '(Number Boolean) 'Number))