#lang racket/base
;; #lang apcsp/pseudocode looks here. A two-part language name never reaches
;; main.rkt's reader submodule on its own.
(require (submod "../main.rkt" reader))
(provide (all-from-out (submod "../main.rkt" reader)))
