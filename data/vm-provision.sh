#!/bin/bash

set -e

mkdir -p ~/local/{,s}bin

if ! grep -q 'PROVISIONED' ~/.bashrc; then
    echo "Prepend /root/local/bin and /root/local/sbin to root's PATH"
    echo '#PROVISIONED:' >> ~/.bashrc
    echo 'PATH=~/local/bin:~/local/sbin:$PATH' >> ~/.bashrc

    if [[ "$(hostname)" = 'openvpn-client' ]]; then
        echo "echo 'Run openvpn --config /root/data/client.conf to start'" >> ~/.bashrc
    elif [[ "$(hostname)" = 'openvpn-server' ]]; then
        echo "echo 'Run openvpn --config /root/data/server.conf to start'" >> ~/.bashrc
    fi
fi

if ! grep -q 'Asia/Taipei' /etc/timezone; then
    echo 'Update timezone'
    echo 'Asia/Taipei' > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi

if [[ $(cat /proc/sys/net/ipv4/ip_forward) = 0 ]]; then
    echo 'Enable IP forwarding...'
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
fi

if ! grep -q 'ubuntu.cs.nctu.edu.tw' /etc/apt/sources.list; then
    echo 'Update apt-get source list'
    sed -i.backup 's@/archive\.ubuntu\.com/@/ubuntu.cs.nctu.edu.tw/@' /etc/apt/sources.list
fi

if ! test -f /apt-get-install-done; then
    echo 'Start installing required Ubuntu packages...'
    apt-get update
    apt-get install -y git liblzo2-dev libpam0g-dev libssl-dev autoconf shtool autotools-dev libtool unzip
    echo 'OK' >> /apt-get-install-done
fi

echo 'Try to install polarssl to /root/local...'
bash /root/data/install-polarssl.sh

echo 'Try to install openvpn to /root/local...'
bash /root/data/install-openvpn.sh
