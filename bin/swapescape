#!/usr/bin/bash

if [ $1 = "-s" ]
then
  setxkbmap -option caps:swapescape
  setxkbmap -option shift:both_capslock_cancel
  sleep 0.25
  if [ $(xset q | grep Caps | awk '{print $4}') = "on" ]; then
    xdotool key Caps_Lock
  fi
else
  setxkbmap -option
fi
