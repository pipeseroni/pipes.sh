========
pipes.sh
========

  *Animated pipes terminal screensaver.*

.. note on taking the screenshots

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 640x210. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 640x210+$((2+2))+$((20+2)) -file i/pipes.png

.. figure:: i/pipes.png
  :target: screencast_

  Screenshot of pipes.sh, click to watch a screencast_ on YouTube.

.. _screencast: http://youtu.be/q_nYfR6CVEY

.. contents:: **Contents**
   :local:
   :backlinks: top


Requirements
============

* Bash 4+ since version 1.0.0.

* ncurses for ``tput``

  * >= 6.1 (2018-01-27) for 24-bit colors and ``TERM=*-direct``.


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

If you are a `Homebrew <http://brew.sh>`_ user, you can install via:

.. code-block:: sh

    $ brew install pipes-sh


Options
=======

See |pipes.sh(6)|_ for a full list of options.

.. |pipes.sh(6)| replace:: ``pipes.sh(6)``
.. _pipes.sh(6): https://pipeseroni.github.io/pipes.sh/pipes.sh.6.html


``-t [#]``: pipe types
----------------------

.. note on taking the screenshots

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 480x140. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 480x140+$((2+2))+$((20+2)) -file i/pipes.t#.png

+----------+------------------------+----------------------------+
| ``-t #`` | Characters             | Screenshots                |
+==========+========================+============================+
| ``-t 0`` | ``┃┏ ┓┛━┓  ┗┃┛┗ ┏━``   | .. figure:: i/pipes.t0.png |
+----------+------------------------+----------------------------+
| ``-t 1`` | ``│╭ ╮╯─╮  ╰│╯╰ ╭─``   | .. figure:: i/pipes.t1.png |
+----------+------------------------+----------------------------+
| ``-t 2`` | ``│┌ ┐┘─┐  └│┘└ ┌─``   | .. figure:: i/pipes.t2.png |
+----------+------------------------+----------------------------+
| ``-t 3`` | ``║╔ ╗╝═╗  ╚║╝╚ ╔═``   | .. figure:: i/pipes.t3.png |
+----------+------------------------+----------------------------+
| ``-t 4`` | ``|+ ++-+  +|++ +-``   | .. figure:: i/pipes.t4.png |
+----------+------------------------+----------------------------+
| ``-t 5`` | ``|/ \/-\  \|/\ /-``   | .. figure:: i/pipes.t5.png |
+----------+------------------------+----------------------------+
| ``-t 6`` | ``.. ....  .... ..``   | .. figure:: i/pipes.t6.png |
+----------+------------------------+----------------------------+
| ``-t 7`` | ``.o oo.o  o.oo o.``   | .. figure:: i/pipes.t7.png |
+----------+------------------------+----------------------------+
| ``-t 8`` | | ``-\ /\|/  /-\/ \|`` | .. figure:: i/pipes.t8.png |
|          | | (railway)            |                            |
+----------+------------------------+----------------------------+
| ``-t 9`` | | ``╿┍ ┑┚╼┒  ┕╽┙┖ ┎╾`` | .. figure:: i/pipes.t9.png |
|          | | (knobby)             |                            |
+----------+------------------------+----------------------------+


``-t c[16 chars]``: custom pipe
-------------------------------

For example, ``-t cMAYFORCEBWITHYOU``.

.. note on taking the screenshot

  Font is Inconsolata, font size 24 as in 16x35 pixel per character

  Image size is 640x140. A sample command, where terminal at +0+18,
  window border is 2, terminal is urxvt, seems to 2 pixels as padding:

  xsnap -region 640x140+$((2+2))+$((20+2)) -file i/pipes.tc.png

.. figure:: i/pipes.tc.png


Controls
========

Press any key to exit the program, except the following :kbd:`Shift` +
:kbd:`Key`:

===================  ======================================================
Keys                 Actions
===================  ======================================================
:kbd:`P` / :kbd:`O`  Increase/decrease probability of straight pipes
:kbd:`F` / :kbd:`D`  Increase/decrease frame rate
:kbd:`B`             Toggle bold effect
:kbd:`C`             Toggle no colors
:kbd:`K`             Toggle keeping pipe color and type when crossing edges
===================  ======================================================


History
=======

(Read full history_  in |pipes.sh(6)|_)

.. _history: https://pipeseroni.github.io/pipes.sh/pipes.sh.6.html#HISTORY

pipes.sh was originally created by Matthew Simpson and posted to the `Arch
Linux Forums`__ in early 2010. It was also later posted to Gist__ released in
the public domain.

__ https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932
__ https://gist.github.com/msimpson/1096939

In 2015, the MIT License was added and the Pipeseroni_ collective was formed to
maintain pipes.sh.

.. _Pipeseroni: https://pipeseroni.github.io/


Reporting an Issue
==================

* `Reporting a bug`__

__ https://github.com/pipeseroni/pipes.sh/issues/new?template=BUG.md&title=Brief+bug+summary


Contribution
============

Feel free to fork and/or create pull request following the guideline_. If
you're contributing, remember your changes will be released under the MIT
license.

.. _guideline: CONTRIBUTING.rst


Copyright
=========

pipes.sh is licensed under the MIT License.
