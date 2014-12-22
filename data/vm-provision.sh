#!/bin/bash

set -e

mkdir -p ~/local/{,s}bin

if ! grep -q 'openvpn-server' /etc/hosts; then
    echo 'Add "192.168.8.8 openvpn-server" to /etc/hosts'
    echo '192.168.8.8 openvpn-server' >> /etc/hosts
fi

if ! grep -q 'openvpn-client' /etc/hosts; then
    echo 'Add "192.168.8.9 openvpn-client" to /etc/hosts'
    echo '192.168.8.9 openvpn-client' >> /etc/hosts
fi

if ! grep -q 'PROVISIONED' ~/.bashrc; then
    echo "Prepend /root/local/bin and /root/local/sbin to root's PATH"
    echo '#PROVISIONED:' >> ~/.bashrc
    echo 'PATH=~/local/bin:~/local/sbin:$PATH' >> ~/.bashrc
fi

if ! grep -q 'Asia/Taipei' /etc/timezone; then
    echo 'Update timezone'
    echo 'Asia/Taipei' > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
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

echo "Update OpenVPN's sample config files..."
bash /root/data/update-sample-config-files.sh
