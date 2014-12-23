#!/bin/bash

set -e

test -f /root/local/lib/libpolarssl.a

if [[ -f /root/local/sbin/openvpn ]]; then
    exit
fi

cd /root
unzip /root/data/openvpn-master-e2e9a69c1e.zip
cd /root/openvpn-master

libtoolize
aclocal
autoconf
autoheader
automake --add-missing
autoreconf -i -v -f
autoreconf --install

sed -i -e 's/\(.*PolarSSL 1.3.x required.*\)/:#\1/' configure

./configure                                         \
    --prefix=/root/local                            \
    --disable-snappy                                \
    --with-crypto-library=polarssl                  \
    POLARSSL_LIBS="-L/root/local/lib -lpolarssl"    \
    POLARSSL_CFLAGS="-I/root/local/include"

make
make install
