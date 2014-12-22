#!/bin/bash

set -e

cd /root
unzip /root/data/polarssl-development-82788fb63b.zip
cd /root/polarssl-development

make
make install DESTDIR=/root/local
