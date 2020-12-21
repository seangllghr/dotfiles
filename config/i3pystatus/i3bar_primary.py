#!/usr/bin/env python3

from i3pystatus import Status

status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register(
    "clock",
    format="%a, %F %R",
)

# Shows the address and up/down state of enp40s0
status.register(
    "network",
    interface="enp40s0",
    dynamic_color=False,
    color_up="#ffffff",
    format_up="🖧 {v4cidr} ↓ {bytes_recv}B ↑ {bytes_sent}B",
)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register(
    "pulseaudio",
    format="🔊 {volume}",
)

# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
status.register(
    "mpd",
    format="{title}{status}{album}",
    status={
        "pause": "▷",
        "play": "▶",
        "stop": "◾",
    },
)

status.run()
