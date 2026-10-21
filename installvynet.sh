VERSION=14

echo "installing v$VERSION ....."

OLD_SERVICES="steam-rtsp.service rtsp-stream.service rtspgpu.service"

# stop old rtsp services and a running vynetserver before binaries are replaced
for s in $OLD_SERVICES vynetserver.service; do
  sudo systemctl stop "$s" 2>/dev/null
done
for s in $OLD_SERVICES; do
  sudo systemctl disable "$s" 2>/dev/null
done

mkdir -p /home/vynet/vynetserver/ && mkdir -p /home/vynet/vynetserver/bin  && mkdir -p /home/vynet/vynetserver/config  && mkdir -p /home/vynet/vynetserver/static && mkdir -p /home/vynet/vynetserver/log
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/bin/arm/vynetserver > /home/vynet/vynetserver/vynetserver
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/bin/arm/rtspgpu > /home/vynet/vynetserver/bin/rtspgpu
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/config/layoutsconfig.json > /home/vynet/vynetserver/config/layoutsconfig.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/config/config.json > /home/vynet/vynetserver/config/config.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/config/webrtc.json > /home/vynet/vynetserver/config/webrtc.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/static/bundle.js > /home/vynet/vynetserver/static/bundle.js
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev$VERSION/vynetserver/static/target.html > /home/vynet/vynetserver/static/target.html
chmod +x /home/vynet/vynetserver/vynetserver
chmod +x /home/vynet/vynetserver/bin/rtspgpu

# rename bundle.js to bundlev$VERSION.js and set the version shown in target.html to 1.0.$VERSION
rm -f /home/vynet/vynetserver/static/bundlev*.js
mv /home/vynet/vynetserver/static/bundle.js /home/vynet/vynetserver/static/bundlev$VERSION.js
sed -i -e "s#\./bundle\.js#./bundlev$VERSION.js#" -e "s#v1\.0\.[0-9]\+#v1.0.$VERSION#" /home/vynet/vynetserver/static/target.html

echo "installing vynetserver.service ....."
sudo tee /etc/systemd/system/vynetserver.service > /dev/null <<'EOF'

sudo mkdir -p /etc/systemd/system/vynetserver.service.d
sudo tee /etc/systemd/system/vynetserver.service.d/network-online.conf >/dev/null <<'EOF'
[Unit]
Wants=network-online.target
After=network-online.target
Description=VyNet Server
After=network.target

[Service]
WorkingDirectory=/home/vynet/vynetserver
ExecStart=/home/vynet/vynetserver/vynetserver
Restart=always
RestartSec=2
User=vynet

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable vynetserver.service
sudo systemctl restart vynetserver.service

# check: old services stopped and disabled, vynetserver enabled and running
sleep 3
for s in $OLD_SERVICES; do
  if systemctl is-active --quiet "$s" || systemctl is-enabled --quiet "$s" 2>/dev/null; then
    echo "ERROR: $s is still running or enabled"
    exit 1
  fi
  echo "$s: stopped and disabled"
done
if ! systemctl is-enabled --quiet vynetserver.service || ! systemctl is-active --quiet vynetserver.service; then
  echo "ERROR: vynetserver.service is not enabled and running"
  sudo systemctl status vynetserver.service --no-pager
  exit 1
fi
echo "vynetserver.service: enabled and running"
echo "done"

