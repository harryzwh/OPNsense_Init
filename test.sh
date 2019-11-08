#!/bin/bash


KEY="duSMPU4Otj0H9N2wpoD0ee7Aq5y49y230gpOJttq4RAZID6ylzoNaj4kIHwsx8AVCxBGr0PvH9KVbmji"
SECRET="jwAtBm0sj4QCOIiHFO/7/PB0/+AHcBBESEhelNeWYYe0wFqiTD3hgcCtUBXD8ZPhynCPGNp0mSbyCb61"

HOST="https://192.168.58.208"
HEADER="Content-Type: application/json"

:<<'COMMENT'
API="/api/zerotier/settings/get/"
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
}' | jq


API="/api/zerotier/network/add/" 
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -H "$HEADER" -d \
'{
  "network": {
    "networkId": "d3ecf5726dc241ae",
    "description": "My_VPN"
  }
}' | jq
COMMENT

API="/api/zerotier/network/search/"
#UUID=$(curl -s -k -u $KEY:$SECRET "$HOST$API" -X GET | jq -r '.rows|.[0]|.uuid')
UUID=$(curl -s -k -u $KEY:$SECRET "$HOST$API" -X GET | awk -F '[:,"]' '{print $8}')
API="/api/zerotier/network/toggle/$UUID" 
curl -k -u $KEY:$SECRET "$HOST$API" -X POST -d "" | jq
