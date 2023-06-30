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
        Key(mods.system, 's', # Not really a 'system' bind, but whatever
            lazy.layout.swap_main(),
            desc='Swap current client with main client'),
        Key(mods.alternate, 'f',
            lazy.window.toggle_floating(),
            "Toggle current client between floating and tiling"),

        # Manipulate layout size ratios
        Key(mods.base, 'n',
            lazy.layout.normalize(), lazy.layout.section_down(),
            desc='Normalize window sizes (TreeTab: Move tab to next section)'),
        Key(mods.alternate, 'n',
            lazy.layout.reset(),
            desc='Reset window sizes'),
        Key(mods.base, 's',
            lazy.layout.shrink(),
            desc='Shrink current window'),
        Key(mods.base, 'g',
            lazy.layout.grow(),
            desc='Expand current window'),
        Key(mods.base, 'h',
            lazy.layout.collapse_branch(),
            desc='TreeTab: Collapse branch'),
        Key(mods.base, 'l',
            lazy.layout.expand_branch(),
            desc='TreeTab: Expand branch'),
        Key(mods.base, 'm',
            lazy.layout.maximize(),
            desc='Maximize current window (within layout)'),
        Key(mods.base, 'a',
            lazy.layout.flip(),
            desc='Flip the main pane side'),

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

        # Directional keybinds, mostly for Columns, but generally applicable
        # These are on vim home row positions for my Moonlander layout
        Key(mods.base, 'e',
            lazy.layout.up(),
            desc='Move focus up'),
        Key(mods.base, 'o',
            lazy.layout.right(),
            desc='Move focus right'),
        Key(mods.base, 'i',
            lazy.layout.down(),
            desc='Move focus down'),
        Key(mods.base, 'y',
            lazy.layout.left(),
            desc='Move focus left'),
        Key(mods.alternate, 'y',
            lazy.layout.shuffle_left(),
            desc='Shuffle client left'),
        Key(mods.alternate, 'o',
            lazy.layout.shuffle_right(),
            desc='Shuffle client right'),

        # Directional grow/shrink bindings (Yes, I'm using system. Sue me.)
        Key(mods.system, 'e',
            lazy.layout.grow_up(),
            desc='Grow window up'),
        Key(mods.system, 'o',
            lazy.layout.grow_right(),
            desc='Grow window right'),
        Key(mods.system, 'i',
            lazy.layout.grow_down(),
            desc='Grow window down'),
        Key(mods.system, 'y',
            lazy.layout.grow_left(),
            desc='Grow window left'),

        # Columns-specific keybinds
        Key(mods.alternate, 'i',
            lazy.layout.swap_column_right(),
            desc='Swap column with next'),
        Key(mods.alternate, 'e',
            lazy.layout.swap_column_left(),
            desc='Swap column with previous'),
        Key(mods.alternate, 's',
            lazy.layout.toggle_split(),
            desc='Toggle split/stacked column'),

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
        Key(mods.system, 'p',
            lazy.spawn('maimpick'),
            desc='Screenshot current window')
    ]
    return keys

def bind_application_launchers(mods, apps):
    """Define keybinds for application launchers and rofi runners."""
    keys = [
        # Shells
        Key(mods.base, 'Return',
            lazy.spawn(apps.term),
            desc='Launch a terminal emulator'),
        Key(mods.app, 'Return',
            lazy.spawn(apps.term + ' -e xonsh'),
            desc='Launch an IPython terminal emulator'),
        Key(mods.app, 'n',
            lazy.spawn(apps.term + ' -e nu'),
            desc='Launch a nushell terminal emulator'),
        # Application launchers
        Key(mods.base, 'b',
            lazy.spawn(apps.browser),
            desc='Launch a browser window'),
        Key(mods.alternate, 'b',
            lazy.spawn('brave'),
            desc='Launch an alternate browser window'),
        Key(mods.app, 'c',
            lazy.spawn('chromium'),
            desc='Launch a Chromium window'),
        Key(mods.app, 'space',
            lazy.spawn(apps.editor),
            desc='Launch an editor'),
        Key(mods.app, 'v',
            lazy.spawn('virt-manager'),
            desc='Launch virtual machine manager'),
        Key(mods.app, 'g',
            lazy.spawn('qgis'),
            desc='Launch QGIS'),

        # Rofi runners and scripts
        ## I don't seem to use this...
        # Key(mods.alternate_app, 'space',
        #     lazy.spawn('rofi-projectile'),
        #     desc='Open projectile project'),
        Key(mods.alternate_app, 'space',
            lazy.spawn('code'),
            desc='Launch alternate IDE/Editor'),
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
        Key(mods.alternate, 'd',
            lazy.spawn('rofi-pass --last-used'),
            desc='Show password manager'),
        Key(mods.base, 'd',
            lazy.spawn('bwmenu --auto-lock -1'),
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
            keys.extend([
                    # mod + group name = switch to group
                    Key(mods.base, group.name,
                        lazy.group[group.name].toscreen(),
                        desc=f'Switch to group {group.name}',),
                    # mod + shift + group name = switch to group with client
                    Key(mods.alternate, group.name,
                        lazy.window.togroup(group.name, switch_group=True),
                        desc=f'Move client to group {group.name} and follow',),
                ])
        elif len(group.name) == 2 and group.name[1] == 'a':
            # I've now reached a point where 10 workspaces isn't enough.
            # Here we handle any alternate workspaces I've declared.
            # We use system (Ctrl) keybinds for convenience, not semantics.
            keys.extend([
                Key(mods.system, group.name[0],
                    lazy.group[group.name].toscreen(),
                    desc=f'Switch to group {group.name}',),
                Key(mods.alternate_system, group.name[0],
                    lazy.window.togroup(group.name, switch_group=True),
                    desc=f'Move client to group {group.name} and follow'),
            ])
    return keys

def bind_dropdown_keys(dropdown_specs):
    """Return a configured list of keybinds for the dropdown list."""
    return [dd.key for dd in dropdown_specs]

if (__name__ == '__main__'):
    print('Keymap config passes syntax check.')
