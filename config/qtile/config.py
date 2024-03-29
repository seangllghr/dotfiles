# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
"""My personal qtile config, now with better python style."""

from pprint import pp
from os.path import expanduser
from subprocess import Popen

from libqtile import hook, qtile
from libqtile.config import Click, Drag, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from customdata import Modifiers, DefaultApplications
from floating_window_snapping import move_snap_window
import barconfig
import groupconfig
import layoutconfig
import palette

colors = palette.Palette(
    'Gruvbox Dark',
    colors = [
        '#1d2021', '#3c3836',
        '#cc241d', '#fb4934',
        '#98971a', '#b8bb26',
        '#d79921', '#fabd2f',
        '#458588', '#83a598',
        '#b16286', '#d3869b',
        '#689d6a', '#8ec07c',
        '#d5c4a1', '#fbf1c7',
        '#1d2021', '#ebdbb2'
    ],
    bg = ['#1d2021', '#3c3836', '#504945', '#665c54', '#7c6f64'],
    fg = ['#fbf1c7', '#ebdbb2', '#d5c4a1', '#bdae93', '#a89984']
)

mods = Modifiers(
    mod_key_string='mod4',
    alt_key_string='mod1',
    shift_key_string='shift',
    control_key_string='control'
)

apps = DefaultApplications(
    terminal_command=guess_terminal(),
    browser_command='firefox',
    editor_command=[ 'emacsclient', '-c', '-a', 'emacs', ]
)

groups, keys = groupconfig.configure_groups(mods, apps)

widget_defaults = layoutconfig.configure_defaults(colors)
extension_defaults = widget_defaults.copy()

layouts, floating_layout = layoutconfig.configure_layouts(colors)

screens = [
    Screen(
        top = barconfig.configure_bar(colors, main_bar=True),
        wallpaper = expanduser('~/.config/qtile/wallpaper.png'),
        # wallpaper_mode='fill'
    ),
    Screen(
        top = barconfig.configure_bar(colors, main_bar=False),
        wallpaper = expanduser('~/.config/qtile/wallpaper.png'),
        # wallpaper_mode='fill'
    ),
    Screen(
        top = barconfig.configure_bar(colors, main_bar=False),
        wallpaper = expanduser('~/.config/qtile/wallpaper.png'),
        # wallpaper_mode='fill'
    ),
]

# Drag floating layouts.
mouse = [
    Drag(mods.base, 'Button1',
         move_snap_window(snap_dist=20), start=lazy.window.get_position()),
    Drag(mods.base, 'Button3',
         lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click(mods.base, 'Button2',
          lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'

@hook.subscribe.startup_once
def _autostart():
    home = expanduser('~/')
    Popen([home + '.config/qtile/autostart.sh'])

# @hook.subscribe.layout_change
# def _layout_change(layout, group):
#     no_bar_on_virtualization(qtile)

# @hook.subscribe.changegroup
# def _group_change():
#     no_bar_on_virtualization(qtile)

# @hook.subscribe.client_focus
# def _focus_change(window):
#     no_bar_on_virtualization(qtile)

if __name__ == "__main__":
    print("Config loads successfully!")
