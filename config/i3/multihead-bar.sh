#!/bin/sh

MON_EXTERN=$(xrandr | awk '$1=="HDMI-1-1"{print $8}')

if [ $MON_EXTERN = "connected" ]; then
  echo "bar { output eDP-1-1 }"
fi
