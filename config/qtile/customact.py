"""Custom functions for my qtile config."""

from libqtile import qtile
from libqtile.log_utils import logger
from libqtile.lazy import lazy
from libqtile.widget.prompt import AbstractCompleter

@lazy.function
def add_named_section(qtile, widget='prompt'):
    """Prompt user for section name, then add it."""
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
    """Prompt user for section name, then delete it."""
    try:
        promptbox = qtile.widgets_map[widget]
        promptbox.start_input(
            'Section name',
            lambda name: qtile.current_layout.cmd_del_section(name)
        )
    except KeyError:
        logger.exception(f'No widget named "{widget}" present')

def move_window_to_screen(qtile, window, screen):
    """Move window to a screen and focus it."""
    window.togroup(screen.group.name)
    qtile.focus_screen(screen.index)
    screen.group.focus(window, True)

@lazy.function
def move_window_to_prev_screen(qtile):
    """Move window to the previous screen."""
    index = qtile.current_screen.index
    index = index - 1 if index > 0 else len(qtile.screens) - 1
    move_window_to_screen(qtile, qtile.current_window, qtile.screens[index])


@lazy.function
def move_window_to_next_screen(qtile):
    """Move window to the next screen."""
    index = qtile.current_screen.index
    index = index + 1 if index < len(qtile.screens) - 1 else 0
    move_window_to_screen(qtile, qtile.current_window, qtile.screens[index])

def toggle_focus_floating():
    """Toggle focus between floating window and other windows in group."""

    @lazy.function
    def _toggle_focus_floating(qtile):
        group = qtile.current_group
        switch = 'non-float' if qtile.current_window.floating else 'float'
        logger.debug(f'toggle_focus_floating: switch = {switch}\t current_window: {qtile.current_window}')
        logger.debug(f'focus_history: {group.focus_history}')

        for win in reversed(group.focus_history):
            logger.debug(f'{win}: {win.floating}')
            if switch=='float' and win.floating:
                # win.focus(warp=False)
                group.focus(win)
                return
            if switch=='non-float' and not win.floating:
                # win.focus(warp=False)
                group.focus(win)
                return
    return _toggle_focus_floating
