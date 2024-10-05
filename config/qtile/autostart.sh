#!/usr/bin/env bash

case "$(hostname)" in
  "Asgard")
    setxkbmap -option compose:ralt
    ;;
  *)
    setxkbmap -option caps:super,shift:both_capslock_cancel,compose:ralt
    xcape -e Super_L=Escape
    ;;
esac
picom &
dunst &
xset r rate 300 50 &
alacritty --title "btm-perf" -e btm --theme=gruvbox -C /home/sean/dotfiles/config/btm/config.toml &
blueman-applet &
