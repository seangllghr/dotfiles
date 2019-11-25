#!/bin/bash
if xinput list-props "ETPS/2 Elantech Touchpad" |\
  grep "Device Enabled (153):.*1" > /dev/null
then
  xinput disable "ETPS/2 Elantech Touchpad"
  notify-send -u low -i /usr/share/icons/Papirus-Adapta-Nokto/22x22/devices/input-touchpad.svg "Touchpad disabled"
else
  xinput enable "ETPS/2 Elantech Touchpad"
  notify-send -u low -i /usr/share/icons/Papirus-Adapta-Nokto/22x22/devices/input-touchpad.svg "Touchpad enabled"
fi
