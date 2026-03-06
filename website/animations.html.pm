#lang pollen
◊title{Animations (What in the World?)}

◊section{Animations}

As you probably know, animation is created by showing your eyes and brain
images one after another. Your brain infers that each image has smoothly
turned into the next one, and you perceive motion.

The same thing happens on a computer screen. If we can draw a bunch of images
one after another, we can make our brains see motion.

◊section{Image Functions}

There are two functions that are really useful for creating animations. They
are:

◊prog{
;; empty-scene: number number -> image
;; creates an empty white rectangle
;;   x pixels wide by y pixels tall
(define (empty-scene x y)
  ...)

;; place-image: image number number image -> image
;; creates a new image by placing img1 at the location
;;   x, y in img2 (note: 0, 0 is in the top left corner
;;   and gets bigger to the right and DOWN--not up like
;;   in math)
(define (place-image img1 x y img2)
  ...)
}

Make sure you have
◊prog{
#lang htdp/bsl
(require picturing-programs)
}
at the top of the definitions window and have hit Run.

Type this in the interactions window and hit enter.
◊prog{
(place-image (circle 10 "solid" "green") 50 75 (empty-scene 100 150))
}

You should see a green circle in the middle of a 100x150 pixel frame.

Press ◊screen{Esc}, then ◊screen{P} to make the previous line (get it, P)
appear again. Change the numbers. What happens if you put in a small
negative number for `x` or `y`? Remember the `y` value gets bigger as you
go ◊em{down} in graphics, not up (like in math).

Now let's do some animating.

◊section{World}

Imagine you want to draw a picture as part of an animation. You'd need
to know what to draw and where to draw it. In a video game or a Pixar
movie, the `world` you need to draw could be really complicated--characters,
outfits, accessories, which way things are facing--all kinds of stuff.

But imagine a game of Pong. You only need to know where the ball and the
paddles are. If you wanted to draw the scores, you'd need to know that, but
not much else.

For our animations, we're going to start with a ◊em{really} simple world.
Our world is going to be a number. It's going to start at `0` and get
bigger by one each time the world changes. You could think of this as
just numbering the pictures in the animation. 0, 1, 2, 3, ... until
we stop.

◊subsection{A Counter}

Let's write a function that displays a number in the middle of a blank
rectangle.

We'll call our function `draw-num`. We'll define it like this:


