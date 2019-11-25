#!/bin/sh

pkill polybar
killall -SIGUSR1 conky
nitrogen --restore
polybar --reload --config=/home/sean/.config/polybar/config openbox-bar
