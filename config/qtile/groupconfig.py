"""Define a function to configure dropdowns."""

from pprint import pp

from libqtile.config import DropDown, Group, Key, Match, ScratchPad
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from customdata import Modifiers, DefaultApplications
import keymap

class DDConfig:
    """Define a default dropdown config, and methods to maximize reuse."""

    def __init__(self, width, height, x, y):
        """Initialize the default settings with the given dimensions."""
        self.w = width
        self.h = height
        self.x = x
        self.y = y

    @property
    def position(self):
        """Return the default dropdown position."""
        return dict( x = self.x, y = self.y )

    @property
    def size(self):
        """Return the default dropdown size."""
        return dict( width = self.w, height = self.h )

    @property
    def defaults(self):
        """Return a default set of dropdown settings."""
        config = dict(
            on_focus_lost_hide = False,
            warp_pointer = True,
            **self.size,
            **self.position
        )
        return config

    def modify(self, **kwargs):
        """Generate config with the given differences from the default."""
        config = self.defaults
        config.update(kwargs)
        return config

class Keybind:
    """Define a locally-useful keybind class."""

    # NOTE: Should/can we move this to `customdata`?
    def __init__(self, mods, key):
        """Initialize the new keybind."""
        self.mods = mods
        self.key = key

class DDSpec:
    """Class defining the configuration and keybindings of a dropdown."""

    def __init__(self, name, keybind, command, config):
        """Configure the DropdownConfig."""
        self.name = name
        self.keybind = keybind
        self.command = command
        self.config = config

    @property
    def key(self):
        """Return the Qtile key binding for the dropdown."""
        return Key(self.keybind.mods, self.keybind.key,
              lazy.group['scratch'].dropdown_toggle(self.name),
              desc=f'Toggle {self.name} dropdown')

    @property
    def dropdown(self):
        """Construct and return a configured Qtile DropDown object."""
        defaults = DDConfig(0.6, 0.6, 0, 0)
        return DropDown(self.name, self.command, **self.config)

def configure_dd_spec_list(mods, apps):
    """Configure and return a list of dropdowns."""
    config = DDConfig(width=0.6, height=0.6, x=0, y=0)

    dropdowns = [
        DDSpec('terminal',
               Keybind(mods.base, 'apostrophe'),
               [ apps.term ],
               config.defaults),
        DDSpec('tasks',
               Keybind(mods.app, 'Delete'),
               [ apps.term, '-t', 'htop', '-e', 'htop' ],
               config.modify(width=0.7, height=0.7)),
        DDSpec('mixer',
               Keybind(mods.app, 'F4'),
               [ apps.term, '-t', 'PulseMixer', '-e', 'pulsemixer' ],
               config.defaults),
        DDSpec('files',
               Keybind(mods.app, 'f'),
               [ apps.term, '-t', 'files', '-e', 'lf' ],
               config.defaults),
        DDSpec('calculator',
               Keybind(mods.app, 'minus'),
               [ apps.term, '-t', 'Calculator', '-e', 'qalc' ],
               config.defaults),
        DDSpec('python shell',
               Keybind(mods.app, 'p'),
               [ apps.term, '-t', 'PyShell', '-e bpython' ],
               config.defaults),
        DDSpec('signal',
               Keybind(mods.app, 's'),
               [ 'signal-desktop' ],
               config.modify(opacity = 1.0,
                             height = 0.8,
                             width = 0.4)),
        DDSpec('emacs scratch',
               Keybind(mods.app, 'e'),
               [ *apps.editor, '-n', '-F', '((name . \"emacs-scratch\"))' ],
               config.modify(match=Match(title=['emacs-scratch']), opacity=1.0))
    ]
    return dropdowns

def config_dropdowns(dropdown_specs):
    """Return the configured list of dropdowns."""
    return [dd.dropdown for dd in dropdown_specs]

def configure_groups(mods, apps):
    """Return a configured list of groups."""
    specs = configure_dd_spec_list(mods, apps)
    groups = [
        ScratchPad('scratch', config_dropdowns(specs)),
        Group('1', label='', layout='max'),
        Group('2', label='', layout='monadwide'),
        Group('3', matches=[Match(wm_class=['firefox', 'brave-browser'])],
            layout='treetab', label=''),
        Group('4', label=''),
        Group('5', label=''),
        Group('6', label='', layout='treetab'),
        Group('7', label='', layout='floating'),
        Group('8', label='', layout='treetab'),
        Group('9', label='', layout='columns'),
        Group('0', label=''),
    ]
    keys = keymap.bind_keys(mods, apps, groups, specs)
    return ( groups, keys )

if __name__ == "__main__":
    pp(configure_groups(mods, apps))
    print("Group config passes syntax check")
