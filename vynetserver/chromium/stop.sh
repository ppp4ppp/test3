#!/bin/bash
# Stop the Chromium these scripts started. The dock icon's own is left alone.
. "$(dirname "$(readlink -f "$0")")/common.sh"
NAME=
session_env
for n in headless window; do stop_chromium "$n"; done
say "Stopped the headless and window Chromium"
