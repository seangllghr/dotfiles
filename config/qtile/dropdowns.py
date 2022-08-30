"""Define a function to configure dropdowns."""

from libqtile.config import DropDown, Key, Match
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

def_w = 0.6
def_h = 0.6
def_x = 0
def_y = 0

mod = 'mod4'
alt = 'mod1'
shft = 'shift'
ctrl = 'control'
terminal = guess_terminal()

default_size = dict(
    height = def_h,
    width = def_w,
)

default_position = dict(x = def_x, y = def_y)

dropdown_defaults = dict(
    on_focus_lost_hide = False,
    warp_pointer = True,
    **default_size,
    **default_position
)

dropdowns = [
    {
        'name': 'terminal',
        'keybind': {
            'mods': [ mod ],
            'key': 'apostrophe',
        },
        'command': [ terminal ],
        'config': dict(**dropdown_defaults,),
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
        'config': dict(**dropdown_defaults,),
    },
    {
        'name': 'files',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'f',
        },
        'command': 'alacritty -t Files -e lf'.split(),
        'config': dict(**dropdown_defaults,),
    },
    {
        'name': 'calculator',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'minus',
        },
        'command': 'alacritty -t Calculator -e qalc'.split(),
        'config': dict(**dropdown_defaults,),
    },
    {
        'name': 'python shell',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'p',
        },
        'command': 'alacritty -t PyShell -e bpython',
        'config': dict(**dropdown_defaults,),
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
            **default_position
        )
    },
    {
        'name': 'signal',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 's',
        },
        'command': 'signal-desktop',
        'config': dict(
            on_focus_lost_hide = False,
            opacity = 1.0,
            height = 0.8,
            width = 0.4,
            **default_position
        )
    },
    {
        'name': 'emacs',
        'keybind': {
            'mods': [ mod, alt ],
            'key': 'e',
        },
        'command': "emacsclient -cn -F '((name . \"emacscratch\"))' -a emacs",
        'config': dict(
            match = Match(title=['emacscratch']),
            opacity = 1.0,
            **dropdown_defaults
        )
    }
]

def config_dropdown_list():
    """Return the configured list of dropdowns."""
    return [DropDown(dd['name'], dd['command'], **dd['config']) for dd in dropdowns]

def config_dropdown_keys():
    """Return a configured list of keybinds for the dropdown list."""
    keys = [
        Key(dd['keybind']['mods'], dd['keybind']['key'],
            lazy.group['scratch'].dropdown_toggle(dd['name']),
            desc = f"Toggle {dd['name']} dropdown")
        for dd in dropdowns
    ]
    return keys
