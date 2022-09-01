"""This file defines my keybinds and keybind helper functions."""

from os.path import expanduser

from libqtile.config import Key
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import customact
from customdata import Modifiers, DefaultApplications

def bind_keys(mods, apps, groups, specs):
    """Assemble and return the keybinds list."""
    keys = []

    keys.extend(bind_layout_keys(mods))
    keys.extend(bind_system_control_keys(mods))
    keys.extend(bind_application_launchers(mods, apps))
    keys.extend(bind_hardware_function_keys(mods))
    keys.extend(bind_group_keys(mods, groups))
    keys.extend(bind_dropdown_keys(specs))

    return keys

def bind_layout_keys(mods):
    """Define layout manipulation and traversal keybinds."""
    keys = [

        # Move focus within group
        Key(mods.base, 'j',
            lazy.layout.next(),
            desc='Move focus to next client'),
        Key(mods.base, 'k',
            lazy.layout.previous(),
            desc='Move focus to previous client'),
        Key(mods.base, 'f',
            customact.toggle_focus_floating(),
            desc='Toggle focus between floating and tiled clients'),
        Key(mods.alternate, 'equal',
            lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of the stack"),
        Key(mods.base, 't',
            lazy.spawn('rofi -show windowcd'),
            desc='Show window switcher'),

        # Move clients within group
        Key(mods.alternate, 'j',
            lazy.layout.shuffle_down(), lazy.layout.move_down(),
            desc='Move window down the stack'),
        Key(mods.alternate, 'k',
            lazy.layout.shuffle_up(), lazy.layout.move_up(),
            desc='Move window up the stack'),
        Key(mods.base, 's',
            lazy.layout.swap_main(),
            desc='Swap current client with main client'),
        Key(mods.alternate, 'f',
            lazy.window.tile_floating(),
            "Toggle current client between floating and tiling"),

        # Manipulate layout size ratios
        Key(mods.base, 'n',
            lazy.layout.reset(), lazy.layout.section_down(),
            desc='Reset window sizes (TreeTab: Move tab to next section)'),
        Key(mods.base, 'h',
            lazy.layout.shrink(), lazy.layout.collapse_branch(),
            desc='Shrink current window (TreeTab: Collapse branch)'),
        Key(mods.base, 'l',
            lazy.layout.grow(), lazy.layout.expand_branch(),
            desc='Expand current window (TreeTab: Expand branch)'),
        Key(mods.alternate, 'n',
            lazy.layout.normalize(),
            desc='Normalize window sizes'),
        Key(mods.base, 'm',
            lazy.layout.maximize(),
            desc='Maximize current window (within layout)'),

        # Move focus and clients between screens
        Key(mods.base, 'comma',
            lazy.prev_screen(),
            desc='Move focus to previous screen'),
        Key(mods.base, 'period',
            lazy.next_screen(),
            desc='Move focus to next screen'),
        Key(mods.alternate, 'comma',
            customact.move_window_to_prev_screen(),
            desc='Move current client to previous screen'),
        Key(mods.alternate, 'period',
            customact.move_window_to_next_screen(),
            desc='Move current client to next screen'),

        # Change layouts
        Key(mods.base, 'Tab',
            lazy.next_layout(),
            desc='Step forward through the layout list'),
        Key(mods.alternate, 'Tab',
            lazy.prev_layout(),
            desc='Step backward through the layout list'),

        # TreeTab-exclusive bindings
        Key(mods.alternate, 'h',
            lazy.layout.move_left(),
            desc='Decrease tab nesting by one level'),
        Key(mods.alternate, 'l',
            lazy.layout.move_right(),
            desc='Increase tab nesting by one level'),
        Key(mods.base, 'p',
            lazy.layout.section_up(),
            desc='Move tab to previous section'),
        Key(mods.alternate, 't',
            customact.add_named_section(),
            desc='Add a section to the tab list'),
        Key(mods.alternate, 'x',
            customact.del_named_section(),
            desc='Delete a section from the tab list'),
    ]

    return keys

def bind_system_control_keys(mods):
    """Define keybinds for system control functions."""
    keys = [
        Key(mods.base, 'q',
            lazy.window.kill(),
            desc='Kill the focused client'),
        Key(mods.system, 'r',
            lazy.reload_config(),
            desc='Reload the Qtile config'),
        Key(mods.system, 'q',
            lazy.shutdown(),
            desc='Shutdown Qtile and log out of the session'),
        Key(mods.system,
            'End',
            lazy.spawn(expanduser('~/dotfiles/bin/sysact')),
            desc='Show power options menu'),
        Key(mods.system, 'd',
            lazy.spawn(expanduser('~/dotfiles/bin/displayselect')),
            desc='Change display configuration'),
    ]
    return keys

def bind_application_launchers(mods, apps):
    """Define keybinds for application launchers and rofi runners."""
    keys = [
        # Application launchers
        Key(mods.base, 'Return',
            lazy.spawn(apps.term),
            desc='Launch a terminal emulator'),
        Key(mods.base, 'b',
            lazy.spawn(apps.browser),
            desc='Launch a browser window'),
        Key(mods.alternate, 'b',
            lazy.spawn('brave'),
            desc='Launch an alternate browser window'),
        Key(mods.app, 'space',
            lazy.spawn(apps.editor),
            desc='Launch an editor'),

        # Rofi runners and scripts
        Key(mods.alternate_app, 'space',
            lazy.spawn('rofi-projectile'),
            desc='Open projectile project'),
        Key(mods.base, 'space',
            lazy.spawn('rofi -show drun'),
            desc='Show applications menu'),
        Key(mods.alternate, 'space',
            lazy.spawn('rofi -show run'),
            desc='Show command runner'),
        Key(mods.alternate, 'Return',
            lazy.spawn('rofi -show ssh'),
            desc='Show SSH session launcher'),
        # Key(mods.app, 'p',
        #     lazy.spawn('rofi-mpc'),
        #     desc='Open rofi MPD client'),
        Key(mods.base, 'd',
            lazy.spawn('rofi-pass --last-used'),
            desc='Show password manager'),
        Key(mods.app, 'b',
            lazy.spawn('rofi-chrome'),
            desc='Show rofi web app launcher'),
        Key(mods.base, 'grave',
            lazy.spawn('rofimoji'),
            desc='Show rofi emoji picker'),
    ]
    return keys

def bind_hardware_function_keys(mods):
    """Define bindings for hardware function keys."""
    keys = [
        Key(mods.functions, 'XF86AudioPlay',
            lazy.spawn('playerctl play-pause'),
            desc='Toggle media player play/pause'),
        Key(mods.functions, 'XF86AudioNext',
            lazy.spawn('playerctl next'),
            desc='Skip to next song'),
        Key(mods.functions, 'XF86AudioPrev',
            lazy.spawn('playerctl previous'),
            desc='Skip to previous song'),
        Key(mods.functions, 'XF86AudioMute',
            lazy.spawn('pulsemixer --toggle-mute'),
            desc='Toggle mute'),
        Key(mods.functions, 'XF86AudioLowerVolume',
            lazy.spawn('pulsemixer --change-volume -2'),
            desc='Decrease volume'),
        Key(mods.functions, 'XF86AudioRaiseVolume',
            lazy.spawn('pulsemixer --change-volume +2'),
            desc='Increase volume'),
    ]
    return keys

def bind_group_keys(mods, groups):
    """Generate keybinds for a list of group objects with a `name`."""
    keys = []
    for group in groups:
        if len(group.name) == 1:
            # setup keybinds for base groups with single-character names
            keys.extend(
                [
                    # mod + group name = switch to group
                    Key(mods.base, group.name,
                        lazy.group[group.name].toscreen(),
                        desc=f'Switch to group {group.name}',),
                    # mod + shift + group name = switch to group with client
                    Key(mods.alternate, group.name,
                        lazy.window.togroup(group.name, switch_group=True),
                        desc=f'Move client to group {group.name} and follow',),
                ]
            )
    return keys

def bind_dropdown_keys(dropdown_specs):
    """Return a configured list of keybinds for the dropdown list."""
    return [dd.key for dd in dropdown_specs]

if (__name__ == '__main__'):
    print('Keymap config passes syntax check.')