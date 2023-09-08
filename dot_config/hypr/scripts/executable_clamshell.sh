#!/usr/bin/bash

if cat /proc/acpi/button/lid/LID/state | grep -q open; then
    hyprctl dispatch dpms on eDP-1
else
    hyprctl dispatch dpms off eDP-1
fi

