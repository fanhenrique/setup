#!/bin/sh

PIDFILE="/tmp/waybar-cpu-popup.pid"

if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE")"

    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PIDFILE"
        exit 0
    fi

    rm -f "$PIDFILE"
fi

POSITION="$(wlrctl pointer position)"

if [ -z "$POSITION" ]; then
    exit 1
fi

X="${POSITION%% *}"

python3 ~/.config/waybar/scripts/gtk-popup.py \
    "CPU" \
    "CPU information" \
    "$X" &

echo $! > "$PIDFILE"