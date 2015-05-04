=======
CHANGES
=======


Development
===========

* move to new GitHub_

.. _GitHub: https://github.com/pipeseroni/pipes.sh


Version 1.0.0 (2015-04-09T02:41:33Z)
====================================

* drop Bash 3- support

  The last commit for Bash 3- is ``b3e2253ff3c6c01fb718af262db9c2a6b72736e0``
  or before version 1.0.

* fix keys like arrow keys or ``Ctrl+Alt+A`` halt on exiting (#12)


Version 0.2.0 (2014-12-19T07:43:58Z)
====================================

* fix no exit keys in Bash < 4 (#1)
* add ``-B`` option for no bold effect (#10)


Version 0.1.1 (2014-03-18T08:52:13Z)
====================================

* fix leftover color escaped code (#5)
* fix terminal with no ``smcup`` and ``rmcup`` capabilities, and incorrect
  ``tput reset`` (#4)

  ``smcup`` stores the screen and ``rmcup`` restores, if ``tput`` can't execute
  successfully like in Linux console, then the terminal doesn't have such
  capabilities, therefore a ``reset`` is used to clean up.

  ``tput reset`` results incorrect screen restoration, seemingly only cursor
  position restores, the screen before invocation isn't saved and restored.
  However, within ``tmux`` this issue doesn't not occur.

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

* move to GitHub: ``https://github.com/livibetter/pipes.sh``
* add option argument ``-t 4`` for ASCII type


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
