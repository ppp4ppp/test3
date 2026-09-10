echo "installing demo ....."
mkdir -p /home/fsn24/repo/Vy-Net3-Demo-demotag/release/imgs && \
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/fsn.png > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/imgs/fsn.png
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/vynet3.png > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/imgs/vynet3.png
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/bulma.min.css > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/bulma.min.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/vynetv14.html > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/vynet.html
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/layoutv14.css > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/layout.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/videocontrolv14.css > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/videocontrol.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/navv14.css > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/nav.css
wget -qO- https://raw.githubusercontent.com/ppp4ppp/test3/master/configv14.json > /home/fsn24/repo/Vy-Net3-Demo-demotag/release/config.json
touch /home/fsn24/repo/Vy-Net3-Demo-demotag/release/init.json
touch /home/fsn24/repo/Vy-Net3-Demo-demotag/release/reset.json
echo "done"
