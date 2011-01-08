#!/bin/sh

if ! [ -d decimaltestdata ]; then
    svn checkout http://svn.python.org/projects/python/branches/py3k/Lib/test/decimaltestdata
fi
