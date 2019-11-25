#!/bin/sh

pkill conky
conky -c ~/.config/conky/conky_maia.conkyrc &

exit 0
