pipes.sh
========
    *Animated pipes terminal screensaver.*
![](https://raw.githubusercontent.com/BlackXT/pipes.sh/master/pipes.png)
  Screenshot of pipes.sh.

[![wercker status](https://app.wercker.com/status/fd916a2e97a1ec904b399474cb1ebf80/m "wercker status")](https://app.wercker.com/project/bykey/fd916a2e97a1ec904b399474cb1ebf80)

A Brief History
===============
pipes.sh was originally created by @msimpson and posted to the [Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932) in early 2010. 
It was also later posted to [Gist](https://gist.github.com/msimpson/1096939) with a license clarification ("public domain").

In early 2013 @livibetter posted a modification of the script to [Gist](https://gist.github.com/livibetter/4689307) after reading about it on a [blog](http://inconsolation.wordpress.com/2013/02/01/pipes-sh-a-little-bit-of-fun/) where it was maintained for a few months.

In 2014 the script was given its own GitHub repo which encouraged contributions from other developers. As the script gained more popularity the decision was made to combine forces with developers of similar projects (such as this C version). 
Finally, in 2015 the [Pipeseroni](https://github.com/pipeseroni) collective was formed.

In 05/06/2015 [AcidHub](mailto:acidhub@craft.net.br) with his [BlackXT](https://github.com/BlackXT) GitHub account forked this project and 
made the git as light as possible only for archive purposes.

Requirements
============
* Bash 4+.

Options
=======

    -p [1-]        number of pipes (D=1).
    -t [0-8]       type of pipes, can be used more than once (D=0).
    -t c[16 chars] custom type of pipes.
    -f [20-100]    framerate (D=75).
    -s [5-15]      probability of a straight fitting (D=13).
    -r LIMIT       reset after x characters, 0 if no limit (D=2000).
    -R             random starting point.
    -B             no bold effect.
    -C             no color.
    -h             help.
    -v             print version number.

Controls
========
Press any key to exit the program.

Contribution
============
Feel free to fork and/or create pull request. But if you does create pull requests, that means you agree to put your contribution in *public domain*.
