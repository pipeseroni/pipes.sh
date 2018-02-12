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

If you are a `Homebrew <http://brew.sh>`_ user, you can install via:

.. code-block:: sh

    $ brew install pipes-sh


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
| ``-t #`` | Characters                    |
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
| ``-t 8`` | ``-\ /\|/  /-\/ \|``          |
|          |                               |
|          | .. figure:: doc/pipes.t8.png  |
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

``-c [0-7]``
------------

Color of pipes, can be used more than once (D=1 2 3 4 5 6 7 0).

Numbers are terminal color numbers. Traditionally typical values are:

+---+------------+
| 0 | background |
+---+------------+
| 1 | red        |
+---+------------+
| 2 | green      |
+---+------------+
| 3 | yellow     |
+---+------------+
| 4 | blue       |
+---+------------+
| 5 | magenta    |
+---+------------+
| 6 | cyan       |
+---+------------+
| 7 | foreground |
+---+------------+

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

``-K``
------

Pipes keep their color and type when hitting the screen edge.

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

Feel free to fork and/or create pull request following the guideline_. If
you're contributing, remember your changes will be released under the MIT
license.

.. _guideline: CONTRIBUTING.rst
