#!/bin/bash

connection=$(xrandr | grep "HDMI1" | cut -d' ' -f2)

if [ $connection = "connected" ]; then
  # exec ~/.screenlayout/desktop-multiple.sh # Uncomment for extended displays
  exec ~/.screenlayout/desktop-single.sh # Uncomment for single desktop
else
  exec ~/.screenlayout/laptop.sh
fi
xset dpms 0 0 600
