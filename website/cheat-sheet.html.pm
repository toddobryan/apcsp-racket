#lang pollen
◊title{The Racket Cheat Sheet}

This should include everything you need to program your assignnments
in Racket. Remember, I don't need you to ◊strong{memorize} the programming
language, but understand how it works. If you need to look back at this 
page, that's fine. Once you've used something enough times, you'll
have it memorized. And if you don't use something enough to memorize it,
don't worry about it.

◊ol{
  ◊li{◊a[#:href "#numbers"]{Numbers}}
  ◊li{◊a[#:href "#arithmetic"]{Arithmetic and Numbers}}
  ◊li{◊a[#:href "#functions"]{Defining Functions}}
}

◊h2[#:id "#numbers"]{Numbers}

Racket handles more kinds of numbers more easily than most programming
languages. Each number type is explained with its signature, and 
the predicate that you can use to check if something is that kind
of number.

Note that every kind of number is also every type that's listed after it.
In other words, a ◊code{Natural} is an ◊code{Integer}; an ◊code{Integer} is
a ◊code{Rational}; a ◊code{Rational} is a ◊code{Real}; and a ◊code{Real}
is a ◊code{Number}.

◊h3{Natural}

The signature ◊code{Natural} is valid for the numbers 0, 1, 2, ...

To test if an expression will satisfy the signature ◊code{Natural}, use:
◊prog{
(: natural? (Any -> Boolean))
; given a value, produces #t if it's one of 0, 1, 2, ...
> (natural? 27)
#t
> (natural? -1)
#f
}

◊h3{Integer}

The signature ◊code{Integer} is valid for the numbers ..., -2, -1, 0,
1, 2, ...

In other words, all whole numbers without fractional parts, both positive
and negative, satisfy the signature ◊code{Integer}.

To test if an expression satisfies the signature ◊code{Integer}, use:
◊prog{
(: integer? (Any -> Boolean))
; given a value, returns #t if it is one of ..., -2, -1, 0, 1, 2, ...
> (integer? (- 5 10))
#t
> (integer? (/ 5 10))
#f
}

◊h3{Rational}

The signature ◊code{Rational} is valid for any number that can be
represented as ◊math{\pm m/n}, where ◊math{m} and ◊math{n} are both
natural numbers (and ◊math{n} is not zero) -- in other words, fractions.

The only rules for writing rational numbers is that you can't have space
in the number, and if the number is negative, the minus sign has to be
the first character. ◊code{-1/3} is fine, ◊code{1/-3} is ◊emph{not}. Note
that all terminating decimals are rational numbers, because you can write
them as a number over a power of ten. For example, ◊code{3.14} is the same
as ◊code{314/100}.

To check if an expression would satisfy the ◊code{Rational} signature, use:
◊prog{
(: rational? (Any -> Boolean))
; given a value, produces #t if it is an exact number that
; can be expressed as a fraction
> (rational? 1/2)
#t
> (rational? (/ 1 3))
#t
> (rational 4.567)
#t
> (rational (sqrt 2))
#f
> (rational (sqrt 9))
#t
}

◊h3{Real}

The signature ◊code{Real} is valid for any number that doesn't include an imaginary part. This includes all rational numbers, as well as irrational numbers like ◊math{\sqrt{2}} and ◊math{\pi}. If you've required ◊code{"apcsp.rkt"}, any inexact number is
considered ◊code{Real}. To check if an expression would satisfy the ◊code{Real}
signature, use:
◊prog{
(: real? (Any -> Boolean))
; given a value, produces #t if it is a number that doesn't include an imaginary part
> (real? 1/2)
#t
> (real? (sqrt 2))
#t
> (real? (sqrt -1))
#f
}

◊h3{Number}
The signature ◊code{Number} is valid for any number, including complex numbers. To check if an expression would satisfy the ◊code{Number} signature, use:
◊prog{
(: number? (Any -> Boolean))
; given a value, produces #t if it is a number
> (number? 1/2)
#t
> (number? (sqrt 2))
#t
> (number? (sqrt -1))
#t
> (number? "not a number")
#f
}

◊h2[#:id "#arithmetic"]{Arithmetic and Numbers}

Remember that Racket uses ◊em{parenthesized prefix notation}. Every
mathematical operator goes after an open-parenthesis and its arguments
follow the operator until you get to the closing parenthesis. Each argument
could be its own expression.

In the signatures below, ◊code{...} means "plus zero or more of the
previous kind of argument".

The signatures for the ◊strong{operators} you should know are:

◊prog{
(: + (Number Number ... -> Number))
; given two or more numbers, produces their sum
(define (+ x1 x2 ...)
> (+ 2 3 -1)
5

(: - (Number ... -> Number))
; given one number, multiplies it by -1
(define (- x1 ...)
> (- 5)
-5
; given two or more numbers, subtracts the second from the first,
; then substracts the third from that, and so on
> (- 8 4 2 1)
1

(: * (Number Number ... -> Number))
; given two or more numbers, multiplies them
(define (* x1 x2 ...)
> (* 2 5 6 1/2)
30

(: / (Number Number ... -> ))
; given two or more numbers, divides the first by the second,
; then divides that by the third, and so on
(define (/ x1 x2 ...)
> (/ 60 5 3)
4

(: expt (Number Number -> Number))
; given a base and power, raises the base to the power
(define (expt base power)
> (expt 2 3)
8
}

The signatures for the ◊strong{relations} you should know are:

◊prog{
(: = (Number Number ... -> Boolean))
; given two or more numbers, produces #t if
; they are all equal
> (= 2 (sqrt 4) (/ 6 3))
#t
> (= 2 (sqrt -4))
#f

(: < (Real Real ... -> Boolean))
; given two or more numbers, produces #t if each
; is less than the next, #f otherwise
> (< 1 2 3)
#t
> (< 1 1 1)
#f

(: <= (Real Real ... -> Boolean))
; given two or more numbers, produces #t if each
; is less than or equal to the next, #f otherwise
> (< 1 2 3)
#t
> (< 1 1 1)
#t

(: > (Real Real ... -> Boolean))
; given two or more numbers, produces #t if each
; is greater than the next, #f otherwise
> (< 3 1 2)
#f
> (< 3 2 1)
#t

(: >= (Real Real ... -> Boolean))
; given two or more numbers, produces #t if each
; is greater than or equal to the next, #f otherwise
> (< 3 1 2)
#f
> (< 3 2 2)
#t
}
