#!/bin/bash

set -e

test -f /root/local/lib/libpolarssl.a

if [[ -e /compile-openvpn.sh-running ]]; then
    echo >&2 'Another `compile-openvpn.sh` process is already running'
    echo >&2 'Exiting'
    exit 1
fi
echo 1 > /compile-openvpn.sh-running
finish () { rm /compile-openvpn.sh-running; }; trap finish EXIT

if [[ ! -d /root/data/openvpn ]]; then
    echo >&2 'Cannot find /root/data/openvpn directory'
    echo >&2 'Exiting'
    exit 1
fi

cd /root/data/openvpn

libtoolize; aclocal; autoconf; autoheader; automake --add-missing; autoreconf -i -v -f; autoreconf --install

./configure                                         \
    --prefix=/root/local                            \
    --disable-snappy                                \
    --with-crypto-library=polarssl                  \
    POLARSSL_LIBS="-L/root/local/lib -lpolarssl"    \
    POLARSSL_CFLAGS="-I/root/local/include"

make
make install
