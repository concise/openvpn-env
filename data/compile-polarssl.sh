#!/bin/bash

set -e

if [[ -e /compile-polarssl.sh-running ]]; then
    echo >&2 'Another `compile-polarssl.sh` process is already running'
    echo >&2 'Exiting'
    exit 1
fi
echo 1 > /compile-polarssl.sh-running
finish () { rm /compile-polarssl.sh-running; }; trap finish EXIT

if [[ ! -d /root/data/polarssl ]]; then
    echo >&2 'Cannot find /root/data/polarssl directory'
    echo >&2 'Exiting'
    exit 1
fi

cd /root/data/polarssl

make DEBUG=1 no_test
make install DESTDIR=/root/local
