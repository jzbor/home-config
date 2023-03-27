#!/bin/sh

players () {
	playerctl -l
}

property_for_player () {
	playerctl metadata -p "$1" | grep "xesam:$2" | sed 's/^\([a-zA-Z]*\) xesam:\([a-zA-Z]*\) *\(.*\)/\3/'
}

get_play_pause_label () {
	if [ "$(playerctl status -p "$1")" = "Playing" ]; then
		echo "pause"
	else
		echo "play"
	fi
}

build_player () {
	echo "$1"
	printf "\t%s - %s\n" "$(property_for_player "$1" title)" "$(property_for_player "$1" artist)"
	printf "\t%s\tplayerctl play-pause -p \"%s\"\n" "$(get_play_pause_label "$1")" "$1"
	printf "\tnext\tplayerctl next -p \"%s\"\n" "$1"
	printf "\tprevious\tplayerctl prev -p \"%s\"\n" "$1"
}

gen_menu () {
	for player in $(players); do
		build_player "$player"
	done
}

gen_menu | xmenu | /bin/sh

# players | xmenu
# build_player spotify
