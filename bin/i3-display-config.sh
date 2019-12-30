#!/bin/bash

read_connected_displays () {
    connectedDisplays="$(xrandr | awk '/ connected/{print $1; getline; print $1}')"
    IFS=' ' read -r -a tempArray <<< $(echo $connectedDisplays)

    for i in "${!tempArray[@]}"; do
        if [[ $(($i % 2)) -eq 0 ]]; then
            displayArray["${tempArray[$i]}"]="${tempArray[$((i+1))]}"
        fi
    done
    disconnectedDisplays="$(xrandr | awk '/disconnected/{print $1;}')"
    IFS=' ' read -r -a disconnectedArray <<< $(echo $disconnectedDisplays)
}

print_connected_displays () {
    for display in ${!displayArray[@]}; do
        echo "$display --- ${displayArray[$display]}"
    done
    echo "$(for display in ${!disconnectedArray[@]}; do
        echo "${disconnectedArray[$display]} --- disconnected \\"
    done)"
}

single_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --off
        configmsg="Configured HDMI1 as Primary at ${displayArray['HDMI1']}"
        configError=0
    elif test "${displayArray['LVDS-0']+isset}"; then
        if [ $singleSide = "right" ]; then
            xrandr --output DP-1 --primary --mode ${displayArray[DP-1]} --pos 0x0 --rotate normal \
                   --output LVDS-0 --off --output VGA-0 --off --output DP-0 --off
            configmsg="Configured DP-1 as Primary at ${displayArray['DP-1']}"
            configError=0
        else
            xrandr --output DP-0 --primary --mode ${displayArray[DP-0]} --pos 0x0 --rotate normal \
                --output LVDS-0 --off --output DP-1 --off
            configmsg="Configured DP-0 as Primary at ${displayArray['DP-0']}"
            configError=0
        fi
    else
        configmsg="Unrecognized system. Please configure manually."
        configError=1
    fi
    post_config
}

laptop_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output eDP1 --primary --mode ${displayArray[eDP1]} --pos 0x0 --rotate normal \
               --output HDMI1 --off --output VIRTUAL1 --off
        configmsg="Configured eDP1 as Primary at ${displayArray['eDP1']}"
        configError=0
    elif test "${displayArray['LVDS-0']+isset}"; then
        xrandr --output LVDS-0 --primary --mode ${displayArray[LVDS-0]} --pos 0x0 --rotate normal \
               --output VGA-0 --off
        configmsg="Configured LVDS-0 as Primary at ${displayArray['LVDS-0']}"
        configError=0
    else
        configmsg="Unrecognized system. Please configure manually."
        configError=1
    fi
    post_config
}

extend_display () {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --off
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --mode ${displayArray[eDP1]} \
               --right-of HDMI1 --rotate normal
        configmsg="Configured HDMI1 as Primary at ${displayArray['HDMI1']} and eDP1 as secondary at ${displayArray[eDP1]}"
        configError=0
    elif test "${displayArray['LVDS-0']+isset}"; then
        #LVDS-0 is a low-resolution panel that tends to sit low. Calculate a good position for it:
        primaryWidth=$(echo ${displayArray[VGA-0]} | cut -d'x' -f 1)
        primaryHeight=$(echo ${displayArray[VGA-0]} | cut -d'x' -f 2)
        secondaryHeight=$(echo ${displayArray[LVDS-0]} | cut -d'x' -f 2)
        xrandr --output VGA-0 --primary --mode ${displayArray[VGA-0]} --pos 0x0 --rotate normal \
               --output LVDS-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off
        xrandr --output VGA-0 --primary --mode ${displayArray[VGA-0]} --pos 0x0 --rotate normal \
               --output LVDS-0 --rotate normal --mode ${displayArray[LVDS-0]} \
               --pos ${primaryWidth}x$(($primaryHeight - $secondaryHeight))
        configmsg="Configured VGA-0 as Primary at ${displayArray['VGA-0']} and LVDS-0 as secondary at ${displayArray[LVDS-0]}. Manual positioning may be required."
        configError=0
    else
        configmsg="Unrecognized system. Please configure manually."
        configError=1
    fi
    post_config
}

mirror_display() {
    if test "${displayArray['eDP1']+isset}"; then
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --off
        xrandr --output HDMI1 --primary --mode ${displayArray[HDMI1]} --pos 0x0 --rotate normal \
               --output VIRTUAL1 --off --output eDP1 --mode ${displayArray[eDP1]} --pos 0x0 \
               --rotate normal
        configmsg="Configured Mirrored Display on HDMI1 and eDP1 at ${displayArray[HDMI1]}"
        configError=0
    else
        configmsg="Mirroring is not currently supported on this system. Please configure manually."
        configError=1
    fi
    post_config
}

dock_dual() {
    if test "${displayArray['LVDS-0']+isset}"; then
        xrandr --output DP-0 --primary --mode ${displayArray[DP-0]} --pos 0x0 --rotate normal \
               --output DP-1 --mode ${displayArray[DP-1]} --right-of DP-0 --rotate normal \
               --output LVDS-0 --off --output VGA-0 --off
        configmsg="Configured DP-0 as Primary at ${displayArray['DP-0']} and DP-1 as secondary at ${displayArray['DP-1']}"
        configError=0
    else
        configmsg="This system is not configured for dock output. Please configure manually."
        configError=1
    fi
    post_config
}

auto_config() {
    if test "${displayArray[LVDS-0]+isset}"; then
        if test "${displayArray[DP-0]+isset}"; then
            dock_dual
        elif test "${displayArray[VGA-0]+isset}"; then
            extend_display
        else
            laptop_display
        fi
    elif test "${displayArray[eDP1]+isset}"; then
        if test "${displayArray[HDMI1]+isset}"; then
            mirror_display
        else
            laptop_display
        fi
    fi
}

post_config() {
    for display in ${!disconnectedArray[@]}; do
        xrandr --output ${disconnectedArray[$display]} --off
    done
    if [ ! $configError -eq 1 ]; then
       pkill conky
       conky -c ~/.config/conky/conky_maia.conkyrc &
       nitrogen --restore
    fi
    notify-send "$configmsg"
}

# Initial loading
str=$(readlink -f $(which i3-display-config))
installdir=${str%/*}
configmsg=""
configError=0
declare -A displayArray
declare -a disconnectedArray
read_connected_displays


case $1 in
    '-s') : ;&
    '--single')
        if [ -n "$2" ]; then
            singleSide="$2"
        else
            singleSide="left"
        fi
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
    '-m') : ;&
    '--mirror')
        mirror_display
        ;;
    '-d') : ;&
    '--dock')
        dock_dual
        ;;
    '-a') : ;&
    '--auto')
        auto_config
        ;;
    '--test')
        print_connected_displays
        ;;
esac

# xset dpms 0 0 600
