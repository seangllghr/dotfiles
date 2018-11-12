#!/bin/bash

CONNECTION=$(xrandr | grep "HDMI1" | cut -d' ' -f2)

if [ $CONNECTION = "connected" ]; then
  xrandr --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
    --output eDPI1 --mode 1920x1080 --pos 1920x0 --rotate normal \
    --output VIRTUAL1 --off
  # nitrogen --restore
  # if [ -e $HOME/.config/i3/xautolock.pid ]; then
    # kill $(cat $HOME/.config/i3/xautolock.pid)
  # fi
  # xautolock -detectsleep -time 10 \
    # -locker "i3lock -e -i $HOME/Pictures/multihead.png" &
  # echo $! > $HOME/.config/i3/xautolock.pid
else
  xrandr --output eDPI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
    --output HDMI1 --off \
    --output VIRTUAL1 --off
  # nitrogen --restore
  # if [ -e $HOME/.config/i3/xautolock.pid ]; then
    # kill $(cat $HOME/.config/i3/xautolock.pid)
  # fi
  # xautolock -detectsleep -time 10 \
    # -locker "i3lock -e -i $HOME/Pictures/single_head.png" &
  # echo $! > $HOME/.config/i3/xautolock.pid
fi
xset dpms 0 0 600
