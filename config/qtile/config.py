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

import os
import subprocess

from libqtile import bar, hook, layout, widget, qtile
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, Screen, ScratchPad
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from floating_window_snapping import move_snap_window
import customact

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

mod = 'mod4'
alt = 'mod1'
shft = 'shift'
ctrl = 'control'
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Move focus through the window list
    Key([mod], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([mod], 'k', lazy.layout.up(), desc='Move focus up'),
    # Move windows within group
    Key([mod, shft], 'j',
        lazy.layout.shuffle_down(), lazy.layout.move_down(),
        desc='Move window down'),
    Key([mod, shft], 'k',
        lazy.layout.shuffle_up(), lazy.layout.move_up(),
        desc='Move window up'),
    Key([mod, shft], 'f', lazy.window.toggle_floating(), desc='Un/float window'),
    # Change window sizes
    Key([mod], 'h',
        lazy.layout.shrink(), lazy.layout.collapse_branch(),
        desc='Shrink window (TreeTab: collapse branch)'),
    Key([mod], 'l',
        lazy.layout.grow(), lazy.layout.expand_branch(),
        desc='Expand window (TreeTab: expand branch)'),
    Key([mod], 'n', lazy.layout.normalize(), desc='Reset all window sizes'),
    Key([mod], 'm', lazy.layout.maximize(), desc='Maximize focused window'),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, 'shift'], 'Return', lazy.layout.toggle_split(),
        desc='Toggle between split and unsplit sides of stack'),

    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout(), desc='Step forward through layouts'),
    Key([mod, shft], 'Tab', lazy.prev_layout(), desc='Step back through layouts'),

    # Move between screens
    Key([mod], 'comma', lazy.prev_screen(), desc='Move focus to previous screen'),
    Key([mod], 'period', lazy.next_screen(), desc='Move focus to next screen'),
    Key([mod, shft], 'comma',
        customact.move_window_to_prev_screen(),
        desc='Move window one screen left'),
    Key([mod, shft], 'period',
        customact.move_window_to_next_screen(),
        desc='Move window one screen right'),

    # TreeTab Bindings
    Key([mod, shft], 'h', lazy.layout.move_left(), desc='Shift tab left'),
    Key([mod, shft], 'l', lazy.layout.move_right(), desc='Shift tab right'),
    Key([mod, ctrl], 'k',
        lazy.layout.section_up(),
        desc='Move tab up a section'),
    Key([mod, ctrl], 'j',
        lazy.layout.section_down(),
        desc='Move tab down a section'),
    Key([mod, shft], 't',
        customact.add_named_section(), desc='Add a named section'),
    Key([mod, shft], 'x',
        customact.del_named_section(), desc='Delete a section'),

    # Quitting and Restarting
    Key([mod], 'q', lazy.window.kill(), desc='Kill focused window'),
    Key([mod, ctrl], 'r', lazy.reload_config(), desc='Reload the config'),
    Key([mod, ctrl], 'q', lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod], 'End',
        lazy.spawn(os.path.expanduser('~/dotfiles/bin/sysact')),
        desc='Power options menu'),

    # Application/launcher shortcuts
    Key([mod], 'r', lazy.spawncmd(), desc='Spawn a command using a prompt widget'),
    Key([mod], 'Return', lazy.spawn(terminal), desc='Launch terminal'),
    Key([mod], 'b', lazy.spawn('firefox'), desc='Launch Firefox'),
    Key([mod, ctrl], 'space', lazy.spawn('emacsclient -c -a emacs')),
    Key([mod, alt], 'space', lazy.spawn('rofi-projectile'), 'Open project in Emacs'),

    # Rofi runners and scripts
    Key([mod], 'space', lazy.spawn('rofi -show drun'),
        desc='Show applications menu'),
    Key([mod, shft], 'space', lazy.spawn('rofi -show run'),
        desc='Show command runner'),
    Key([mod], 't', lazy.spawn('rofi -show windowcd'), desc='Show window list'),
    Key([mod, alt], 'Return', lazy.spawn('rofi -show ssh'),
        desc='Show SSH session launcher'),
    Key([mod], 'p', lazy.spawn('rofi-mpc'), desc='Show rofi music player'),
    Key([mod], 'd', lazy.spawn('rofi-pass --last-used'), desc='Show pass menu'),
    Key([mod, alt], 'b', lazy.spawn('rofi-chrome'), desc='Open Chrome PWA'),
    Key([mod], 'grave', lazy.spawn('rofimoji'), desc='Open emoji picker'),

    # Hardware control/media keys
    Key([], 'XF86AudioPlay',
        lazy.spawn('playerctl play-pause'),
        desc='Toggle media player play/pause'),
    Key([], 'XF86AudioNext',
        lazy.spawn('playerctl next'),
        desc='Skip to next song'),
    Key([], 'XF86AudioPrev',
        lazy.spawn('playerctl previous'),
        desc='Skip to previous song'),
    Key([], 'XF86AudioMute',
        lazy.spawn('pulsemixer --toggle-mute'),
        desc='Toggle mute'),
    Key([], 'XF86AudioLowerVolume',
        lazy.spawn('pulsemixer --change-volume -2'),
        desc='Decrease volume'),
    Key([], 'XF86AudioRaiseVolume',
        lazy.spawn('pulsemixer --change-volume +2'),
        desc='Increase volume'),
]

dropdown_defaults = {
    'height': 0.6,
    'width': 0.6,
    'x': 0, 'y': 0,
}
dropdowns = [
    {
        'name': 'terminal',
        'keybind': {
            'mods': [ mod ],
            'key': 'apostrophe',
        },
        'command': [ terminal ],
        'config': dict(
            on_focus_lost_hide = True,
            warp_pointer = True,
            **dropdown_defaults,
        ),
    },
    {
        'name': 'tasks',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'Delete',
        },
        'command': 'alacritty -t htop -e htop'.split(),
        'config': dict(
            on_focus_lost_hide = False,
            height = 0.7, width = 0.7,
            x = 0, y = 0,
        ),
    },
    {
        'name': 'mixer',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'F4',
        },
        'command': 'alacritty -t PulseMixer -e pulsemixer'.split(),
        'config': dict(
            on_focus_lost_hide = True,
            warp_pointer = True,
            **dropdown_defaults,
        ),
    },
    {
        'name': 'files',
        'keybind': {
            'mods': [ mod ],
            'key': 'f',
        },
        'command': 'alacritty -t Files -e lf'.split(),
        'config': dict(
            on_focus_lost_hide = True,
            warp_pointer = True,
            **dropdown_defaults,
        ),
    },
    {
        'name': 'calculator',
        'keybind': {
            'mods': [ mod ],
            'key': 'minus',
        },
        'command': 'alacritty -t Calculator -e qalc'.split(),
        'config': dict(
            on_focus_lost_hide = False,
            **dropdown_defaults,
        ),
    },
    {
        'name': 'python shell',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'p',
        },
        'command': 'alacritty -t PyShell -e bpython',
        'config': dict(
            on_focus_lost_hide = False,
            **dropdown_defaults,
        ),
    },
    {
        'name': 'man',
        'keybind': {
            'mods': [ mod ],
            'key': 'slash',
        },
        'command': 'alacritty -t Manpages',
        'config': dict(
            on_focus_lost_hide = False,
            height = 0.995, width = 0.5,
            x = 0, y = 0,
        )
    },
]

# groups = [Group(i) for i in '123456789']
groups = [
    ScratchPad('scratch', [DropDown(dd['name'], dd['command'], **dd['config'])
                           for dd in dropdowns]),
    Group('1', label='', layout='max'),
    Group('2', label='', layout='monadwide'),
    Group('3', matches=[Match(wm_class=['firefox', 'brave-browser'])],
          layout='treetab', label=''),
    Group('4', label=''),
    Group('5', label=''),
    Group('6', label='', layout='treetab'),
    Group('7', label='', layout='floating'),
    Group('8', label='', layout='treetab'),
    Group('9', label=''),
    Group('0', label=''),
]

keys.extend([
    Key(dropdown['keybind']['mods'], dropdown['keybind']['key'],
        lazy.group['scratch'].dropdown_toggle(dropdown['name']),
        desc = f"Toggle {dropdown['name']} dropdown")
    for dropdown in dropdowns
])

for group in groups:
    if len(group.name) == 1:
        # setup keybinds for the ten single-character base groups
        keys.extend(
            [
                # mod1 + letter of group = switch to group
                Key(
                    [mod],
                    group.name,
                    lazy.group[group.name].toscreen(),
                    desc=f'Switch to group {group.name}',
                ),
                # mod1 + shift + letter of group = switch to & move focused window to group
                Key(
                    [mod, shft],
                    group.name,
                    lazy.window.togroup(group.name, switch_group=True),
                    desc=f'Switch to & move focused window to group {group.name}',
                ),
                Key(
                    [mod, alt],
                    group.name,
                    lazy.window.togroup(group.name, switch_group=False),
                    desc=f'Move focused window to group {group.name}',
                ),
                # Or, use below if you prefer not to switch to that group.
                # # mod1 + shift + letter of group = move focused window to group
                # Key([mod, 'shift'], group.name, lazy.window.togroup(i.name),
                #     desc=f'move focused window to group {group.name)}',
            ]
        )

layout_theme = dict(
    margin = 4,
    border_width = 2,
    border_focus = colors.fg[4],
    border_normal = colors.bg[2],
)

layouts = [
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(ratio=0.85, min_ratio=0.15, **layout_theme),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(
        active_bg = colors.bg[3], active_fg = colors.fg[0],
        inactive_bg = colors.bg[1], inactive_fg = colors.fg[3],
        urgent_bg = colors.red.bright, urgent_fg = colors.bg[0],
        section_fg = colors.fg[1],
        bg_color = colors.bg[0],
        sections = [ 'Default' ],
        font = 'Libertinus Sans', fontsize = 18, section_fontsize = 16,
        panel_width = 250,
        **layout_theme
    ),

    # layout.Zoomy(),
    layout.Floating(**layout_theme),
]

widget_defaults = dict(
    # Fonts
    font='Libertinus Sans',
    fontsize = 18,
    padding = 5,

    # General colors
    active = colors.fg[1],
    background = colors.bg[0],
    foreground = colors.fg[1],
    inactive = colors.bg[3],

    # GroupBox theming
    highlight_method = 'line',
    highlight_color = [ colors.bg[0], colors.bg[1] ],
    this_current_screen_border = colors.blue.bright,
    this_screen_border = colors.bg[4],
    other_current_screen_border = colors.bg[2],
    other_screen_border = colors.bg[2],
    urgent_alert_method = 'line',
    urgent_text = colors.red.bright,
    urgent_border = colors.red.bright,

    # Custom icon path for layout icons
    custom_icon_paths = [ os.path.expanduser('~/.config/qtile/icons/layouts') ],
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top = bar.Bar(
            [
                widget.GroupBox(),
                widget.CurrentLayoutIcon(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ('#ff0000', '#ffffff'),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                # widget.Battery(charge_char='', discharge_char='', update_interval=5),
                widget.Clock(format='%a %Y-%m-%d | %H:%M'),
            ],
            28,
        ),
        wallpaper = os.path.expanduser('~/.config/qtile/wallpaper.png'),
        wallpaper_mode='fill'
    ),
    Screen(
        top = bar.Bar(
            [
                widget.GroupBox(),
                widget.CurrentLayoutIcon(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        'launch': ('#ff0000', '#ffffff'),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Clock(format='%a %Y-%m-%d | %H:%M'),
            ],
            28,
        ),
        wallpaper = os.path.expanduser('~/.config/qtile/wallpaper.png'),
        wallpaper_mode='fill'
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', move_snap_window(snap_dist=20),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(wm_class='pinentry-gtk-2'),
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
    ],
    **layout_theme
)
auto_fullscreen = True
focus_on_window_activation = 'smart'
reconfigure_screens = False

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
    home = os.path.expanduser('~/')
    subprocess.Popen([home + '.config/qtile/autostart.sh'])
