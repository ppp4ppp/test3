echo "installing v3 ....."
mkdir -p /home/vynet/vynetserver/ && mkdir -p /home/vynet/vynetserver/bin  && mkdir -p /home/vynet/vynetserver/config  && mkdir -p /home/vynet/vynetserver/static
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/vynetserver > /home/vynet/vynetserver/vynetserver
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/bin/rtspgpu > /home/vynet/vynetserver/bin/rtspgpu
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/config/layoutsconfig.json > /home/vynet/vynetserver/config/layoutsconfig.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/config/webrtcconfig.json > /home/vynet/vynetserver/config/webrtcconfig.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/static/bundle.js > /home/vynet/vynetserver/static/bundle.js
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev3/vynetserver/static/target.html > /home/vynet/vynetserver/static/target.html
chmod +x /home/vynet/vynetserver/vynetserver
chmod +x /home/vynet/vynetserver/bin/rtspgpu
echo "done"

