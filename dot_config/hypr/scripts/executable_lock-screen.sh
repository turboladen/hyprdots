#!/bin/sh

# Times the screen off and puts it to background
swayidle \
    timeout  5 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on && kanshi' &
    # Locks the screen immediately
    swaylock --daemonize

# Kills last background task so idle timer doesn't keep running
kill %%
