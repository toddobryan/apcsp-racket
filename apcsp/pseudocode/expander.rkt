#lang br
(require data/gvector)

(provide #%app #%datum #%top-interaction
         (rename-out [ps-module-begin #%module-begin]
                     [ps-top #%top])
         (matching-identifiers-out #rx"^ps-" (all-defined-out)))

; Variables live in a chain of environments rather than in Racket bindings. The
; language exports almost no names, so a variable read is an unbound identifier
; and arrives at ps-top, which looks it up here.
;
; Only procedures create environments: a call gets a new one whose parent is the
; environment the procedure was defined in. Blocks ({ } after IF, REPEAT and
; FOR EACH) run in the surrounding environment.
(struct Env (parent directory))

(define (make-env [parent #f])
  (Env parent (make-hasheq)))

(define current-env (make-parameter (make-env)))

; The nearest environment, starting from environ, that has id; #f if none does.
(define (find-env id environ)
  (cond
    [(not environ) #f]
    [(hash-has-key? (Env-directory environ) id) environ]
    [else (find-env id (Env-parent environ))]))

(define (get id environ)
  (define owner (find-env id environ))
  (if owner
      (hash-ref (Env-directory owner) id)
      (error id "this variable doesn't have a value yet")))

; Creates id in exactly this environment, shadowing any outer id.
(define (create! id val environ)
  (hash-set! (Env-directory environ) id val))

; Updates id where it already exists, or creates it in environ if it doesn't.
(define (assign! id val environ)
  (create! id val (or (find-env id environ) environ)))

(define-macro (ps-top . ID)
  #'(get 'ID (current-env)))

(define-macro (ps-module-begin (ps-program STMT ...))
    #'(#%module-begin
       STMT ...
       ))

(define-macro-cases ps-assignment
  [(ps-assignment (ps-list-ref ID NUM) EXPR) #'(gvector-set! ID (sub1 NUM) EXPR)]
  [(ps-assignment ID EXPR) #'(let ([expr-once EXPR])
                               (assign! 'ID
                                        (if (gvector? expr-once)
                                            (vector->gvector (vector-copy (gvector->vector expr-once)))
                                            expr-once)
                                        (current-env)))])


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
  #'(for ([item LIST])
      (assign! 'ID item (current-env))
      STMT ...))

; ARG ... are fresh names, so that PARAM ... stay out of Racket's scope and reads
; of them go through ps-top like any other variable.
(define-macro (ps-proc-def NAME PARAM ... "{" STMT ...)
  (with-syntax ([ps-return (datum->syntax caller-stx 'ps-return)]
                [(ARG ...) (generate-temporaries #'(PARAM ...))])
    #'(let ([defining-env (current-env)])
        (create! 'NAME
                 (procedure-rename
                  (lambda (ARG ...)
                    (parameterize ([current-env (make-env defining-env)])
                      (create! 'PARAM ARG (current-env)) ...
                      (let/ec ps-return
                        STMT ... (void))))
                  'NAME)
                 defining-env))))

; Inside a procedure, ps-proc-def binds ps-return to an escape continuation.
(define (ps-return value)
  (error "RETURN can only be used inside a PROCEDURE"))

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
      (error (format "negation requires a number, given ~a" expr))
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
  (let visible-names ([environ (current-env)] [names '()])
    (if environ
        (visible-names (Env-parent environ)
                       (append (hash-keys (Env-directory environ)) names))
        (sort (remove-duplicates names) symbol<?))))
