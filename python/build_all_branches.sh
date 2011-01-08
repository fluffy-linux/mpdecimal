#!/bin/sh


# Prepare all supported Python branches for memory debugging:
# ./build_all_branches --without-threads --with-pydebug

cd ../../

for dir in release25-maint release26-maint release27-maint release31-maint py3k; do
    cd $dir
    rm Objects/obmalloc.c
    svn update
    case "$@" in
        *--without-pymalloc*)
            patch -p0 < ../mpdecimal/python/obmalloc.patch;;
    esac
    make distclean
    ./configure --prefix=/dev/null "$@"
    make
    cd ..
done

# 2.5 has a buggy version of decimaltestdata
cd release25-maint/Lib/test && rm -rf decimaltestdata && cp -a ../../../release27-maint/Lib/test/decimaltestdata .


