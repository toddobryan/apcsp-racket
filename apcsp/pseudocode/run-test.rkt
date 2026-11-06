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

(test-case "a variable that is never assigned is still an error"
  (check-exn #rx"unbound identifier" (lambda () (run "DISPLAY(nope)"))))
