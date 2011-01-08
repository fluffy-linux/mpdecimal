#!/bin/sh

#
# Check out all supported Python branches.
#
# Directory structure:
#
#   svndir/release25-maint
#   svndir/release26-maint
#   ...
#
#   svndir/mpdecimal/python  ->  run script from this directory
#

cd ../../
for branch in release25-maint release26-maint release27-maint release31-maint py3k; do
   svn co http://svn.python.org/projects/python/branches/$branch
done



