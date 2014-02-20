pipes.sh
========

*Animated pipes terminal screensaver.*

The author of the original script is unknown to me. The first entry I can
find was posted at 2010-03-21 09:50:09 on [Arch Linux Forums][] (doesn't mean the
poster is the author at all).

[Arch Linux Forums]: https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932

Originally, I pushed my modifications to [Gist][], but after saw this
[C version][C], it might be the time to move here.

[Gist]: https://gist.github.com/livibetter/4689307
[C]: http://mezulis.com/2013/04/02/snakes-a-console-based-pipes-like-screensaver/


Copyright concern
-----------------

Normally, I wouldn't do this for a source code without proper license, but it's
done a year ago, So, what the heck. Even I have read somewhere that claim
`pipes.sh` is in public domain, I can't not trust that.

So, anyone who wants to contribute, please be aware.

The most interesting thing is: I don't even have a name of the original author.


Options
-------

`-p [1-]`
:   number of pipes (D=1).

`-t [0-3]`
:   type of pipes (D=0). See *Types of Pipes* for samples.

`-f [20-100]`
:   framerate (D=75).

`-s [5-15]`
:   probability of a straight fitting (D=13).

`-r LIMIT`
:    reset after x characters, 0 if no limit (D=2000).

`-R`
:   random starting point.

`-C`
:   no color.

`-h`
:   help message.


Types of Pipes
--------------

There are a few types of pipes to choose from:

| t | Characters       |
| - | ---------------- |
| 0 | ┃┏ ┓┛━┓  ┗┃┛┗ ┏━ |
| 1 | │╭ ╮╯─╮  ╰│╯╰ ╭─ |
| 2 | │┌ ┐┘─┐  └│┘└ ┌─ |
| 3 | ║╔ ╗╝═╗  ╚║╝╚ ╔═ |
