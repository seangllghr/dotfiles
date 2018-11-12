#!/bin/bash
# This script is no longer utilized in my Manjaro installation. It remains
# as reference.

CONNECTION=$(xrandr | grep "HDMI-1-1" | cut -d' ' -f2)

if [ -e $HOME/.config/i3/xautolock.pid ]; then
  kill $(cat $HOME/.config/i3/xautolock.pid)
fi
if [ $CONNECTION = "connected" ]; then
  xset dpms 0 0 10
  i3lock -n -e -i $HOME/Pictures/multihead.png
  xautolock -detectsleep -time 10 \
    -locker "i3lock -e -i $HOME/Pictures/multihead.png" &
  echo $! > $HOME/.config/i3/xautolock.pid
  xset dpms 0 0 600
else
  xset dpms 0 0 10
  i3lock -n -e -i $HOME/Pictures/single_head.png
  xautolock -detectsleep -time 10 \
    -locker "i3lock -e -i $HOME/Pictures/single_head.png" &
  echo $! > $HOME/.config/i3/xautolock.pid
  xset dpms 0 0 600
fi
