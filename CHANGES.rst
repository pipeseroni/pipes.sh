=======
CHANGES
=======


Development
===========

* fix leftover color escaped code (#5)
* workaround of Control+C exiting (#4)

  Signal ``INT`` is now ignored, so user interrupt would not occur, only a key
  press can trigger the exit of pipes.sh.

* add manpage (#2, #6 by @Foggalong)


Version 0.1.0 (2014-02-26T11:27:01Z)
====================================

* add versioning functionality
* allow multiple ``-t`` (#3)


2014-02-21
==========

* fix ``read`` with fractional timeout for older Bash version < 4
* add option argument ``-t 5`` for ASCII type


2014-02-20
==========

* move to GitHub_
* add option argument ``-t 4`` for ASCII type

.. _GitHub: https://github.com/livibetter/pipes.sh


2013-02-07
==========

* fix inccorect position
* add option ``-t`` for types of pipes


2013-02-06
==========

* add option argument ``-r 0`` for no limit
* clean up on ``Ctrl + C``


2013-02-01
==========

* commit the `original copy`_ and push to Gist_
* add option ``-p`` for multi-pipes
* add option ``-R`` for random starting point
* add option ``-C`` for no color

.. _original copy: https://github.com/livibetter/pipes.sh/blob/f7d09419bb353344c4af4e4a1812cae4dd3b4d66/pipes.sh
.. _Gist: https://gist.github.com/livibetter/4689307
