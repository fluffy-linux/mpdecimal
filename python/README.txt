

bench.py:
=========

A reasonably quick benchmark that times native Python calculations,
decimal.py, cdecimal.so and gmpy.so.


randdec.py:
===========

Functions for creating random decimals and corner cases. Add your
own testcases if you think that something has not been addressed!


randfloat.py:
=============

More random test cases.


deccheck2.py, deccheck3.py:
===========================

A module that introduces the cdec (for "check decimal") type. The main
purpose is to check cdecimal.so against decimal.py. It supports (almost)
all methods of decimal.py.


ctx-deccheck2.py, ctx-deccheck3.py:
===================================

Same as above, but always uses the context methods.


Verification:
-------------

Each calculation involving cdecs is carried out redundantly and the
results are verified. Example:

  c = a + b translates to:

    1. c.dec = a.dec + b.dec

    2. c.mpd = a.mpd + b.mpd

    3. Convert c.dec, c.mpd to strings using both to_sci and to_eng.

    4. Convert c.dec, c.mpd to tuples using as_tuple.

    5. Compare all results and raise an error if they differ.

    6. Compare both contexts and raise an error if they differ.


Known differences:
------------------

In order to have uncluttered output, known differences between
decimal.py and cdecimal.so are silently passed over.


Longer tests:
--------------

deccheck.py takes the arguments --short (default), --medium, --long or
--all.


runall.sh, runall-amd64.bat, runall-i386.bat:
==============================================

Run tests for all installed Python versions. Edit the script if not
all versions from 2.5 through 3.2 are installed.


Valgrind + refleak tests:
==========================

Create the following directory structure [1]:

svndir/py3k
svndir/release25-maint
svndir/release26-maint
svndir/release27-maint
svndir/release31-maint
svndir/mpdecimal/python


Change into svndir/mpdecimal/python and run:

./runall-memorydebugger.sh


[1] See http://www.python.org/dev/faq/ for svn checkout instructions.


