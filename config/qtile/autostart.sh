#!/usr/bin/env bash

case "$(hostname)" in
  "Asgard")
    setxkbmap -option shift:both_capslock_cancel,compose:ralt
    ;;
  *)
    setxkbmap -option caps:super,shift:both_capslock_cancel,compose:ralt
    xcape -e Super_L=Escape
    ;;
esac
picom &
dunst &
xset r rate 300 50 &
light-locker &
xplugd &
