#!/bin/bash

CONNECTION=$(xrandr | grep "HDMI-1-1" | cut -d' ' -f2)

if [ $CONNECTION = "connected" ]; then
  xrandr --output HDMI-1-1 --left-of eDP-1-1 --auto --primary
  nitrogen --restore
  # if [ -e $HOME/.config/i3/xautolock.pid ]; then
    # kill $(cat $HOME/.config/i3/xautolock.pid)
  # fi
  # xautolock -detectsleep -time 10 \
    # -locker "i3lock -e -i $HOME/Pictures/multihead.png" &
  echo $! > $HOME/.config/i3/xautolock.pid
else
  xrandr --auto
  xrandr --output eDP-1-1 --primary
  nitrogen --restore
  # if [ -e $HOME/.config/i3/xautolock.pid ]; then
    # kill $(cat $HOME/.config/i3/xautolock.pid)
  # fi
  # xautolock -detectsleep -time 10 \
    # -locker "i3lock -e -i $HOME/Pictures/single_head.png" &
  echo $! > $HOME/.config/i3/xautolock.pid
fi
xset dpms 0 0 600
