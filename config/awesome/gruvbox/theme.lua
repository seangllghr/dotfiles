-------------------------------
--  "Gruvbox" awesome theme  --
--   By Sean G. (seangllghr) --
--                           --
--          based on         --
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_configuration_dir()
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "gruvbox/wallpaper.png"
-- }}}

-- {{{ Styles
theme.font      = "Libertinus Sans Bold 12"
-- }}}

-- {{{ Palette
gb_red      = "#cc241d"
gb_b_red    = "#fb4934"
gb_green    = "#98971a"
gb_b_green  = "#b8bb26"
gb_yellow   = "#d79921"
gb_b_yellow = "#fabd2f"
gb_blue     = "#458588"
gb_b_blue   = "#83a598"
gb_purple   = "#b16286"
gb_b_purple = "#d3869b"
gb_aqua     = "#689d68"
gb_b_aqua   = "#8ec07c"
gb_orange   = "#d65d0e"
gb_b_orange = "#fe8019"
gb_gray     = "#928374"
gb_b_gray   = "#a89984"
gb_bg_h     = "#1d2021"
gb_bg_0     = "#282828"
gb_bg_1     = "#3c3836"
gb_bg_2     = "#504945"
gb_bg_3     = "#665c54"
gb_bg_4     = "#7c6f64"
gb_fg_4     = "#a89984"
gb_fg_3     = "#bdae93"
gb_fg_2     = "#d5c4a1"
gb_fg_1     = "#ebdbb2"
gb_fg_0     = "#fbf1c7"

gb_bg = bg_0
gb_fg = fg_1
-- }}}

-- {{{ Colors
theme.fg_normal  = gb_fg_2
theme.fg_focus   = gb_fg
theme.fg_urgent  = gb_b_red
theme.bg_normal  = gb_bg_h
theme.bg_focus   = theme.bg_normal
theme.bg_urgent  = theme.bg_normal
theme.bg_systray = theme.bg_normal

theme.taglist_fg_focus = gb_b_blue
theme.taglist_fg_occupied = gb_fg_4
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(2)
theme.border_normal = gb_bg_h
theme.border_focus  = gb_bg_3
theme.border_marked = gb_fg

-- theme.taglist_shape = gears.shape.rectangle
-- theme.taglist_shape_border_width = 2
-- theme.taglist_shape_border_color = theme.bg_normal
-- theme.taglist_shape_border_color_focus = theme.border_focus

theme.tasklist_shape = gears.shape.rectangle
theme.tasklist_shape_border_width = 2
theme.tasklist_shape_border_color = theme.bg_normal
theme.tasklist_shape_border_color_focus = gb_fg_2
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = gb_bg_h
theme.titlebar_bg_normal = gb_bg_2
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = gb_b_green
--theme.fg_center_widget = gb_green
--theme.fg_end_widget    = gb_b_red
--theme.bg_widget        = bg_bg_4
--theme.border_widget    = bg_bg_3
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = gb_b_purple
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(20)
theme.menu_width  = dpi(200)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "gruvbox/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "gruvbox/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "gruvbox/awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "gruvbox/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "gruvbox/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "gruvbox/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "gruvbox/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "gruvbox/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "gruvbox/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "gruvbox/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "gruvbox/layouts/dwindle.png"
theme.layout_max        = themes_path .. "gruvbox/layouts/max.png"
theme.layout_fullscreen = themes_path .. "gruvbox/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "gruvbox/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "gruvbox/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "gruvbox/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "gruvbox/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "gruvbox/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "gruvbox/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "gruvbox/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "gruvbox/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "gruvbox/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "gruvbox/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "gruvbox/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "gruvbox/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "gruvbox/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "gruvbox/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "gruvbox/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "gruvbox/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "gruvbox/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "gruvbox/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "gruvbox/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "gruvbox/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "gruvbox/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "gruvbox/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "gruvbox/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "gruvbox/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

-- {{{ Window Swallowing
theme.dont_swallow_classname_list = {
  "Emacs",
  "firefox",
  "qutebrowser",
  "Audacity",
  "Inkscape",
  "kdenlive",
  "noswallow",
  "obs",
  "Code",
}
theme.dont_swallow_filter_activated = true
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
