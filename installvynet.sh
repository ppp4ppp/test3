echo "installing v9 ....."
mkdir -p /home/vynet/vynetserver/ && mkdir -p /home/vynet/vynetserver/bin  && mkdir -p /home/vynet/vynetserver/config  && mkdir -p /home/vynet/vynetserver/static
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/bin/arm/vynetserver > /home/vynet/vynetserver/vynetserver
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/bin/arm/rtspgpu > /home/vynet/vynetserver/bin/rtspgpu
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/config/layoutsconfig.json > /home/vynet/vynetserver/config/layoutsconfig.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/config/config.json > /home/vynet/vynetserver/config/config.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/config/webrtc.json > /home/vynet/vynetserver/config/webrtc.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/static/bundle.js > /home/vynet/vynetserver/static/bundle.js
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/releasev9/vynetserver/static/target.html > /home/vynet/vynetserver/static/target.html
chmod +x /home/vynet/vynetserver/vynetserver
chmod +x /home/vynet/vynetserver/bin/rtspgpu
echo "done"

