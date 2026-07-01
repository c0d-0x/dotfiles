#!/usr/bin/env bash

if ! pidof hyprpaper >/dev/null 2>&1; then
    echo "hyprpaper is not running, starting it..."
    nohup hyprpaper >/dev/null 2>&1 &
    sleep 1
fi

SCRIPTS=~/.config/hypr/scripts
WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

if [[ "$1" == "--img" ]]; then
    if [[ "$2" == "" ]] ; then
        printf "usage: set_bg [ --img <path> ]\n"
        exit 1
    fi

    if [ ! -f "$2" ]; then
        echo "$2 not found!"
        exit 1
    fi

    WALLPAPER=$(realpath -z $2)
elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printf "usage: chwall [ --img <path> ]\n"
    exit 1

else
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f -iregex '.*\.\(jpg\|png\)$' | shuf -n 1)
fi

hyprctl hyprpaper wallpaper ", $WALLPAPER" &

hellwal -i $WALLPAPER -b 0.5 -g 0.09 --static-background "#000000" --static-foreground "#FFFFFF" --skip-term-colors &
ln -sf $WALLPAPER ~/.bg
hyprctl reload hyprland
swaync-client -rs
exit 0
