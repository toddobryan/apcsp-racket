#lang pollen
◊title{Image Functions}

First, open DrRacket and create a new file. Save the file in the folder where you save your assignments and call it ◊code{imageFunctions.rkt}.

At the top of the file, add these lines:
◊prog{
#lang htdp/bsl
(require "apcsp.rkt")
(require picturing-programs)
}

Download the file ◊a[#:href "apcsp.rkt" #:download "apcsp.rkt"]{apcsp.rkt} and save it in the same folder as your ◊code{imageFunctions.rkt} file. Make sure you've saved your file as ◊code{imageFunctions.rkt} (even if it's empty) and the ◊code{apcsp.rkt} file is in the same folder, otherwise you'll get errors.

Here's an example function called ◊code{three-squares}.◊br{}
◊pict{imageFunctions/three-squares-complete.png}


Following the same pattern used for the ◊code{three-squares} function, write these functions. I've given you the names of the functions and some test cases.

◊ol{
    ◊li{Design the function ◊code{pinwheel}.◊br{}
    ◊pict{imageFunctions/pinwheel.png}}
    ◊li{Design the function ◊code{bullseye}.◊br{}
    ◊pict{imageFunctions/bullseye.png}}
    ◊li{Design the funcion ◊code{lollipop}. For the stick of the lollipop, use a rectangle that is two pixels wide.◊br{}
    ◊pict{imageFunctions/lollipop.png}}
    ◊li{Design the funcion ◊code{three-ovals}. The two outer ovals are the same color, and the width and height of the outside ovals are the height and width of the inside oval.◊br{}
    ◊pict{imageFunctions/three-ovals.png}}
    ◊li{Design the funcion ◊code{boxes}. The top box is tilted on top of the bottom box.◊br{}
    ◊pict{imageFunctions/boxes.png}}
}