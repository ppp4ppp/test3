echo "installing v1 build3 ....."
mkdir -p /home/vynet/steam-rtsp/client/imgs && \
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/targetv4.html > /home/vynet/steam-rtsp/client/target.html
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/bundlev2b4.js > /home/vynet/steam-rtsp/client/bundlev2.js
touch /home/vynet/steam-rtsp/client/init
echo "done"

