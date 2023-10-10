"""This file defines a single function to configure the bar."""

from libqtile import bar, widget


def configure_bar(colors, main_bar=False):
    """Configure the bar."""
    groupbox_config = dict(
        disable_drag=True,
        font='Font Awesome 6 Free',
        fontsize=14,
        hide_unused=True,
    )

    tasklist_config = dict(
        border = colors.bg[2],
        fontsize = 16,
        highlight_method = 'block',
        icon_size = 0,
        margin = 0,
        title_width_method = 'uniform',
        txt_floating = ' ',
        txt_maximized = ' ',
        txt_minimized = ' ',
        urgent_alert_method = 'text',
    )

    bar_config = [
        widget.GroupBox(**groupbox_config),
        widget.TaskList(**tasklist_config),
        widget.CurrentLayoutIcon(),
    ]

    if main_bar:
        return bar.Bar(bar_config + [
            widget.Systray(),
            widget.Clock(format='%a %Y-%m-%d | %H:%M')
        ], 28)
    else:
        return bar.Bar(bar_config, 28)
