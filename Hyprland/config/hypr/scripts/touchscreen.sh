#!/usr/bin/env bash

DEVICE="elan-touchscreen"

if [[ "$1" == "--off" ]]; then
    hyprctl dispatch "hl.device({name = $DEVICE, enabled = true})"
    notify-send "Touchscreen disabled"
elif [[ "$1" == "--on" ]]; then
    hyprctl keyword device\["$DEVICE"\]:enabled true
    notify-send "Touchscreen enabled"
fi
