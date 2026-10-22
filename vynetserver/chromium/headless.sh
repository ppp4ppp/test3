#!/bin/bash
# Headless Chromium on the Mali GPU, remote debugging on 127.0.0.1:9333, opening
# the control page. From another machine: ssh -N -L 9333:127.0.0.1:9333 pi, and
# drive it on localhost:9333.
. "$(dirname "$(readlink -f "$0")")/common.sh"
# With no display Mesa's EGL looks for an X server, the GPU process gives up and
# WebGL falls back to SwiftShader; its surfaceless platform draws on the GPU with
# no display at all.
export EGL_PLATFORM=surfaceless
start_chromium headless 9333 --headless=new --window-size=1600,1000
