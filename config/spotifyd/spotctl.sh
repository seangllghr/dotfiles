#!/bin/bash

# TODO: Rather than pass the decrypted password as an arg, pass a doctored
#       config on stdin?
# exec spotifyd -p $(gpg -d ~/.config/spotifyd/cred.gpg)

# TODO: This script used to do neat control stuff. Reimplement that.

spotddir="/home/sean/.config/spotifyd"
pidfile="$spotddir/pid"
credfile="$spotddir/cred.gpg"

print_help() {
  echo ""
  echo "    spotctl [action]"
  echo ""
  echo "Actions:"
  echo "  start:    Start the Spotify Daemon"
  echo "  stop:     Stop the Spotify Daemon"
  echo "  restart:  Restart the Spotify Daemon"
  echo "  status:   Display status information"
}

start_spotifyd() {
  if [ -e $pidfile ]
  then
    echo "Daemon is already running. Use spotifyd restart to restart."
  else
    spotifyd \
      -p $(gpg -d $credfile)\
      --pid $pidfile
    echo "PID: $(cat $pidfile)"
  fi
}

stop_spotifyd() {
  if [ -e $pidfile ]
  then
    kill $(cat $pidfile)
    rm $pidfile
  else
    echo "Daemon is not running"
  fi
}

if [ $# -eq 0 ]
then
  print_help
else
  echo 'This script is deprecated. Please start spotifyd with'
  echo '`systemctl --user start spotifyd`'
  exit
  case $1 in
    "start")
      echo "Starting"
      start_spotifyd
      ;;
    "stop")
      echo "Stopping"
      stop_spotifyd
      ;;
    "restart")
      echo "Restarting"
      stop_spotifyd
      start_spotifyd
      ;;
    "status")
      echo "Status!"
      ;;
    *)
      print_help
      ;;
  esac
fi
