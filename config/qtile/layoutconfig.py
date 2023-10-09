"""Functions to configure layout-related settings."""

from libqtile import layout
from libqtile.config import Match


def configure_layouts(colors):
    """Configure the layouts."""
    layout_theme = dict(
        margin = 4,
        border_width = 2,
        border_focus = colors.fg[4],
        border_normal = colors.bg[2],
    )

    layouts = [
        layout.Max(**layout_theme),
        layout.MonadTall(min_ratio=0.2, **layout_theme),
        layout.MonadWide(
            ratio=0.85,
            max_ratio=0.85,
            min_secondary_size=150,
            **layout_theme
        ),
        layout.MonadThreeCol(
            ratio=.7,
            new_client_position='bottom',
            **layout_theme
        ),
        layout.VerticalTile(**layout_theme),
        layout.Floating(**layout_theme),
    ]

    floating_layout = layout.Floating(
        float_rules=[
            *layout.Floating.default_float_rules,
            Match(wm_class='confirmreset'),  # gitk
            Match(wm_class='makebranch'),  # gitk
            Match(wm_class='maketag'),  # gitk
            Match(wm_class='ssh-askpass'),  # ssh-askpass
            Match(wm_class='pinentry-gtk-2'),
            Match(wm_class='com-onespatial-ms-integrate-sync-SyncTool'),
            Match(title='branchdialog'),  # gitk
            Match(title='pinentry'),  # GPG key password entry
            Match(title='New meeting | Microsoft Teams'),
            Match(wm_class='qgis', title='Organize Table columns')
        ],
        **layout_theme
    )

    return layouts, floating_layout