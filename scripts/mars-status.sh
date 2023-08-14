#/bin/sh
SEPARATOR='\x1f'
BATTERY_PATH='/sys/class/power_supply/BAT0'


### HELPERS

confirmation_submenu () {
	printf "\n\tYou sure?\n\t\t%s" "$1"
}

pa_volume () {
	pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume" | sed 's/.*\/\s*\(.*\) \s*\/.*/\1/;'
}

pa_muted () {
	if pactl get-sink-mute @DEFAULT_SINK@ | grep no > /dev/null; then
		return 1
	else
		return 0
	fi
}

pa_loop () {
	pactl subscribe | grep --line-buffered "Event 'change' on sink " | while read line; do
		update_blocks
	done
}

system_menu () {
SYSTEM_MENU="Logout $(confirmation_submenu 'pkill marswm')
Suspend $(confirmation_submenu 'systemctl suspend')
Poweroff $(confirmation_submenu poweroff)
Reboot $(confirmation_submenu reboot)

Output Profile
$(find ~/.screenlayout -type f | sed 's/^\(.*\)\/\(.*\)\(\.sh\)/\t\2\t\/bin\/sh \1\/\2\3/')"
	echo "$SYSTEM_MENU" | xmenu | /bin/sh
}


### BUTTON HANDLERS

battery_button () {
	profile="$(powerprofilesctl list | sed '/^   /d;/^$/d;s/\(.*\):/\1/' | xmenu | sed 's/.* //')"
	if [ -n "$profile" ]; then
		powerprofilesctl set "$profile"
	fi
	# case "$BUTTON" in
	# 	1) pademelon-widgets ppd-dialog ;;
	# esac
}

volume_button () {
	case "$BUTTON" in
		2) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
		3) media-menu ;;
		4) pactl set-sink-volume @DEFAULT_SINK@ +5% \
			&& canberra-gtk-play -i audio-volume-change ;;
		5) pactl set-sink-volume @DEFAULT_SINK@ -5% \
			&& canberra-gtk-play -i audio-volume-change ;;
	esac
}

date_button () {
	case "$BUTTON" in
		3) system_menu ;;
		*) notify-send "$(date)" ;;
	esac
}


### STATUS BLOCKS

volume_block () {
	if pa_muted; then
		printf 'volume: muted'
	else
		printf 'volume: %s' "$(pa_volume)"
	fi
}

battery_block () {
	if [ -e "$BATTERY_PATH" ]; then
		status="$(cat "$BATTERY_PATH/status")"
		if [ "$status" = 'Charging' ]; then
			printf 'charging: %s' "$(cat /sys/class/power_supply/BAT0/capacity)%"
		else
			printf 'battery: %s' "$(cat /sys/class/power_supply/BAT0/capacity)%"
		fi
	else
		echo "plugged in"
	fi
}

date_block () {
	printf 'date: %s' "$(date +%H:%M)"
}

blocks () {
	printf "%s$SEPARATOR" "$(volume_block)"
	printf "%s$SEPARATOR" "$(battery_block)"
	printf "%s" "$(date_block)"
}

update_blocks () {
	mars-relay set-status "$(blocks)"
}


loop () {
	(pa_loop) &

	while true; do
		update_blocks
		sleep 10
	done
}

if [ "$1" = "action" ]; then
	case "$BLOCK" in
		0) volume_button ;;
		1) battery_button ;;
		2) date_button ;;
		_) echo unhandled ;;
	esac
else
	loop
fi
