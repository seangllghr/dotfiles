#!/bin/bash

xrandr --output HDMI1 --primary --mode 1600x900 --pos 0x0 --rotate normal\
  --output VIRTUAL1 --off --output eDP1 --off
xrandr --output HDMI1 --primary --mode 1600x900 --pos -1600x0 --rotate normal\
  --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal\
  --output VIRTUAL1 --off
