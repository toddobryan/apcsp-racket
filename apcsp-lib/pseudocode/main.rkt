#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module apscp-module-expander apcsp-pseudocode/expander
       #,parse-tree)))

(module+ reader
  (provide read-syntax get-info)

  (define (get-info port src-mod src-line src-col src-pos)
    (define (handle-query key default)
      (case key
        [(color-lexer) (dynamic-require 'apcsp-pseudocode/colorer 'ps-color)]
        [(drracket:indentation) (dynamic-require 'apcsp-pseudocode/indenter 'ps-indent)]
        #;[(drracket:toolbar-buttons) (dynamic-require 'apcsp-pseudocode/buttons 'button-list)]
        [else default]))
    handle-query))

