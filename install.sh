#!/bin/bash
# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID=${UUID:-'1bb7c055-8790-4cf4-da53-c9f9bcc669bd'}
VMESS_WSPATH=${VMESS_WSPATH:-'/ray272449844'}
Token=${Token:-'eyJhIjoiYjQ2N2Q5MGUzZDYxNWFhOTZiM2ZmODU5NzZlY2MxZjgiLCJ0IjoiYTNlMTg0NWItYTJmNS00YjZjLTg4YzUtZDNiNDBiYjFkNjk4IiwicyI6Ik5XUTJaRE0zWVdZdFpUazRZeTAwTm1ReUxXRTRZemt0WXpFNU1EWTVZbVJqTXpVeiJ9'}

wget -O config.json https://raw.githubusercontent.com/wwrrtt/always/main/config.json
wget -O web https://github.com/wwrrtt/always/raw/main/web
wget -O argo https://github.com/cloudflare/cloudflared/releases/download/2023.4.0/cloudflared-linux-amd64
chmod +x web && chmod +x argo

cat << EOF >config.json
{
    "log":{
        "access":"/dev/null",
        "error":"/dev/null",
        "loglevel":"none"
    },
    "inbounds": [
    {
      "port":8880,
      "listen":"127.0.0.1",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
        "path": "$VMESS_WSPATH"
        }
      }
    }
  ],
    "dns":{
        "servers":[
            "https+local://8.8.8.8/dns-query"
        ]
    },
    "outbounds":[
        {
            "protocol":"freedom"
        },
        {
            "tag":"WARP",
            "protocol":"wireguard",
            "settings":{
                "secretKey":"cKE7LmCF61IhqqABGhvJ44jWXp8fKymcMAEVAzbDF2k=",
                "address":[
                    "172.16.0.2/32",
                    "fd01:5ca1:ab1e:823e:e094:eb1c:ff87:1fab/128"
                ],
                "peers":[
                    {
                        "publicKey":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
                        "endpoint":"162.159.193.10:2408"
                    }
                ]
            }
        }
    ],
    "routing":{
        "domainStrategy":"AsIs",
        "rules":[
            {
                "type":"field",
                "domain":[
                    "domain:openai.com",
                    "domain:ai.com"
                ],
                "outboundTag":"WARP"
            }
        ]
    }
}
EOF

cat config.json | base64 > config
rm -f config.json
base64 -d config > config.json
rm -f config


nohup ./argo tunnel --edge-ip-version auto run --token $Token  >/dev/null 2>&1 &
nohup ./web -config ./config.json >/dev/null 2>&1 &
