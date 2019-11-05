#!/bin/bash

# TODO: Multiple inverted windows: Maintain a list of currently-inverted
# windows. If the list exists, add the current window to the list
# TODO: Pipe dream: kill Compton if the inverted window is closed before
# we turn off the inversion.

if [ "$(pidof compton)" ]; then
    pkill compton
else
    id=$(xdotool getactivewindow)
    winclass=$(xprop -id "$id" | grep WM_CLASS | awk '{print $4}')
    compton --invert-color-include "class_g=$winclass" &
fi
