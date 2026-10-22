# Shared by the start and stop scripts beside it. Each starts the dock's Chromium
# (chromium-browser: Chromium 114, whose launcher adds the GPU flags from
# /etc/chromium-browser/default) with remote debugging on 127.0.0.1, in a profile
# of its own under /tmp/vynet-chromium, opening the control page — or the URL
# given as the script's first argument.

URL=${1:-${URL:-http://localhost:8085/target.html}}
BASE=/tmp/vynet-chromium

# The desktop session's display, so a script started over ssh opens its window
# and notifications on this screen as one started from the desktop does.
session_env() {
  export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
  if [ -z "$WAYLAND_DISPLAY$DISPLAY" ]; then
    eval "$(systemctl --user show-environment | grep -E '^(DISPLAY|XAUTHORITY|WAYLAND_DISPLAY|DBUS_SESSION_BUS_ADDRESS)=' | sed 's/^/export /')"
  fi
}

say() {
  echo "$1"
  notify-send -i chromium-browser "Chromium $NAME" "$1" 2>/dev/null || true
}

# Wait for the page to answer, a minute at most: started at login, the page may
# be asked for before vynetserver is up, and Chromium does not ask again.
wait_for_page() {
  for i in $(seq 60); do
    curl -s -o /dev/null -m 2 "$URL" && return 0
    sleep 1
  done
  return 1
}

# stop_chromium NAME: stop the Chromium running in that profile, if one is, and
# clear the locks a killed one leaves, which would stop the next from starting.
stop_chromium() {
  pkill -f -- "--user-data-dir=$BASE/$1" && sleep 1
  rm -f "$BASE/$1"/Singleton*
}

# start_chromium NAME PORT [FLAG...]: start it afresh, and say whether it came up.
# The profile is made new every time: one a killed Chromium left asks to restore
# its pages. Nothing asks to be the default browser or for a keyring password.
start_chromium() {
  NAME=$1 PORT=$2
  shift 2
  session_env
  stop_chromium "$NAME"
  rm -rf "${BASE:?}/${NAME:?}"
  mkdir -p "$BASE/$NAME"
  wait_for_page || say "$URL does not answer yet: opening it all the same"
  setsid chromium-browser --remote-debugging-port="$PORT" --user-data-dir="$BASE/$NAME" \
    --no-first-run --no-default-browser-check --password-store=basic \
    "$@" "$URL" > "$BASE/$NAME.log" 2>&1 < /dev/null &
  for i in $(seq 30); do
    if ss -ltn | grep -q "127.0.0.1:$PORT "; then
      say "Started on $URL, remote debugging on 127.0.0.1:$PORT (log: $BASE/$NAME.log)"
      return 0
    fi
    sleep 0.5
  done
  say "Did not start: see $BASE/$NAME.log"
  return 1
}
