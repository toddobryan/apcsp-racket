#lang pollen
◊title{Arithmetic, Functions, and Animations}

◊section{Part A. Racket Math}

For each math expression below, translate it to Racket.
◊ul{
◊li{Add parentheses to indicate the order that the operations would be done.}
◊li{Convert the expression to Racket.}
◊li{Figure out what the value should be and write a test case to check that
you translated correctly.}}

Example:

Expression: ◊math{3 + 2\cdot 5^{2}}◊br{}
With Parentheses: ◊math{(3 + (2\cdot (5^{2})))}◊br{}
In Racket: ◊code{(+ 3 (* 2 (expt 5 2)))}◊br{}
Test Case: ◊code{(check-expect (+ 3 (* 2 (expt 5 2))) 53)}◊br{}

You just need to write the Test Case line, but make sure it's right!

◊ol{
◊li{◊math{3\cdot 2^3-7}}
◊li{◊math{5^2\cdot 3 - 5\cdot 10}}
◊li{◊math{10\div 2\cdot 4 + 6}}
◊li{◊math{(4 + 5) - (3\cdot 7) + 2}}
◊li{◊math{(3 + 2) \cdot 7 - (15 \div 3) + 6^{1 + 1}}}}

◊section{Part B. Functions}

For each function defined below, create a T-chart for the domain values -2, -1, 0, 1, and 2.
(You can put the function and chart in a comment between ◊code{#|} and ◊code{|#}.) Then
write the function and five test cases to make sure you translated it correctly.

For example, if the problem were ◊math{f(x) = 3x^2 - 1}, you would write:
◊prog{
#|
f(x) = 3x^2 - 1
 x  | f(x)
----+------
 -2 | 11
 -1 | 2
 0  | -1
 1  | 2
 2  | 11
|#

(define (f x)
  (- (* 3 (expt x 2)) 1))

(check-expect (f -2) 11)
(check-expect (f -1) 2)
(check-expect (f 0) -1)
(check-expect (f 1) 2)
(check-expect (f 2) 11)
}

◊ol{
◊li{◊math{g(x) = 2x - 4}}
◊li{◊math{d(x) = x^2}}
◊li{◊math{s(k) = k^2 - k + 3}}
◊li{◊math{h(z) = 2z^3 - z^2 + z - 4}}
◊li{◊math{p(n) = \frac{n(n + 1)}{2}}}}

◊section{Part C. Animations}

Here's the starter code for animating a circle.
◊prog{
(define (circle-pic t)
  (place-image (circle 20 "solid" "yellow")
               t 100
               (empty-scene 200 200)))

(animate circle-pic)
}
This makes a yellow circle move from left to right in the middle
of a 200 pixel by 200 pixel scene. For each description below,
change the function so that the animation changes as described.

You can just name each function with its number: ◊code{circle-pic-1},
◊code{circle-pic-2}, etc. Don't forget to add the right number in
the animate function or nothing will change.

◊ol{
◊li{Change the color of the circle.}
◊li{Make the circle have a radius of 50 instead of 20.}
◊li{Make the circle go across the middle of a 500x500 pixel scene.}
◊li{Make the circle go down the middle of the scene.}
◊li{Make the circle start at the top right and go down to the bottom left.}
◊li{Change the animation in some way that seems cool to you.}}

