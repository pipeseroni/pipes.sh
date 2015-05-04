========
pipes.sh
========

  *Animated pipes terminal screensaver.*

.. note on taking the screenshots

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 640x210. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 640x210+$((2+2))+$((20+2)) -file doc/pipes.png

.. figure:: doc/pipes.png
  :target: screencast_

  Screenshot of pipes.sh, click to watch a screencast_ on YouTube.

.. _screencast: http://youtu.be/q_nYfR6CVEY

.. contents:: **Contents**
   :local:
   :backlinks: top


How this started
================

First and foremost, I am not the original author of pipes.sh.

The author of the original script is unknown to me. The first entry I can
find was posted at 2010-03-21 09:50:09 on `Arch Linux Forums`_ (doesn't mean the
poster is the author at all).

.. _Arch Linux Forums: https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932

Originally, I pushed my modifications to Gist_ after reading about pipes.sh on
a blog_, I continued to maintain the Gist for a few months in 2013

.. _Gist: https://gist.github.com/livibetter/4689307
.. _blog: http://inconsolation.wordpress.com/2013/02/01/pipes-sh-a-little-bit-of-fun/

In 2014, after seeing this `C version`_, which happened to be inspired by my
modified version, it might be the time to move here.

.. _C version: Snakes_


Copyright concern
=================

Normally, I wouldn't do this for a source code without proper license, but it's
done a year ago, So, what the heck. Even I have read somewhere that claim
`pipes.sh` is in public domain, I can not trust that.

So, anyone who wants to contribute, please be aware.

The most interesting thing is: I don't even have a name of the original author.


Requirements
============

* Bash 4+ since version 1.0.0.


Installation
============

If you want to install, you can run:

.. code:: sh

  $ make install

By default, it installs to ``/usr/local``; for user home, you can run:

.. code:: sh

  $ make PREFIX=$HOME/.local install

Or any ``PREFIX`` you prefer.

The ``Makefile`` also provides ``uninstall`` target.


Options
=======

``-p [1-]``
-----------

Number of pipes (D=1).

``-t [#]``
----------

Type of pipes, can be used more than once (D=0).

.. note on taking the screenshots

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 480x140. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 480x140+$((2+2))+$((20+2)) -file doc/pipes.t#.png

+----------+-------------------------------+
| ``-t #`` | Charaters                     |
+==========+===============================+
| ``-t 0`` | ``┃┏ ┓┛━┓  ┗┃┛┗ ┏━``          |
|          |                               |
|          | .. figure:: doc/pipes.t0.png  |
+----------+-------------------------------+
| ``-t 1`` | ``│╭ ╮╯─╮  ╰│╯╰ ╭─``          |
|          |                               |
|          | .. figure:: doc/pipes.t1.png  |
+----------+-------------------------------+
| ``-t 2`` | ``│┌ ┐┘─┐  └│┘└ ┌─``          |
|          |                               |
|          | .. figure:: doc/pipes.t2.png  |
+----------+-------------------------------+
| ``-t 3`` | ``║╔ ╗╝═╗  ╚║╝╚ ╔═``          |
|          |                               |
|          | .. figure:: doc/pipes.t3.png  |
+----------+-------------------------------+
| ``-t 4`` | ``|+ ++-+  +|++ +-``          |
|          |                               |
|          | .. figure:: doc/pipes.t4.png  |
+----------+-------------------------------+
| ``-t 5`` | ``|/ \/-\  \|/\ /-``          |
|          |                               |
|          | .. figure:: doc/pipes.t5.png  |
+----------+-------------------------------+
| ``-t 6`` | ``.. ....  .... ..``          |
|          |                               |
|          | .. figure:: doc/pipes.t6.png  |
+----------+-------------------------------+
| ``-t 7`` | ``.o oo.o  o.oo o.``          |
|          |                               |
|          | .. figure:: doc/pipes.t7.png  |
+----------+-------------------------------+

``-t c[16 chars]``
------------------

Custom pipe, for example: ``-t cMAYFORCEBWITHYOU``.

.. note on taking the screenshot

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 640x140. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 640x140+$((2+2))+$((20+2)) -file doc/pipes.tc.png

.. figure:: doc/pipes.tc.png

``-f [20-100]``
---------------

Framerate (D=75).

``-s [5-15]``
-------------

Probability of a straight fitting (D=13).

``-r LIMIT``
------------

Reset after x characters, 0 if no limit (D=2000).

``-R``
------

Random starting point.

``-B``
------

No bold effect.

``-C``
------

No color.

.. note on taking the screenshot

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 640x140. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 640x140+$((2+2))+$((20+2)) -file doc/pipes.Cpng

.. figure:: doc/pipes.C.png

``-h``
------

Help message.


``-v``
------

Print version number.


Controls
========

Press any key to exit the program.


Contribution
============

Feel free to fork and/or create pull request. But if you does create pull requests, that means you agree to put your contribution in public domain, also be sure to read about `copyright concern`_.


Related projects
================

* Snakes_: a C version of pipes.sh
* pipesX.sh_: pipes.sh at an angle

.. _Snakes: https://github.com/pipeseroni/Snakes
.. _pipesX.sh: https://github.com/pipeseroni/pipesX.sh
