#!/bin/bash
#############################################################
TMP_DIRECTORY=$(mktemp -d)

Token=$(grep -o 'Token=[^ ]*' $HOME/admin/config/apache/sites.conf | sed 's/Token=//')
UUID=$(grep -o 'UUID=[^ ]*' $HOME/admin/config/apache/sites.conf | sed 's/UUID=//')
VMESS_WSPATH=$(grep -o 'VMESS_WSPATH=[^ ]*' $HOME/admin/config/apache/sites.conf | sed 's/VMESS_WSPATH=//')

UUID=${UUID:-'1bb7c055-8790-4cf4-da53-c9f9bcc669bd'}
VMESS_WSPATH=${VMESS_WSPATH:-'/ray272449844'}
URL=${USER}.alwaysdata.net

wget -q -O $TMP_DIRECTORY/config.json https://raw.githubusercontent.com/hiifeng/V2ray-for-AlwaysData/main/config.json
wget -q -O $TMP_DIRECTORY/Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.5/Xray-linux-64.zip
wget -q -O $TMP_DIRECTORY/cloudflared-linux-amd64 https://github.com/cloudflare/cloudflared/releases/download/2023.4.0/cloudflared-linux-amd64
unzip -oq -d $HOME $TMP_DIRECTORY/Xray-linux-64.zip xray geoip.dat geosite.dat geoip-only-cn-private.dat


sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#$VMESS_WSPATH#g;s#VLESS_WSPATH#$VLESS_WSPATH#g;s#10000#8300#g;s#20000#8400#g;s#127.0.0.1#0.0.0.0#g" $TMP_DIRECTORY/config.json
cp $TMP_DIRECTORY/config.json $HOME
rm -rf $HOME/admin/tmp/*.*

Advanced_Settings=$(cat <<-EOF
#UUID=${UUID}
#VMESS_WSPATH=${VMESS_WSPATH}
#VLESS_WSPATH=${VLESS_WSPATH}
ProxyRequests off
ProxyPreserveHost On
ProxyPass "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
ProxyPassReverse "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
EOF
)
