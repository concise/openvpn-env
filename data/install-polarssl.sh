#!/bin/bash

set -e

if [[ -f /root/local/lib/libpolarssl.a ]]; then
    exit
fi

cd /root
unzip /root/data/polarssl-development-82788fb63b.zip
cd /root/polarssl-development

make no_test
make install DESTDIR=/root/local
