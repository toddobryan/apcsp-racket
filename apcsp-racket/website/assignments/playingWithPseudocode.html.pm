#lang pollen
◊title{Playing with Pseudocode}

I've created a way for you to practice with pseudocode.

Open DrRacket. It looks like ◊pict{drracket.png} in the bottom menu bar.

Once it's open, type

◊code{#lang apcsp-pseudocode}

on the top line of the top window and hit the Run button near the top-right of the window.

Now you can type in pseudocode and run it. (Make sure you leave the ◊code{#} line at the top, though.)

There are a couple of differences between real pseudocode and this.

◊ul{
◊li{You can type the weird symbols in Pseudocode that aren't on the keyboard by typing a backslash,
an abbreviation, and then hitting ◊screen{Alt + \} at the end. The abbreviations are:
◊ul{
◊li{◊code{\geq} is ≥, but you can also write ◊code{>=}}
◊li{◊code{\leq} is ≤, but you can also write ◊code{<=}}
◊li{◊code{\neq} is ≠, but you can also write ◊code{/=}}
◊li{◊code{\leftarrow} is ←, but you can also write ◊code{<-}}}}

◊li{you can use ◊code{\n} in a string to jump to the next line. If your ◊code{DISPLAY} string ends in ◊code{\n}, there
won't be a space at the beginning of the next line.}

◊li{you can comment a line (or part of a line) by putting ◊code{// } before the part you want to comment.}
}

Note: the pseudocode doesn't care about blank lines, so you should probably put a line or two
between each problem. You can put ◊code{DISPLAY("\n")} to skip a line in your code to separate
the output. ◊code{DISPLAY("\n\n")} would skip two lines.



◊ol{
◊li{Type the code below and see what it prints out.

◊prog{
a <- 17
b <- "xyz"
DISPLAY(b)
DISPLAY(a)
}}

◊li{
Using a ◊code{REPEAT ◊i{n} TIMES} loop, print this:

◊prog{
BEAT MALE
BEAT MALE
BEAT MALE
BEAT MALE
BEAT MALE
BEAT MALE
BEAT MALE
}}

◊li{Write a program that asks for someone's name and age and prints out

◊prog{
Hello, ◊em{<their name>}
You're ◊em{<their age>} years old.
}

So, your whole program should do something like

◊prog{
What's your name? Taylor Swift
How old are you? 35

Hello, Taylor Swift
You're 35 years old.
}}

◊li{Finish this procedure that takes a list parameter and prints each element of the list on a separate line.

◊prog{PROCEDURE printEach(myList)
{
  ◊em{<your code here>}
}
printEach(["a", 5, true])
printEach([3, 2, 1, "blastoff"])}

should print

◊prog{a
5
true
3
2
1
blastoff}

once you've filled in your code.}

◊li{Write one ◊code{REPEAT UNTIL(◊em{condition})} loop for each line below that prints:
◊ol[#:type "a"]{
 ◊li{◊code{1 2 3 4 5}}
 ◊li{◊code{1 3 5 7 9 11 13 15 17 19 21}}
 ◊li{◊code{5 10 15 20}}
 ◊li{◊code{3 7 11 15 19 23}}
 ◊li{◊code{1 3 6 10 15}◊br{}
(You'll need two variables for this one.)}
 ◊li{◊code{0 1 1 2 3 5 8 13 21 34 55 89}◊br{}
(This is a challenge problem. You'll need at least two variables for this one.)}}}

◊li{Finish this procedure. It should return the ticket price to a movie based
on a person's age: under 13 = $10, 13-54 = $15, 55 and over = $12

◊prog{PROCEDURE ticketPrice(age)
{
  ◊em{<your code here, use RETURN>}
}
DISPLAY(ticketPrice(10))
DISPLAY(ticketPrice(16))
DISPLAY(ticketPrice(72))}

should print

◊prog{10 15 12}

when you've filled in your code.}}
