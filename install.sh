#!/bin/sh

DOMAIN=${DOMAIN-"sdn.lab"}
IP_PREFIX=${IP_PREFIX-"192.168.86"}

if [[ ($(uname) == "FreeBSD") ]]; then
pkg update
pkg install -y os-vmware os-zerotier git
fi

curl -o ~/config-OPNsense.xml -sS https://raw.githubusercontent.com/harryzwh/OPNsense_Init/master/config-OPNsense.xml

