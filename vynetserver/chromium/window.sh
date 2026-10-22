#!/bin/bash
# Chromium full screen on this screen, with no address bar or tabs (kiosk), as
# the dock icon starts it otherwise, remote debugging on 127.0.0.1:9334, opening
# the control page. Alt+F4 closes it, as does the stop launcher. From another
# machine: ssh -N -L 9334:127.0.0.1:9334 pi.
. "$(dirname "$(readlink -f "$0")")/common.sh"
# A native Wayland window: under XWayland GNOME leaves a kiosk window a part of
# the screen rather than all of it.
start_chromium window 9334 --kiosk --ozone-platform=wayland
