#!/bin/bash
case $1/$2 in
  pre/*)
    echo "Going to $2..."
    ;;
  post/*)
    echo "Waking up from $2..."
    cd /home/sean/orgfiles && sudo --user=sean git pull origin master
    ;;
esac
