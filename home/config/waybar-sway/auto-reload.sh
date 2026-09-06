#!/usr/bin/env bash

while inotifywait -e close_write ~/.config/waybar-sway/; do killall -SIGUSR2 waybar; done
