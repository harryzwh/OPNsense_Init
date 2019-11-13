#!/bin/sh

DOMAIN=${DOMAIN-"sdn.lab"}
IP_PREFIX=${IP_PREFIX-"192.168.86"}
GW_IP=${GW_IP-201}
ZT_IP=${ZT_IP-"10.147.17.86"}

KEY="duSMPU4Otj0H9N2wpoD0ee7Aq5y49y230gpOJttq4RAZID6ylzoNaj4kIHwsx8AVCxBGr0PvH9KVbmji"
SECRET="jwAtBm0sj4QCOIiHFO/7/PB0/+AHcBBESEhelNeWYYe0wFqiTD3hgcCtUBXD8ZPhynCPGNp0mSbyCb61"

HOST="https://127.0.0.1"
HEADER="Content-Type: application/json"

pkg update
pkg install -y os-vmware os-zerotier git
curl -L https://raw.githubusercontent.com/harryzwh/KMS-on-pfSense/master/kms2pfsense.sh | sh

curl -o ~/config-OPNsense.xml -sS https://raw.githubusercontent.com/harryzwh/OPNsense_Init/master/config-OPNsense.xml
sed -i ".bak" -e "s/@domain@/$DOMAIN/g" ~/config-OPNsense.xml
sed -i ".bak" -e "s/@IP_Prefix@/$IP_PREFIX/g" ~/config-OPNsense.xml
sed -i ".bak" -e "s/@IP_Gateway@/$GW_IP/g" ~/config-OPNsense.xml
sed -i ".bak" -e "s/@ZT_IP@/$ZT_IP/g" ~/config-OPNsense.xml
cp ~/config-OPNsense.xml /conf/config.xml

API="/api/zerotier/settings/set/"
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -H "$HEADER" -d \
'{
  "zerotier": {
    "enabled": "1",
    "apiAccessToken": "",
    "localconf": "{\n    \"settings\":\n    {\n        \"interfacePrefixBlacklist\": [\"vmx0\"]\n    }\n}",
    "networks": {
      "network": []
    }
  }
}'

API="/api/zerotier/network/add/" 
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -H "$HEADER" -d \
'{
  "network": {
    "networkId": "d3ecf5726dc241ae",
    "description": "My_VPN"
  }
}'

API="/api/zerotier/network/search/"
#UUID=$(curl -s -k -u $KEY:$SECRET "$HOST$API" -X GET | jq -r '.rows|.[0]|.uuid')
UUID=$(curl -s -k -u $KEY:$SECRET "$HOST$API" -X GET | awk -F '[:,"]' '{print $8}')
API="/api/zerotier/network/toggle/$UUID" 
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -d ""
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -d ""
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -d ""

