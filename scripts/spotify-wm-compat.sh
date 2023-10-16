#!/bin/sh

if ! command -v spotify > /dev/null; then
	echo "Spotify is not installed"
	exit 1
fi

if pidof .spotify-wrapped > /dev/null; then
    for wid in $(xdotool search --class spotify | tr '\n' ' '); do
        mars-relay -w "$wid" activate
    done
else
    spotify &
    xid=""
    while [ -z "$xid" ]; do
        xid="$(xdotool search --class spotify)"
        sleep 0.2
    done
    sleep 0.5
    for xid in $(xdotool search --class spotify); do
	mars-relay -w "$xid" send-to-workspace 7
    done
fi
