#!/bin/sh

DOMAIN=${DOMAIN-"sdn.lab"}
IP_PREFIX=${IP_PREFIX-"192.168.58"}
GW_IP=${GW_IP-208}

pkg update
pkg install -y os-vmware os-zerotier git

curl -o ~/config-OPNsense.xml -sS https://raw.githubusercontent.com/harryzwh/OPNsense_Init/master/config-OPNsense.xml
sed -i ".bak" -e "s/@domain@/$DOMAIN/g" ~/config-OPNsense.xml
sed -i ".bak" -e "s/@IP_Prefix@/$IP_PREFIX/g" ~/config-OPNsense.xml
sed -i ".bak" -e "s/@IP_Gateway@/$GW_IP/g" ~/config-OPNsense.xml
cp ~/config-OPNsense.xml /conf/config.xml

curl -L https://raw.githubusercontent.com/harryzwh/KMS-on-pfSense/master/kms2pfsense.sh | sh
