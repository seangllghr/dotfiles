#!/bin/bash

test_network () {
    if nmcli connection | grep "wlp12s0b1">&/dev/null; then
        if [ $(nmcli connection | grep "wlp12s0b1" | awk '{print $1}') = "Yggdrasil" ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

wait_for_network () {
    timer=120
    while [ $timer -gt 0 ]; do
        if test_network; then
            return 0
        fi
        echo -ne "Home network not detected. Waiting $timer seconds.\033[0K\r"
        sleep 1
        : $((timer--))
    done
    return 1
}

wait_for_server () {
    timer=15
    while [ $timer -gt 0 ]; do
        if ! ping -c 1 -w 1 alfheim>&/dev/null; then
            echo -ne "Alfheim is not online. Waiting $timer seconds.\033[0K\r"
            : $((timer--))
        else
            return 0
        fi
    done
    return 1
}

sleep 30
if wait_for_network; then
    echo "Home network found. Attempting to mount network shares."
    notify-send -u low -t 3000 "Home network found. Attempting to mount network shares."
    if wait_for_server; then
        mount /home/sean/Documents
        mount /home/sean/Downloads
        notify-send -u low -t 3000 "Mount successful."
    else
        notify-send -u normal -t 5000 "Alfheim is not online. Mount failed."
    fi
else
    echo "Home network not found. Cannot mount network shares."
fi
