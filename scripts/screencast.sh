#!/bin/sh
#
# author: jzbor
#
# source: https://github.com/jzbor/mashup


CC_BLACK="\e[0;30m"
CC_RED="\e[0;31m"
CC_GREEN="\e[0;32m"
CC_YELLOW="\e[0;33m"
CC_BLUE="\e[0;34m"
CC_PURPLE="\e[0;35m"
CC_CYAN="\e[0;36m"
CC_WHITE="\e[0;37m"

CC_xBLACK="\e[0;90m"
CC_xRED="\e[0;91m"
CC_xGREEN="\e[0;92m"
CC_xYELLOW="\e[0;93m"
CC_xBLUE="\e[0;94m"
CC_xPURPLE="\e[0;95m"
CC_xCYAN="\e[0;96m"
CC_xWHITE="\e[0;97m"

CC_BOLD="\e[1m"
CC_RESET="\e[0m"
CC_ULINE="\e[4m"

# for settings that default to false
env_def_false () {
    env_is_set "$1" && [ "$(eval echo "\$$1")" = "1" ]
}

# for settings that default to true
env_def_true () {
    (! env_is_set "$1") || [ "$(eval echo "\$$1")" = "1" ]
}

ask () {
    [ "$1" = "" ] && return 2
    printf "$CC_BLUE::$CC_RESET %s " "$1"
    case "$2" in
        y | yes | Y | Yes | YES)
            printf "$CC_GREEN[Y/n] $CC_RESET" ;;
        *)
            printf "$CC_GREEN[y/N] $CC_RESET" ;;
    esac
    read -r answer
    case $answer in
        y | yes | Y | Yes | YES)
            return 0 ;;
        n | no | N | No | NO)
            return 1 ;;
        *)  case "$2" in
                y | yes | Y | Yes | YES)
                    return 0 ;;
                *)
                    return 1 ;;
            esac
            ;;
    esac
}

die () {
    printf "$CC_RED%s$CC_RESET\n" "$1" > /dev/stderr
    exit 1
}

check_dependencies () {
    for dep in "$@"; do
        command -v "$dep" > /dev/null \
            || die "Dependency $1 not installed"
    done
}

check_optional_dependency () {
    if ! command -v "$1" > /dev/null; then
        printf "$CC_RED%s not found.$CC_RESET\n" "$1" > /dev/stderr
        [ -n "$2" ] \
            && printf "$CC_RED%s is required for: %s$CC_RESET\n" "$1" "$2" > /dev/stderr
        return 1
    fi
    return 0
}

check_optional_dependencies_quiet () {
    for dep in "$@"; do
        command -v "$dep" > /dev/null \
            || return 1
    done
}

env_is_set () {
    env | grep "^$1=" > /dev/null
}

eprint () {
    printf "$CC_RED%s$CC_RESET\n" "$1" > /dev/stderr
}

load_file () {
    FILE=$(readlink -f "$1" 2> /dev/null)
    FILEDIR=$(dirname "$FILE")
    FILENAME=$(basename "$FILE")
    BASENAME="${FILENAME%.*}"
}

check_file () {
    [ -n "${FILE:-$1}" ] || die "No file specified"
    [ -e "${FILE:-$1}" ] || die "File '${FILE:-$1}' not found"
    [ -f "${FILE:-$1}" ] || die "'${FILE:-$1}' is not a file"
}

print_arrow () {
    printf "$CC_GREEN=> %s$CC_RESET\n" "$1"
}

print_header () {
    printf "\n$CC_BLUE$CC_BOLD=== %s ===$CC_RESET\n" "$1"
}

print_help () {
    print_header "Help: $(basename "$0")"
    printf "\n%s\n\n" "$HELPTEXT" | fmt -s
}

print_subheader () {
    printf "\n$CC_CYAN$CC_BOLD$CC_ULINE   %s   $CC_RESET\n" "$1"
}

HELPTEXT="Record screen on X11 (primary screen by default)

    -h  --help      print this message
    -p  --pulse     record audio
    -s  --select    select area with slop
    output          output file"

DEST="${XDG_VIDEOS_DIR:-$HOME/Videos}/Screencasts"
FILENAME="$(date +'Screencast_%Y-%m-%d_%H-%M-%S.mp4')"
RECORD_PULSE=0
RECORD_ALSA=0
SLOP_SELECT=0

check_dependencies ffmpeg xrandr

resolution="$(xrandr | grep primary | cut -d' ' -f4 | grep -o '[0-9]*x[0-9]*')"
offset=""


get_audio () {
    if [ "$RECORD_PULSE" = 1 ]; then
        checkdependencies pulseaudio
        echo "-f pulse -ac 2 -i 0"
    elif [ "$RECORD_ALSA" = 1 ]; then
        echo "-f alsa -ac 2 -i hw:0"
    fi
}

record () {
    [ -d "$DEST" ] || mkdir -vp "$DEST"
    ffmpeg -f x11grab -y -r 60 -s "$resolution" -i ":0.0$offset" \
        $(get_audio) \
        -vcodec h264 -pix_fmt yuv420p \
        -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2" \
        "$DEST/$FILENAME"
}

slop_select () {
    check_dependencies slop
    tmp="$(slop)"
    resolution="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/\1x\2/')"
    offset="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/+\3,\4/')"
}

# parse arguments
while :; do
    case $1 in
        # -a | --alsa) RECORD_ALSA=1; shift ;;
        -h | --help) print_help; exit ;;
        -p | --pulse) RECORD_PULSE=1; shift ;;
        -s | --select) SLOP_SELECT=1; shift ;;
        *) break ;;
    esac
done

if [ -n "$1" ]; then
    if [ -d "$1" ]; then
        DEST="$1"
    else
        DEST="$(dirname "$1")"
        FILENAME="$(basename "$1")"
    fi
fi

[ "$SLOP_SELECT" = 1 ] && slop_select

record
