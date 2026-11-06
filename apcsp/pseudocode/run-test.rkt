#lang racket/base
;; End-to-end tests: run a whole pseudocode program and check what it displays.
(require racket/port racket/string rackunit)

(define (run . lines)
  (define source
    (string-append "#lang apcsp/pseudocode\n" (string-join lines "\n") "\n"))
  (define ns (make-base-namespace))
  (string-trim
   (with-output-to-string
     (lambda ()
       (parameterize ([current-namespace ns]
                      [read-accept-reader #t]
                      [read-accept-lang #t])
         (eval (read-syntax 'program (open-input-string source)))
         (dynamic-require ''apscp-module-expander #f))))))

(test-case "assignment"
  (check-equal? (run "x ← 5" "DISPLAY(x)") "5")
  (check-equal? (run "x <- 5" "x ← x + 1" "DISPLAY(x)") "6"))

(test-case "lists"
  (check-equal? (run "myList ← [\"a\", \"b\", \"c\"]" "DISPLAY(myList[2])") "b")
  (check-equal? (run "a ← [1, 2]" "a[1] ← 9" "DISPLAY(a)") "[9, 2]"))

(test-case "assigning a list copies it"
  (check-equal? (run "a ← [1]" "b ← a" "b[1] ← 2" "DISPLAY(a)") "[1]"))

(test-case "assignment inside blocks"
  (check-equal? (run "x ← 0" "REPEAT 3 TIMES {" "x ← x + 2" "}" "DISPLAY(x)") "6")
  (check-equal? (run "IF (true) {" "y ← 1" "}" "DISPLAY(y)") "1"))

(test-case "procedures"
  (check-equal? (run "PROCEDURE f(n) {" "n ← n + 1" "RETURN(n)" "}" "DISPLAY(f(1))") "2")
  (check-equal? (run "n ← 7" "PROCEDURE f(n) {" "n ← 1" "}" "f(2)" "DISPLAY(n)") "7")
  (check-equal? (run "t ← 0" "PROCEDURE add(k) {" "t ← t + k" "}" "add(4)" "DISPLAY(t)") "4"))

(test-case "a variable created in a procedure is local to that call"
  (check-exn #rx"z: this variable doesn't have a value yet"
             (lambda () (run "PROCEDURE f() {" "z ← 1" "}" "f()" "DISPLAY(z)")))
  (check-equal? (run "PROCEDURE f() {" "z ← 1" "RETURN(z)" "}" "DISPLAY(f())") "1"))

(test-case "each call gets its own environment"
  (check-equal? (run "PROCEDURE fact(n) {"
                     "IF (n = 0) {"
                     "RETURN(1)"
                     "}"
                     "r ← fact(n - 1)"
                     "RETURN(n * r)"
                     "}"
                     "DISPLAY(fact(5))")
                "120"))

(test-case "procedures see where they were defined, not where they were called"
  (check-equal? (run "x ← 1"
                     "PROCEDURE g() {"
                     "RETURN(x)"
                     "}"
                     "PROCEDURE f(x) {"
                     "RETURN(g())"
                     "}"
                     "DISPLAY(f(2))")
                "1"))

(test-case "a procedure defined inside a procedure is local to it"
  (check-equal? (run "PROCEDURE f(a) {"
                     "PROCEDURE g() {"
                     "a ← a + 1"
                     "}"
                     "g()"
                     "RETURN(a)"
                     "}"
                     "DISPLAY(f(1))")
                "2")
  (check-exn #rx"g: this variable"
             (lambda () (run "PROCEDURE f() {" "PROCEDURE g() {" "}" "}" "f()" "g()"))))

(test-case "blocks do not create environments"
  (check-equal? (run "FOR EACH item IN [1, 2] {" "last ← item" "}" "DISPLAY(last)") "2"))

(test-case "reading a variable before it is assigned is an error"
  (check-exn #rx"nope: this variable" (lambda () (run "DISPLAY(nope)")))
  (check-exn #rx"x: this variable" (lambda () (run "DISPLAY(x)" "x ← 1"))))

(test-case "DIR lists the variables in scope"
  (check-equal? (run "b ← 1" "a ← 2" "PROCEDURE f(c) {" "d ← 3" "}" "f(1)" "DIR")
                "'(a b f)"))

(test-case "RETURN outside a procedure"
  (check-exn #rx"RETURN can only be used inside a PROCEDURE"
             (lambda () (run "RETURN(1)"))))

(test-case "calling a procedure with the wrong number of arguments"
  (check-exn #rx"f: arity mismatch"
             (lambda () (run "PROCEDURE f(a) {" "}" "f(1, 2)"))))
