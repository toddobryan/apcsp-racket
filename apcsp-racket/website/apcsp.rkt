#lang racket
(require deinprogramm/signature/signature-syntax
         deinprogramm/signature/signature
         deinprogramm/signature/signature-english
         2htdp/image
         2htdp/universe
         lang/posn
         rackunit)

(print-boolean-long-form #f)
(abbreviate-cons-as-list #f)

(provide ε let Image Color
         Mode XPlace YPlace Angle PulledPoint
         SideCount StepCount Posn Pen PenStyle PenCap PenJoin
         (all-from-out 2htdp/image 2htdp/universe))

(define ε 0.000000000001)

(define (natural? x)
  (and (integer? x) (>= x 0)))

; deinprogramm/sdp/image.rkt
(define Image (signature Image (predicate image?)))
(define Color (signature Color (predicate image-color?)))
(define Mode (signature Mode (predicate mode?)))
(define YPlace (signature YPlace (predicate y-place?)))
(define XPlace (signature XPlace (predicate x-place?)))
(define Angle (signature Angle (predicate angle?)))
(define PulledPoint (signature PulledPoint (predicate pulled-point?)))
(define SideCount (signature SideCount (predicate side-count?)))
(define StepCount (signature StepCount (predicate step-count?)))
(define Posn (signature Posn (predicate real-valued-posn?)))
(define Pen (signature Pen (predicate pen?)))
(define PenStyle (signature PenStyle (predicate pen-style?)))
(define PenCap (signature PenCap (predicate pen-cap?)))
(define PenJoin (signature PenJoin (predicate pen-join?)))
; deinprogramm/sdp/universe.rkt
(define MouseEvent
    (signature MouseEvent
      (enum "button-down" "button-up" "drag" "move" "enter" "leave")))
  (define PadEvent
    (signature PadEvent
      (enum "left" "right" "up" "down" "w" "s" "a" "d" " " "shift" "rshift")))
