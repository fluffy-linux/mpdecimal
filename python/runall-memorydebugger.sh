#!/bin/sh

#
# Purpose: test all configurations with all supported python versions.
#
# Synopsis: ./runall-memorydebugger.sh [--all-configs64 | --all-configs32]
#
# Requirements:
#
#   Programs:
#
#     svn, valgrind
#
#   Directory structure (path names are hardcoded):
#
#     svndir/release25-maint
#     svndir/release26-maint
#     svndir/release27-maint
#     svndir/release31-maint
#     svndir/py3k
#
#     svndir/mpdecimal/python  ->  run script from this directory
#


# Specific configurations for setup.py
CONFIGS_64="x64 uint128 ansi64 universal"
CONFIGS_32="ppro ansi32 ansi-legacy universal"

PY2_VERSIONS="release25-maint release26-maint release27-maint"
PY3_VERSIONS="release31-maint py3k"

VALGRIND="valgrind --tool=memcheck --leak-check=full --leak-resolution=high \
         --db-attach=yes --show-reachable=yes --suppressions="

# Get args
case $@ in
     *--all-configs64*)
         CONFIGS=$CONFIGS_64
         ;;
     *--all-configs32*)
         CONFIGS=$CONFIGS_32
         ;;
     *)
         CONFIGS="auto"
         ;;
esac

# gmake required
GMAKE=`which gmake`
if [ X"$GMAKE" = X"" ]; then
    GMAKE=make
fi

# Pretty print configurations
print_config ()
{
    len=`echo $@ | wc -c`
    margin="#%"`expr \( 74 - $len \) / 2`"s"

    echo ""
    echo "# ========================================================================"
    printf $margin ""
    echo $@
    echo "# ========================================================================"
    echo ""
}

./gettests.sh

# Refleak tests
./build_all_branches.sh --with-pydebug

for py_version in $PY2_VERSIONS $PY3_VERSIONS; do
    for pyargs in "--without-threads" ""; do
        for config in $CONFIGS; do
            if [ "$config" = "auto" ]; then
                args=$pyargs
            else
                args=$pyargs" --with-machine="$config
            fi
            py_exec="$py_version/python"
            regrtest="../../$py_version/Lib/test/regrtest.py -uall -R 9:9:9"

            print_config $py_version $args

            cd ../ || exit 1
            $GMAKE clean
            ../$py_exec setup.py build $args || exit 1
            cd python || exit 1
            echo ""
            echo ""
            echo "======================== Unit tests =========================="
            echo ""
            case "$py_version" in
                release25-maint) decimal_tests=test_cdecimal2.5.py;;
                release2*) decimal_tests=test_cdecimal2.py;;
                release3*) decimal_tests=test_cdecimal3.py;;
                py3k) decimal_tests=test_cdecimal3.py;;
                *) exit 1;;
            esac
            cp cdecimal*.so ../../$py_version/Lib/ || exit 1
            cp $decimal_tests ../../$py_version/Lib/test/test_cdecimal.py || exit 1
            ../../$py_exec $regrtest test_cdecimal
        done
    done
done

# Valgrind tests
./build_all_branches.sh --without-pymalloc

for py_version in $PY2_VERSIONS $PY3_VERSIONS; do
    for pyargs in "--without-threads" ""; do
        for config in $CONFIGS; do
            if [ "$config" = "auto" ]; then
                args=$pyargs
            else
                args=$pyargs" --with-machine="$config
            fi
            py_exec="$py_version/python"
            regrtest="../../$py_version/Lib/test/regrtest.py -uall -R 9:9:9"
            valgrind="$VALGRIND../../$py_version/Misc/valgrind-python.supp"

            print_config $py_version $args

            cd ../ || exit 1
            $GMAKE clean
            ../$py_exec setup.py build $args || exit 1
            cd python || exit 1
            echo ""
            echo ""
            echo "======================== Unit tests =========================="
            echo ""
            case "$py_version" in
                release25-maint)
                    decimal_tests=test_cdecimal2.5.py
                    deccheck=deccheck2.py
                    ctx_deccheck=ctx-deccheck2.py
                    ;;
                release2*)
                    decimal_tests=test_cdecimal2.py
                    deccheck=deccheck2.py
                    ctx_deccheck=ctx-deccheck2.py
                    ;;
                release3*)
                    decimal_tests=test_cdecimal3.py
                    deccheck=deccheck3.py
                    ctx_deccheck=ctx-deccheck3.py
                    ;;
                py3k)
                    decimal_tests=test_cdecimal3.py
                    deccheck=deccheck3.py
                    ctx_deccheck=ctx-deccheck3.py
                    ;;
                *) exit 1 ;;
            esac
            cp cdecimal*.so ../../$py_version/Lib/ || exit 1
            cp $decimal_tests ../../$py_version/Lib/test/test_cdecimal.py || exit 1
            $valgrind ../../$py_exec $decimal_tests
            echo ""
            echo ""
            echo "========================= deccheck ==========================="
            echo ""
            $valgrind ../../$py_exec $deccheck || exit 1
            echo ""
            echo ""
            echo "======================= ctx-deccheck ========================="
            echo ""
            $valgrind ../../$py_exec $ctx_deccheck || exit 1
        done
    done
done



