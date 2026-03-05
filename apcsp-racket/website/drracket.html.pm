#lang pollen
◊title{DrRacket Hints and Tips}

◊h3{TL;DR}

◊ul{
    ◊li{When you save a file, add the extension ◊code{.rkt} to the filename. That will let the
        operating system know that it's a Racket file.}
    ◊li{Put these lines at the top of your file:
    ◊prog{
#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)
    }}
    ◊li{DrRacket highlights the code between matching parentheses. You will make lots of mistakes
        where you put parentheses in the wrong spots or forget them. Use this highlighting to
        help figure out where you went wrong.}
    ◊li{Hit the ◊screen{Run} button to run the code in the Definitions area. This will also erase
        everything in the Interactions area. To run something in the Interactions area,
        just type it in and hit Enter.}
    ◊li{In the Interactions area, pressing the ◊screen{Esc} key, then the ◊screen{P} key will pull
        up the previous thing you typed. Pressing ◊screen{Esc}, then ◊screen{P} again will pull
        up the thing before that, and so on.}
    ◊li{There are three kinds of comments:
    ◊ul{
        ◊li{comments that start with a semicolon ◊code{;} &endash; DrRacket ignores everything from
            the semicolon to the end of the line.}
        ◊li{multi-line comments that start with ◊code{#|} and end with ◊code{|#} &endash; DrRacket
            ignores those two pairs of characters and everything between them.}
        ◊li{expression comments ◊code{#;} &endash; DrRacket ignores the ◊code{#;} and the next
            expression. For example, writing ◊code{#;"my string"} would ignore everything from the
            hash tag to the second double-quotation mark, since a string is an expression.
            Similarly, ◊code{#;(define x (+ 2 (- 3 5)))} would comment out all of that, since
            thing between the first parenthesis and the last one is a single expression.}}
    ◊li{DrRacket will automatically indent your code for you. If things get messy, press the Tab key
        on any line to re-indent it. You can also select a block of code and press Tab to re-indent
        the whole block. To reindent the whole file, press ◊screen{Ctrl+I} (or ◊screen{⌘+I} on a Mac)
        or choose ◊screen{Racket}→◊screen{Reindent All} from the menu.}
    ◊li{Use ◊code{(check-expect your-code expected-value)}} to check your code.
        Unless your code is an ◊em{inexact} number (you can tell, because it starts with ◊code{#i}),
        in which case use ◊code{(check-within your-code expected-value how-close)}.}
}

◊h3{Download DrRacket}

You can download DrRacket from the official Racket website:
◊a[#:href "https://racket-lang.org/download/"]{https://racket-lang.org/download/}.
Make sure to choose the version that is compatible with your operating system,
Windows, Mac, or Linux. If you're on MacOS, you need to pick either Intel or Apple Silicon. Use Intel if you see an "Intel Inside" sticker on your Mac, otherwise use Apple Silicon.

◊h3{When You Open A File}

DrRacket needs to know which language you want to use. To make your life easier,
ignore the ◊screen{Language} menu at the top of the window. If you already chose a
language using the menu, you can change it by going to ◊screen{Language}→◊screen{Choose Language}
and then clicking the top radio button, which says ◊screen{The Racket Language}.

Once you've done that, make sure you add this line to the top of all your files:
◊code{
#lang htdp/bsl
}

This stands for "How To Design Programs / Beginning Student Language".

If you want to use images, you will also need to add this line at the top:
◊code{
  (require 2htdp/image)
}

If you want to do animations or interactive world programs, you will also
need to add this line at the top:
◊prog{
  (require 2htdp/universe)
}

If you ever get an error saying that something is not defined, check those three
lines and check that the ◊screen{Language} is set to ◊screen{The Racket Language}.
Also, ask a neighbor or me for help.

◊h3{Definitions and Interactions}

The top part of the screen is called the ◊screen{Definitions} area. This is where
you write your code. The bottom part of the screen is called the
◊screen{Interactions} area. This is where you can try out stuff to see what happens.

To save the ◊screen{Definitions} area, click on the floppy disk icon, or choose
◊screen{File}→◊screen{Save}. You can also use the keyboard shortcut ◊screen{Ctrl+S}
(or ◊screen{⌘+S} on a Mac). You'll need to type in a file name. Put the extension
◊code{.rkt} after the name to let the operating system know that this is a Racket
file. Choose which folder to save your file into (◊screen{Desktop} works well, usually),
and click the ◊screen{Save} button.

I recommend saving all your files in a folder called ◊code{apcsp} or something like that,
maybe with subfolders for files that go together.

To run your code, click on the green ◊screen{Run} button at the top of the window. This
will execute the code in the ◊screen{Definitions} area and show you any output or
errors in the ◊screen{Interactions} area. It will also erase everything in the
◊screen{Interactions} area. Don't panic, however. Hitting the ◊screen{Esc} key, then the
◊screen{P} key will pull up the previous thing you typed in the ◊screen{Interactions} area,
and you can keep hitting ◊srceen{Esc} then ◊screen{P} to go back through your history.