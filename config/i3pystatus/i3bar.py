#!/usr/bin/env python3

from i3pystatus import Status

status = Status()

# Show current mem usage
status.register(
    "mem_bar",
    color="#16a085",
    alert_color="#f27127",
    format="Mem: ▕{used_mem_bar}"
)

# Show current CPU usage
status.register(
    "cpu_usage_bar",
    dynamic_color=True,
    start_color="#16a085",
    end_color="#f27127",
    format="CPU: ▕{usage_bar}"
)

status.run()
