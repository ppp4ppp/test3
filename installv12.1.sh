echo "installing v12.1 ....."
mkdir -p /home/vynet/steam-rtsp/client/imgs && \
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/fsn.png > /home/vynet/steam-rtsp/client/imgs/fsn.png
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/vynet3.png > /home/vynet/steam-rtsp/client/imgs/vynet3.png
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/bulma.min.css > /home/vynet/steam-rtsp/client/bulma.min.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/vynetv12.1.html > /home/vynet/steam-rtsp/client/vynet.html
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/layoutv12.1.css > /home/vynet/steam-rtsp/client/layout.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/videocontrolv12.1.css > /home/vynet/steam-rtsp/client/videocontrol.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/navv12.1.css > /home/vynet/steam-rtsp/client/nav.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/configv12.1.json > /home/vynet/steam-rtsp/client/config.json
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/bundlev12.1.js > /home/vynet/steam-rtsp/client/bundle.js
touch /home/vynet/steam-rtsp/client/init.json
touch /home/vynet/steam-rtsp/client/reset.json
echo "done"

