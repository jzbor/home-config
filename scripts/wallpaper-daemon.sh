#!/bin/sh

xev -root -event randr | grep --line-buffered XRROutputChangeNotifyEvent | while read -r; do
	echo "new event - setting wallpaper"
	xwallpaper --zoom ~/.background-image
done
