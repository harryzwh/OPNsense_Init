#!/bin/sh

DOMAIN=${DOMAIN-"sdn.lab"}
IP_PREFIX=${IP_PREFIX-"192.168.58"}

#pkg update
#pkg install -y os-vmware os-zerotier git

curl -o ~/config-OPNsense.xml -sS https://raw.githubusercontent.com/harryzwh/OPNsense_Init/master/config-OPNsense.xml
sed -i "s/@domain@/$DOMAIN/" ~/config-OPNsense.xml
sed -i "s/@IP_Prefix@/$IP_PREFIX/" ~/config-OPNsense.xml
cp ~/config-OPNsense.xml /conf/config.xml

curl -L https://raw.githubusercontent.com/harryzwh/KMS-on-pfSense/master/kms2pfsense.sh | sh
