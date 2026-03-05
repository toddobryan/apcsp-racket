#lang br/quicklang
(require data/gvector)

(provide (rename-out [ps-module-begin #%module-begin])
         (matching-identifiers-out #rx"^ps-" (all-defined-out)))

(struct Env (parent directory))

(define (get id environ)
  (if (not (in-hash-keys id))
)


(define-macro (ps-module-begin (ps-program STMT ...))
    #'(#%module-begin
       (define env (Env 'none (make-hash)))
       STMT ...
       ))

; ; TODO: this grabs all ids, including parameters. Need to avoid those.
; ; Also, would be nice to scope free variables to procedures.
; (begin-for-syntax
;   (require racket/list)
;   (define (find-unique-ids stmts)
;     (remove-duplicates
;      (for/list ([stx (in-list (stx-flatten stmts))]
;                 #:when (syntax-property stx 'ps-id))
;        stx)
;      #:key syntax->datum)))

(define-macro-cases ps-assignment
  [(ps-assignment (ps-list-ref ID NUM) EXPR) #'(gvector-set! (get ID env) (sub1 NUM) EXPR)]
  [(ps-assignment ID EXPR) #'(let ([expr-once EXPR])
                               (if (gvector? expr-once)
                                 (set! ID (vector->gvector (vector-copy (gvector->vector expr-once))))
                                 (set! ID expr-once)))])


(define (as-display-string expr)
  (cond
    [(boolean? expr) (if expr "true" "false")]
    [(gvector? expr) (string-join (map as-display-string (gvector->list expr))
                                 ", " #:before-first "[" #:after-last "]")]
    [else (format "~a" expr)]))

(define (ps-display expr)
  (let ([d (as-display-string expr)])
    (display (if (string-suffix? d "\n")
                 (format "~a" d)
                 (format "~a " d)))))

(define (ps-input)
  (read-line))

(define-macro (ps-if COND STMT ...)
  #'(if COND (begin STMT ...) (void)))

(define-macro (ps-if-else (ps-if COND IF-STMT ...) ELSE-STMT ...)
  #'(if COND (begin IF-STMT ...) (begin ELSE-STMT ...)))

(define-macro (ps-repeat NUM STMT ...)
  #'(for ([_ (in-range NUM)])
      STMT ...))

(define-macro (ps-repeat-until COND STMT ...)
  #'(do ()
      (COND)
      STMT ...))

(define-macro (ps-for-each ID LIST STMT ...)
  #'(for ([ID LIST])
      STMT ...))      

(define-macro (ps-proc-def NAME PARAM ... "{" STMT ...)
  (with-syntax ([ps-return (datum->syntax caller-stx 'ps-return)])
    #'(define (NAME PARAM ...)
        (let/ec ps-return
          STMT ... (void)))))

      
(define-macro (ps-proc-call ID ARG ...)
  #'(ID ARG ...))

(define-macro (ps-insert LIST NUM EXPR)
  #'(gvector-insert! LIST (sub1 NUM) EXPR))

(define-macro (ps-append LIST EXPR)
  #'(gvector-add! LIST EXPR))

(define-macro (ps-remove LIST EXPR)
  #'(gvector-remove! LIST (sub1 EXPR)))

(define (ps-or x y)
  (or x y))

(define (ps-and x y)
  (and x y))

(define (ps-eq x y)
  (equal? x y))

(define (ps-ne x y)
  (not (equal? x y)))

(define (ps-gt x y)
  (> x y))

(define (ps-lt x y)
  (< x y))

(define (ps-ge x y)
  (>= x y))

(define (ps-le x y)
  (<= x y))

(define (ps-add x y)
  (+ x y))

(define (ps-sub x y)
  (- x y))

(define (ps-mul x y)
  (* x y))

(define (ps-div num div)
  (if (or (not (number? num)) (not (number? div)))
      (error (format "division requires two numbers, given ~a and ~a" num div))
      (/ num div)))

(define (ps-mod num div)
  (if (or (not (integer? num)) (not (integer? div)))
      (error (format "MOD requires two integer arguments, given ~a and ~a" num div))
      (modulo num div)))

(define (ps-not expr)
  (if (not (boolean? expr))
      (error (format "NOT must be used with a boolean, given ~a" expr))
      (not expr)))
  
(define (ps-neg expr)
  (if (not (number? expr))
      (error ("negation requires a number, given ~a" expr))
      (* -1 expr)))

(define (ps-length expr)
  (if (not (gvector? expr))
      (error (format "LENGTH requires a list, given ~a" expr))
      (gvector-count expr)))

(define-macro (ps-list ELT ...)
  #'(gvector ELT ...))

(define (ps-list-ref id num)
  (if (or (not (gvector? id)) (not (integer? num)))
      (error (format "expected list and integer index, given ~a and ~a" id num))
      (gvector-ref id (sub1 num))))

(define (ps-boolean b)
  (string=? "true" b))

(define (ps-dir)
  (namespace-mapped-symbols))
