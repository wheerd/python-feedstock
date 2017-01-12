#!/bin/bash

${SYS_PYTHON} ${RECIPE_DIR}/brand_python.py

# Remove test data and ensurepip stubs to save space
rm -rf Lib/test Lib/*/test
rm -rf Lib/ensurepip

if [ `uname` == Darwin ]; then
    export CFLAGS="-I$PREFIX/include $CFLAGS"
    export LDFLAGS="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -headerpad_max_install_names $LDFLAGS"
    sed -i -e "s/@OSX_ARCH@/$ARCH/g" Lib/distutils/unixccompiler.py
    ./configure \
        --enable-ipv6 \
        --enable-shared \
        --prefix=$PREFIX \
        --with-ensurepip=no \
        --with-tcltk-includes="-I$PREFIX/include" \
        --with-tcltk-libs="-L$PREFIX/lib -ltcl8.5 -ltk8.5"
fi
if [ `uname` == Linux ]; then
    ./configure --enable-shared --enable-ipv6 --with-ensurepip=no \
        --prefix=$PREFIX \
        --with-tcltk-includes="-I$PREFIX/include" \
        --with-tcltk-libs="-L$PREFIX/lib -ltcl8.5 -ltk8.5" \
        CPPFLAGS="-I$PREFIX/include" \
        LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib,--no-as-needed"
fi

make
make install
ln -s $PREFIX/bin/python3.6 $PREFIX/bin/python
ln -s $PREFIX/bin/pydoc3.6 $PREFIX/bin/pydoc
