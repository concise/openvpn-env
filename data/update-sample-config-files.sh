#!/bin/bash

set -e

cat >> /root/openvpn-master/sample/sample-config-files/server.conf <<'END'
proto   tcp
ca      /root/openvpn-master/sample/sample-keys/ca.crt
cert    /root/openvpn-master/sample/sample-keys/server.crt
key     /root/openvpn-master/sample/sample-keys/server.key
dh      /root/openvpn-master/sample/sample-keys/dh2048.pem
push    "redirect-gateway autolocal"
push    "dhcp-option DNS 10.8.0.1"
END

sed -i.backup 's@^\(remote .*\)@;\1@' /root/openvpn-master/sample/sample-config-files/client.conf

cat >> /root/openvpn-master/sample/sample-config-files/client.conf <<'END'
proto   tcp
ca      /root/openvpn-master/sample/sample-keys/ca.crt
cert    /root/openvpn-master/sample/sample-keys/client.crt
key     /root/openvpn-master/sample/sample-keys/client.key
remote  openvpn-server 1194
END
