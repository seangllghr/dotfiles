"""Define several useful custom data classes for reuse across my config."""

class Modifiers:
    """Simplify and self-document keybinds using properties."""

    def __init__(self, mod_key_string, alt_key_string,
               shift_key_string, control_key_string):
        """Build a modifiers list from the provided modifier keystrings."""
        self._mod = mod_key_string
        self._alt = alt_key_string
        self._shft = shift_key_string
        self._ctrl = control_key_string

    @property
    def base(self):
        """Return the modifier list for base-layer keybinds.

        Base-layer keybinds handle window and layout management, as well as
        extremely common tasks, like launching editors, terminals, the
        default web browser, and the application launcher itself.
        """
        return [self._mod]

    @property
    def system(self):
        """Return the modifier list for system control keybinds.

        Control keybinds handle basic system functions, like shutting down,
        restarting the system or Qtile, and changing the display config.
        """
        return [self._mod, self._ctrl]

    @property
    def app(self):
        """Return the modifier list for application launchers.

        Application launcher keybinds, as the name suggests, launch a
        specific application, either as a full window or a dropdown.
        These keybinds try to be mnemonic, when possible.
        """
        return [self._mod, self._alt]

    @property
    def alternate(self):
        """Return the modifier list for second-layer bindings.

        Contrary to the name's implication, these bindings don't use the
        `alt` key. Instead, they represent an alternate form of the
        base-layer binding, or an alternate binding that is mnemonically
        appropriate for the key in question.
        """
        return [self._mod, self._shft]

    @property
    def alternate_system(self):
        """Return the modifier list for second-level system bindings."""
        return [self._mod, self._ctrl, self._shft]

    @property
    def alternate_app(self):
        """Return the modifier list for second-level application bindings."""
        return [self._mod, self._alt, self._shft]

    @property
    def functions(self):
        """Return an empty list of modifiers.

        Hardware control keys, such as volume and media playback, don't
        need modifiers, so this property returns an empty list.
        """
        return []

    @property
    def cag(self):
        """Return (nearly) all of the modifiers (control, alt, and GUI)."""
        return [self._mod, self._alt, self._ctrl]

    @property
    def cags(self):
        """Return all of the modifiers (control, alt, GUI, and shift)."""
        return [self._mod, self._alt, self._ctrl, self._shft]

class DefaultApplications:
    """Defines the user's default applications."""

    def __init__(self, terminal_command, browser_command, editor_command):
        """Build the list of application command strings."""
        self.term = terminal_command
        self.browser = browser_command
        self.editor = editor_command
