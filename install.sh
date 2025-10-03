#!/bin/bash

DEST="/home/vynet/steam-rtsp/client"
mkdir -p "$DEST"

# Download vynet.html
curl -sL https://raw.githubusercontent.com/ppp4ppp/test3/master/vynet.html -o "$DEST/vynet.html"

# Download bundle.js
curl -sL https://raw.githubusercontent.com/ppp4ppp/test3/master/bundle.js -o "$DEST/bundle.js"

echo "done"

