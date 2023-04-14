#!/bin/bash
# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID=${UUID:-'1bb7c055-8790-4cf4-da53-c9f9bcc669bd'}
VMESS_WSPATH=${VMESS_WSPATH:-'/ray272449844'}
Token=${Token:-'eyJhIjoiYjQ2N2Q5MGUzZDYxNWFhOTZiM2ZmODU5NzZlY2MxZjgiLCJ0IjoiNmZlMjE3MDEtYmRhOC00MzczLWIxMzAtYTkwOGMyZGUzZWJkIiwicyI6Ik1UUTBNMlUxTkRRdE1UazBaaTAwTW1FeUxUazFOalV0WVRObVl6RXlPVGhoTkRsbSJ9'}

wget -O config.json https://raw.githubusercontent.com/wwrrtt/always/main/config.json
wget -O web https://github.com/wwrrtt/always/raw/main/web
wget -O argo https://github.com/cloudflare/cloudflared/releases/download/2023.4.0/cloudflared-linux-amd64
chmod +x web && chmod +x argo

./web -config ./config.json && ./argo tunnel --edge-ip-version auto run --token $Toke
