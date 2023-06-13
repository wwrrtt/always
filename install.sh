#!/bin/bash
# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
export PORT=${PORT-8080}
export UUID=${UUID:-'1bb7c055-8790-4cf4-da53-c9f9bcc669bd'}
export VMESS_WSPATH=${VMESS_WSPATH:-'/ray272449844'}
export Token=${Token:-'eyJhIjoiYjQ2N2Q5MGUzZDYxNWFhOTZiM2ZmODU5NzZlY2MxZjgiLCJ0IjoiNjNkZjg1MDQtNTA4My00MjU2LTk2ZmMtOWVjZGQxM2NjMTk5IiwicyI6Ik1qWXpOMk0zWTJRdE9ESTVOUzAwWlRnNUxUbGhNamt0TmpoaU5qZzBObUprWkdFNCJ9'}

wget -O config.json https://raw.githubusercontent.com/wwrrtt/always/main/config.json
wget -O cake https://github.com/wwrrtt/always/raw/main/cake
wget -O cf https://github.com/cloudflare/cloudflared/releases/download/2023.5.0/cloudflared-linux-amd64
chmod +x cake && chmod +x cf

cat << EOF >config.json
{
  "log": {
    "level": "info"
  },
"inbounds": [
		{
			"type": "vmess",
			"tag": "vmess-in",
			"listen": "0.0.0.0",
			"listen_port": $PORT,
			"tcp_fast_open": false,
			"sniff": false,
			"sniff_override_destination": false,
			"domain_strategy": "prefer_ipv4",
			"proxy_protocol": false,
			"users": [
				{
					"name": "kid",
					"uuid": "$UUID",
					"alterId": 0
				}
			],
			"transport": {
				"type": "ws",
				"path": "$VMESS_WSPATH"
			}
		}

  ],
    "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ]
}
EOF

cat config.json | base64 > config
rm -f config.json
base64 -d config > config.json
rm -f config


nohup ./cf tunnel --edge-ip-version auto run --token $Token  >/dev/null 2>&1 &
nohup ./cake run ./config.json >/dev/null 2>&1 &
