#!/usr/bin/bash

if [ $1 = "-s" ]
then
  setxkbmap -option caps:swapescape
  setxkbmap -option shift:both_capslock_cancel
  sleep 0.125
  xdotool key Caps_Lock
else
  setxkbmap -option
fi
