#lang pollen
◊title{An Example Image Function: three-squares}

I'm going to explain how to write a function that uses images on this page. Follow along in DrRacket and things should make sense. If you have any suggestions for how to make this better, let me know.

Here are some examples in the Interactions window of what we want the function ◊code{three-squares} to do:◊br{}
◊pict{imageFunctions/three-squares-examples.png}

As you can see from the examples, the function ◊code{three-squares} takes four arguments when you call it: a number and three colors. That means the function has four parameters. What it returns is a picture or image. We now have enough information to write the very first thing we should write when we're creating a function - the ◊strong{Signature}.

◊section{The Signature}

A signature tells DrRacket and anyone reading the code the following things:
◊ul{
  ◊li{the ◊em{name} of the function}
  ◊li{the ◊em{number and type} of the function's parameters}
  ◊li{the ◊em{return type} of the function, i.e., what kind of thing it gives you when you call it}
}
The way you write a signature looks like this:
◊prog{
(: <name-of-function> (<type of parameter 1> <type of parameter 2> ... -> <return type>))
}
All of the stuff in angle brackets (◊code{<>}) and the ◊code{...} are things you fill in. The rest is stuff you just have to type. In other words, every signature will have this shape:
◊prog{
(:     (       ->   ))
}
Those two sets of parentheses, the colon and the arrow (remember it's just minus plus greater than) will never change.

Now we're ready to write the signature for ◊code{three-squares}. Let's look at what we said the signature tells you and fill in what we know about ◊code{three-squares}:
◊ul{
◊li{the ◊em{name} of the function - ◊b{◊code{three-squares}}}
  ◊li{the ◊em{number and type} of the function's parameters - ◊b{one number and three colors}}
  ◊li{the ◊em{return type} of the function - ◊b{an image}}
}
If you just remember that the ◊em{types} have to be capitalized, you should see what we're going to put:
◊prog{
(: three-squares (Number Color Color Color -> Image))
}
We're ready for step 2, the ◊em{header}.

◊h2{The Header}

When we write the header, we just have to come up with names for the parameters we decided on in the signature. The header looks like this:
◊prog{
(define (<function-name> <name of parameter 1> <name of parameter 2> ...)
  ...)
}
