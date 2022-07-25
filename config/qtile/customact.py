from libqtile import qtile
from libqtile.log_utils import logger
from libqtile.lazy import lazy
from libqtile.widget.prompt import AbstractCompleter

@lazy.function
def add_named_section(qtile, widget='prompt'):
    '''Prompt user for section name, then add it'''
    try:
        promptbox = qtile.widgets_map[widget]
        promptbox.start_input(
            'Section name',
            lambda name: qtile.current_layout.cmd_add_section(name)
        )
    except KeyError:
        logger.exception(f'No widget named "{widget}" present')

@lazy.function
def del_named_section(qtile, widget='prompt'):
    '''Prompt user for section name, then delete it'''
    try:
        promptbox = qtile.widgets_map[widget]
        promptbox.start_input(
            'Section name',
            lambda name: qtile.current_layout.cmd_del_section(name)
        )
    except KeyError:
        logger.exception(f'No widget named "{widget}" present')

def move_window_to_screen(qtile, window, screen):
    """Moves a window to a screen and focuses it, allowing you to move it
    further if you wish."""
    window.togroup(screen.group.name)
    qtile.focus_screen(screen.index)
    screen.group.focus(window, True)

@lazy.function
def move_window_to_prev_screen(qtile):
    """Moves a window to the previous screen. Loops around the beginning and
    end."""
    index = qtile.current_screen.index
    index = index - 1 if index > 0 else len(qtile.screens) - 1
    move_window_to_screen(qtile, qtile.current_window, qtile.screens[index])


@lazy.function
def move_window_to_next_screen(qtile):
    """Moves a window to the next screen. Loops around the beginning and
    end."""
    index = qtile.current_screen.index
    index = index + 1 if index < len(qtile.screens) - 1 else 0
    move_window_to_screen(qtile, qtile.current_window, qtile.screens[index])
