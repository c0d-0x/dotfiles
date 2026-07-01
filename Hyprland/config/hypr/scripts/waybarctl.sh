#!/usr/bin/env bash

handle() {
    case $1 in
        activespecial>>*)
            # a special workspace became active — hide waybar
            pkill -SIGUSR1 waybar
            ;;
        activespecial>>)
            # special workspace closed — show waybar
            pkill -SIGUSR1 waybar
            ;;
    esac
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do handle "$line"; done
