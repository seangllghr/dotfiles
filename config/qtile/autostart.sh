#!/usr/bin/env bash

setxkbmap -option caps:super,shift:both_capslock_cancel
xcape -e Super_L=Escape
SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
