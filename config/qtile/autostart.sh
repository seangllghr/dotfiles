#!/usr/bin/env bash

if [ "$(hostname)" != 'Asgard' ]; then
    setxkbmap -option caps:super,shift:both_capslock_cancel
    xcape -e Super_L=Escape
fi
picom &
dunst &
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
