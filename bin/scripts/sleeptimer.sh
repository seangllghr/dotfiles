#!/bin/bash

# Temporarily change the screen lock time

timer=$1

pkill xautolock
if [ $timer -lt 10 ]; then
  sleep $(($timer*60))
  blurlock
  xautolock -time 10 -locker blurlock &
else
  sleep $((($timer*60)-(600)))
  xautolock -time 10 -locker blurlock &
fi
