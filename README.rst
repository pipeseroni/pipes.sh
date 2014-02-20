========
pipes.sh
========

  *Animated pipes terminal screensaver.*

.. figure:: https://lh5.googleusercontent.com/-gHm74e1R0wY/UwWJnHr_H1I/AAAAAAAAFxI/1qe53Jl8FM4/s800/2014-02-20--12%253A47%253A36.png

The author of the original script is unknown to me. The first entry I can
find was posted at 2010-03-21 09:50:09 on `Arch Linux Forums`_ (doesn't mean the
poster is the author at all).

.. _Arch Linux Forums: https://bbs.archlinux.org/viewtopic.php?pid=728932#p728932

Originally, I pushed my modifications to Gist_, but after saw this
`C version`_, it might be the time to move here.

.. _Gist: https://gist.github.com/livibetter/4689307
.. _C version: http://mezulis.com/2013/04/02/snakes-a-console-based-pipes-like-screensaver/


Copyright concern
=================

Normally, I wouldn't do this for a source code without proper license, but it's
done a year ago, So, what the heck. Even I have read somewhere that claim
`pipes.sh` is in public domain, I can not trust that.

So, anyone who wants to contribute, please be aware.

The most interesting thing is: I don't even have a name of the original author.


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
    number of pipes (D=1).

``-t [0-4]``
    type of pipes (D=0). See [Types of Pipes](#types-of-pipes) for samples.

``-f [20-100]``
    framerate (D=75).

``-s [5-15]``
    probability of a straight fitting (D=13).

``-r LIMIT``
     reset after x characters, 0 if no limit (D=2000).

``-R``
    random starting point.

``-C``
    no color.

``-h``
    help message.


Types of Pipes
==============

There are a few types of pipes to choose from:


``-t 0``
--------

Characters are ``┃┏ ┓┛━┓  ┗┃┛┗ ┏━``.

.. figure:: https://lh5.googleusercontent.com/-gHm74e1R0wY/UwWJnHr_H1I/AAAAAAAAFxI/1qe53Jl8FM4/s800/2014-02-20--12%253A47%253A36.png

``-t 1``
--------

Characters are ``│╭ ╮╯─╮  ╰│╯╰ ╭─``.

``-t 2``
--------

Characters are ``│┌ ┐┘─┐  └│┘└ ┌─``.

``-t 3``
--------

Characters are ``║╔ ╗╝═╗  ╚║╝╚ ╔═``.

``-t 4``
--------

Characters are ``|+ ++-+  +|++ +-``.

.. figure:: https://lh6.googleusercontent.com/-EVMwemQ0JFo/UwWJpVL3zZI/AAAAAAAAFxQ/qBEdcI_10zk/s800/2014-02-20--12%253A48%253A08.png

``-t 5``
--------

Characters are ``|/ \/-\  \|/\ /-``.
