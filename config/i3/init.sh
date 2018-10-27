#!/bin/bash

# i3-display-config is a custom script in ~/.bin
bash $HOME/.bin/i3-display-config

nitrogen --restore
setxkbmap -layout us -variant altgr-intl -option caps:swapescape
numlockx off
