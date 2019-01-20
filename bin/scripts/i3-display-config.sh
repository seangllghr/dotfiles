#!/bin/bash

CONNECTION=$(xrandr | grep "HDMI1" | cut -d' ' -f2)

if [ $CONNECTION = "connected" ]; then
  exec ~/.screenlayout/desktop-multiple.sh
else
  exec ~/.screenlayout/laptop.sh
fi
xset dpms 0 0 600
