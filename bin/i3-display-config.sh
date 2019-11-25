#!/bin/bash

read_connected_displays () {
    connectedDisplays="$(xrandr | awk '/ connected/{print $1; getline; print $1}')"
    IFS=' ' read -r -a tempArray <<< $(echo $connectedDisplays)

    for i in "${!tempArray[@]}"; do
        if [[ $(($i % 2)) -eq 0 ]]; then
            displayArray["${tempArray[$i]}"]="${tempArray[$((i+1))]}"
        fi
    done
}

print_connected_displays () {
    for display in ${!displayArray[@]}; do
        echo "$display --- ${displayArray[$display]}"
    done
}

single_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --off
        configmsg="Configured HDMI1 as Primary at ${displayArray['HDMI1']}"
    elif test "${displayArray['LVDS-0']+isset}"; then
        xrandr --output VGA-0 --primary --mode ${displayArray[VGA-0]} --pos 0x0 --rotate normal \
               --output LVDS-0 --off
        configmsg="Configured VGA-0 as Primary at ${displayArray['VGA-0']}"
    else
        echo "Unrecognized system. Please configure manually."
    fi
    pkill conky
    conky -c ~/.config/conky/conky_maia.conkyrc &
    nitrogen --restore
    notify-send -u low -t 5000 "$configmsg"
}

laptop_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output eDP1 --primary --mode ${displayArray[eDP1]} --pos 0x0 --rotate normal \
               --output HDMI1 --off --output VIRTUAL1 --off
        configmsg="Configured eDP1 as Primary at ${displayArray['eDP1']}"
    elif test "${displayArray['LVDS-0']+isset}"; then
        xrandr --output LVDS-0 --primary --mode ${displayArray[LVDS-0]} --pos 0x0 --rotate normal \
               --output VGA-0 --off
        configmsg="Configured LVDS-0 as Primary at ${displayArray['LVDS-0']}"
    else
        echo "Unrecognized system. Please configure manually."
    fi
    pkill conky
    conky -c ~/.config/conky/conky_maia.conkyrc &
    nitrogen --restore
    notify-send -u low -t 5000 "$configmsg"
}

extend_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --off
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --mode ${displayArray[eDP1]} \
               --pos $(echo ${displayArray[HDMI1]} | cut -d'x' -f 1)x0
               --rotate normal --output VIRTUAL1 --off
        configmsg="Configured HDMI1 as Primary at ${displayArray['HDMI1']} and eDP1 as secondary at ${displayArray[eDP1]}"
    elif test "${displayArray['LVDS-0']+isset}"; then
        #LVDS-0 is a low-resolution panel that tends to sit low. Calculate a good position for it:
        primaryWidth=$(echo ${displayArray[VGA-0]} | cut -d'x' -f 1)
        primaryHeight=$(echo ${displayArray[VGA-0]} | cut -d'x' -f 2)
        secondaryHeight=$(echo ${displayArray[LVDS-0]} | cut -d'x' -f 2)
        xrandr --output VGA-0 --primary --mode ${displayArray[VGA-0]} --pos 0x0 --rotate normal \
               --output LVDS-0 --off
        xrandr --output VGA-0 --primary --mode ${displayArray[VGA-0]} --pos 0x0 --rotate normal \
               --output LVDS-0 --rotate normal --mode ${displayArray[LVDS-0]} \
               --pos ${primaryWidth}x$(($primaryHeight - $secondaryHeight))
        configmsg="Configured VGA-0 as Primary at ${displayArray['VGA-0']} and LVDS-0 as secondary at ${displayArray[LVDS-0]}"
    else
        echo "Unrecognized system. Please configure manually."
    fi
    pkill conky
    conky -c ~/.config/conky/conky_maia.conkyrc &
    nitrogen --restore
    notify-send -u low -t 5000 "$configmsg"
}

# NOTE: Currently supported display configurations:
#       - Desktop single-monitor (HDMI1 or VGA-0)
#       - Desktop extended-display (HDMI1 or VGA-0 with laptop display eDP1 or
#           LVDS-0, respectively)
#       - Laptop single-display (eDP1 or LVDS-0)
#       - Possibly display mirroring. But probably not, because lazy.

# Initial loading
str=$(readlink -f $(which i3-display-config))
installdir=${str%/*}
declare -A displayArray
read_connected_displays

case $1 in
    '-s') : ;&
    '--single')
        single_display
        ;;
    '-l') : ;&
    '--laptop')
        laptop_display
        ;;
    '-e') : ;&
    '--extend')
        extend_display
        ;;
    # TODO: Mirroring?
    # TODO: Probably the dock, however the fuck that works...
esac

# xset dpms 0 0 600
