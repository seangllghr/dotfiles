-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Third-party extensions
-- Bling (github.com/Nooo37/bling) must be required after beautiful.init

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/sean/.config/awesome/gruvbox/theme.lua")
-- Bling apparently has to be required after beautiful
local bling = require("bling")
bling.module.window_swallowing.start()

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,             --  1
    awful.layout.suit.tile.left,        --  2
    awful.layout.suit.tile.bottom,      --  3
    awful.layout.suit.tile.top,         --  4
    awful.layout.suit.fair,             --  5
    awful.layout.suit.fair.horizontal,  --  6
    awful.layout.suit.spiral,           --  7
    awful.layout.suit.spiral.dwindle,   --  8
    awful.layout.suit.max,              --  9
    awful.layout.suit.max.fullscreen,   -- 10
    awful.layout.suit.magnifier,        -- 11
    awful.layout.suit.floating,         -- 12
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }

-- mymainmenu = awful.menu({ items = { { awesome_group, myawesomemenu, beautiful.awesome_icon },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Create a shutdown menu
shutdownmenu = awful.menu({
    { "   Lock", function () awful.spawn("systemctl poweroff") end },
    { " Logout", function () awesome.quit() end },
    { "   Suspend", function () awful.spawn("systemctl poweroff") end },
    { "   Reboot", function () awful.spawn("systemctl poweroff") end },
    { "   Shutdown", function () awful.spawn("systemctl poweroff") end },
    { " Restart awesome", awesome.restart },
})

-- Create a textclock widget
mytextclock = wibox.widget.textclock('%a %F %H:%M ')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Pick an (in)appropriate tiling layout based on screen geometry
function pick_tile_layout(screen, rational)
    if (screen.workarea.width >= screen.workarea.height) then
        if rational then
            return awful.layout.suit.tile
        else
            return awful.layout.suit.tile.bottom
        end
    else
        if rational then
            return awful.layout.suit.tile.bottom
        else
            return awful.layout.suit.tile
        end
    end
end
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- awful.tag({ "", "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])
    awful.tag.add("", {
                      layout = awful.layout.suit.max,
                      screen = s,
                      selected = s.index == 1
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.max,
                      screen = s,
    })
    awful.tag.add("", {
                      layout = pick_tile_layout(s, true),
                      screen = s,
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.max,
                      screen = s,
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.max,
                      screen = s,
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.floating,
                      screen = s,
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.floating,
                      screen = s,
    })
    awful.tag.add("", {
                      layout = pick_tile_layout(s, true),
                      screen = s,
    })
    awful.tag.add("", {
                      layout = pick_tile_layout(s, false),
                      screen = s,
                      master_width_factor = .9,
                      master_count = 2
    })
    awful.tag.add("", {
                      layout = pick_tile_layout(s, true),
                      screen = s,
                      selected = s.index == 2
    })
    awful.tag.add("", {
                      layout = awful.layout.suit.floating,
                      screen = s,
    })


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
        style = {
            font = "Font Awesome 5 Brands 12"
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout  = {
            spacing = 8,
            max_widget_size = 400,
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 8,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                right  = 8,
                widget = wibox.container.margin,
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

--- {{{ Scratchpad
local term_scratch = bling.module.scratchpad {
    command = "alacritty --class scratch-term -t 'Scratch Terminal'",
    rule = { instance = "scratch-term" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x=0, y=29, width=1206, height=726 },
    reapply = true,
    dont_focus_before_close = false,
}
local task_scratch = bling.module.scratchpad {
    command = "alacritty --class scratch-task -t 'htop' -e htop",
    rule = { instance = "scratch-task" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x=0, y=29, width=1206, height=726 },
    reapply = true,
    dont_focus_before_close = false,
}
local spt_scratch = bling.module.scratchpad {
    command = "alacritty --class scratch-spt -t 'Spotify' -e spt",
    rule = { instance = "scratch-spt" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x=0, y=29, width=1206, height=726 },
    reapply = true,
    dont_focus_before_close = false,
}
local mixer_scratch = bling.module.scratchpad {
    command = "alacritty --class scratch-pulsemixer -t 'PulseMixer' -e pulsemixer",
    rule = { instance = "scratch-pulsemixer" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x=0, y=29, width=1206, height=726 },
    reapply = true,
    dont_focus_before_close = false,
}
local file_scratch = bling.module.scratchpad {
    command = "alacritty --class scratch-file -t 'File Manager' -e lf",
    rule = { instance = "scratch-file" },
    sticky = true,
    autoclose = true,
    floating = true,
    geometry = { x=0, y=29, width=1206, height=726 },
    reapply = true,
    dont_focus_before_close = false,
}
--- }}}

-- {{{ Key bindings
-- Binding groups
awesome_group = "Awesome"
client_group = "Client"
floating_group = "Floating Clients"
functions_group = "Function Keys"
launcher_group = "Launcher"
layout_group = "Layout"
screen_group = "Screen"
scripts_group = "Scripts"
tag_group = "Tag"

-- Bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
              {description="show help", group=awesome_group}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = tag_group}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = tag_group}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = tag_group}),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = awesome_group}),

    -- Client manipulation
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = client_group}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = client_group}
    ),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = client_group}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = client_group}),

    -- Tiling manipulation
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = layout_group}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = layout_group}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = layout_group}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = layout_group}),
    awful.key({ modkey, altkey    }, "]", function () awful.client.incwfact( 0.25, client.focus) end,
              {description = "increase window width", group = layout_group}),
    awful.key({ modkey, altkey    }, "[", function () awful.client.incwfact(-0.125, client.focus) end,
              {description = "decrease window width", group = layout_group}),

    -- Floating window positioning
    awful.key({ modkey, altkey    }, "h",
        function ()
            awful.placement.top_left(client.focus)
            client.focus.y = client.focus.y + 29
        end,
        {description = "Move floating client to top left", group = floating_group}),
    awful.key({ modkey, altkey    }, "l",
        function ()
            awful.placement.top_right(client.focus)
            client.focus.y = client.focus.y + 29
        end,
        {description = "Move floating client to top right", group = floating_group}),
    awful.key({ modkey, altkey    }, "k",
        function ()
            awful.placement.top(client.focus)
            client.focus.y = client.focus.y + 29
        end,
        {description = "Move floating client to top center", group = floating_group}),
    awful.key({ modkey, altkey    }, "j",
        function ()
            awful.placement.centered(client.focus)
        end,
        {description = "Move floating client to center", group = floating_group}),
    awful.key({ modkey, altkey, "Control" }, "h",
        function ()
            awful.placement.bottom_left(client.focus)
        end,
        {description = "Move floating client to bottom left", group = floating_group}),
    awful.key({ modkey, altkey, "Control" }, "l",
        function ()
            awful.placement.bottom_right(client.focus)
        end,
        {description = "Move floating client to bottom right", group = floating_group}),
    awful.key({ modkey, altkey, "Control" }, "j",
        function ()
            awful.placement.bottom(client.focus)
        end,
        {description = "Move floating client to bottom center", group = floating_group}),
    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true}
                )
            end
        end,
        {description = "restore minimized", group = client_group}),

    -- Screen manipulation
    awful.key({ modkey,           }, ".", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = screen_group}),
    awful.key({ modkey,           }, ",", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = screen_group}),
    awful.key({ modkey, altkey    }, ".",
        function ()
            local curr_scr = awful.screen.focused()
            local next_scr = curr_scr.index < screen:count()
                and screen[curr_scr.index + 1]
                or screen[1]
            local t = curr_scr.selected_tag
            t2 = next_scr.tags[t.index]
            for key, client in pairs(t:clients()) do
                client:move_to_tag(t2)
            end
            for key, tag in pairs(curr_scr.tags) do
                if not (tag.index == 11) then
                    t = tag
                else
                    t = (curr_scr.index == 1) and curr_scr.tags[1] or curr_scr.tags[10]
                end
                if #t:clients() > 0 then break end
            end
            t:view_only()
            awful.screen.focus_relative( 1)
            t2:view_only()
        end,
        { description = "move tag to next screen", group = screen_group }),
    awful.key({ modkey, altkey    }, ",",
        function ()
            local curr_scr = awful.screen.focused()
            local prev_scr = curr_scr.index > 1
                and screen[curr_scr.index - 1]
                or screen[screen:count()]
            local t = curr_scr.selected_tag
            t2 = prev_scr.tags[t.index]
            for key, client in pairs(t:clients()) do
                client:move_to_tag(t2)
            end
            for key, tag in pairs(curr_scr.tags) do
                if not (tag.index == 11) then
                    t = tag
                else
                    t = (curr_scr.index == 1) and curr_scr.tags[1] or curr_scr.tags[10]
                end
                if #t:clients() > 0 then break end
            end
            t:view_only()
            awful.screen.focus_relative(-1)
            t2:view_only()
        end,
        { description = "move tag to previous screen", group = screen_group }),

    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = client_group}),

    -- Awesome exit/restart
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = awesome_group}),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
              {description = "quit awesome", group = awesome_group}),

    -- Layout switching
    awful.key({ modkey,           }, "]", function () awful.layout.inc( 1)           end,
              {description = "select next", group = layout_group}),
    awful.key({ modkey,           }, "[", function () awful.layout.inc(-1)            end,
              {description = "select previous", group = layout_group}),
    awful.key({ modkey,           }, "y",
        function ()
            local layout = pick_tile_layout(awful.screen.focused(), true)
            awful.layout.set(layout)
        end,
        {description = "Rational tiled layout", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "y",
        function ()
            local layout = pick_tile_layout(awful.screen.focused(), false)
            awful.layout.set(layout)
        end,
        {description = "Irrational tiled layout", group = layout_group}),
    awful.key({ modkey,           }, "u", function () awful.layout.set(awful.layout.layouts[9]) end,
              {description = "Maximized layout", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "u", function () awful.layout.set(awful.layout.layouts[10]) end,
              {description = "Fullscreen layout", group = layout_group}),
    awful.key({ modkey,           }, "i", function () awful.layout.set(awful.layout.layouts[7]) end,
              {description = "Spiral layout", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "i", function () awful.layout.set(awful.layout.layouts[8]) end,
              {description = "Dwindle layout", group = layout_group}),
    awful.key({ modkey,           }, "o", function () awful.layout.set(awful.layout.layouts[11]) end,
              {description = "Monocle layout", group = layout_group}),
    awful.key({ modkey, "Shift"   }, "o", function () awful.layout.set(awful.layout.layouts[12]) end,
              {description = "Floating layout", group = layout_group}),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = launcher_group}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = awesome_group}),
    -- Run menu
    -- awful.key({ modkey }, "space", function() menubar.show() end,
    --           {description = "show the menubar", group = launcher_group}),
    awful.key({ modkey, }, "space",
        function () awful.spawn("rofi -show drun") end,
        {description = "Show rofi applications menu", group = launcher_group}),
    awful.key({ modkey, "Shift" }, "space",
        function () awful.spawn("rofi -show run") end,
        {description = "Show rofi run menu", group = launcher_group}),
    awful.key({ modkey, }, "Tab",
        function () awful.spawn("rofi -show window") end,
        {description  = "Pick window to focus", group = launcher_group}),

    -- Application launchers
    awful.key({ modkey,           }, "Return",
        function () awful.spawn(terminal) end,
        {description = "open a terminal", group = launcher_group}),
    awful.key({ modkey, "Shift" }, "Return",
        function () awful.spawn("alacritty --class noswallow") end,
        {description = "Open an un-swallowable terminal", group = launcher_group}),
    awful.key({ modkey, altkey    }, "space",
        function () awful.spawn("emacs") end,
        {description = "Launch Emacs", group = launcher_group}),
    awful.key({ modkey,           }, "b",
        function () awful.spawn("firefox") end,
        {description = "Launch Firefox", group = launcher_group}),
    awful.key({ modkey, "Shift"   }, "b",
        function () awful.spawn("rofi-firefox") end,
        {description = "Reopen page from Firefox history", group = launcher_group}),
    awful.key({ modkey,           }, "v",
        function () awful.spawn("watchvid") end,
        {description = "Watch video from clipboard", group = launcher_group}),

    -- Utility Scripts
    awful.key({ modkey,           }, "F3",
        function () awful.spawn("displayselect") end,
        {description = "Display configuration", group = scripts_group}),
    awful.key({ modkey,           }, "F9",
        function () awful.spawn("dmenumount") end,
        {description = "Mount drive", group = scripts_group}),
    awful.key({ modkey,           }, "F10",
        function () awful.spawn("dmenuumount") end,
        {description = "Unmount drive", group = scripts_group}),
    awful.key({ modkey,           }, "F12",
        function () awful.spawn("remaps") end,
        {description = "Re-run remaps script", group = scripts_group}),
    awful.key({ modkey,           }, "End",
        function () awful.spawn("sysact") end,
        {description = "System menu", group = scripts_group}),
    awful.key({ modkey, altkey    }, "Return",
        function () awful.spawn("rofi -show ssh") end,
        {description = "Launch a remote (ssh) terminal", group = launcher_group}),
    awful.key({ modkey, altkey    }, "b",
        function () awful.spawn("rofi-chrome") end,
        {description = "Open URL in Chromium app window", group = launcher_group}),
    awful.key({ modkey,           }, "d",
        function () awful.spawn("rofi-pass --last-used") end,
        {description = "Search pass database", group = scripts_group}),
    awful.key({ modkey, "Shift"   }, "d",
        function () awful.spawn("rofi-pass --insert") end,
        {description = "Add new password to pass database", group = scripts_group}),
    awful.key({ modkey,           }, "`",
        function () awful.spawn("rofimoji") end,
        {description = "Rofi emoji picker", group = scripts_group}),
    awful.key({ modkey,           }, "Print",
        function () awful.spawn("maimpick") end,
        {description = "Screenshot menu", group = scripts_group}),
    awful.key({ modkey,           }, "'",
        function () awful.spawn("rofi -show calc") end,
        {description = "Rofi calculator", group = scripts_group}),
    awful.key({ modkey,           }, "p",
        function () awful.spawn("rofi-mpc") end,
        {description = "Rofi mpc", group = scripts_group}),
    awful.key({ modkey,           }, "e",
        function () awful.spawn("rofi-bluetooth") end,
        {description = "Rofi bluetoothctl", group = scripts_group}),
    awful.key({ modkey, "Shift"   }, "/",
        function ()
            local screen = awful.screen.focused()
            local tag = awful.tag.find_by_name(screen, "")
            if tag and not tag.selected then
                awful.tag.viewtoggle(tag)
            end
            awful.spawn("rofi-help")

        end,
        {description = "Rofi documentation picker", group = scripts_group}),
    awful.key({ modkey            }, "=",
        function () awful.spawn("sk-toggle") end,
        {description = "Toggle screenkey", group = scripts_group}),

    -- Scratch applications
    awful.key({ modkey, }, "-", function () term_scratch:toggle() end,
        {description = "Toggle scratch terminal", group = launcher_group}),
    awful.key({ modkey, altkey }, "Delete", function () task_scratch:toggle() end,
        {description = "Toggle system monitor", group = launcher_group}),
    awful.key({ modkey, }, "r", function () file_scratch:toggle() end,
        {description = "Toggle file manager", group = launcher_group}),
    awful.key({ modkey,           }, "F4",
        function () spt_scratch:toggle() end,
        {description = "Toggle spotify-tui", group = launcher_group}),
    awful.key({ modkey, altkey    }, "F4",
        function () mixer_scratch:toggle() end,
        {description = "Toggle mixer console", group = launcher_group}),

    -- Function bindings
    awful.key({}, "Print", function () awful.spawn("") end,
        {description = "Take screenshot", group = functions_group}),
    awful.key({}, "XF86AudioPlay",
        function () awful.spawn("spt playback --toggle") end,
        {description = "Play/Pause Spotify playback", group = functions_group}),
    awful.key({}, "XF86AudioPrev",
        function () awful.spawn("spt playback --previous") end,
        {description = "Previous song", group = functions_group}),
    awful.key({}, "XF86AudioNext",
        function () awful.spawn("spt playback --next") end,
        {description = "Next song", group = functions_group}),
    awful.key({}, "XF86AudioStop",
        function () awful.spawn("systemctl --user stop spotifyd.service") end,
        {description = "Stop media playback", group = functions_group}),
    awful.key({}, "XF86Tools",
        function () awful.spawn("systemctl --user start spotifyd.service") end,
        {description = "Start spotifyd service", group = launcher_group}),
    awful.key({}, "XF86AudioMute",
        function () awful.spawn("pulsemixer --toggle-mute") end,
        {description = "Mute audio", group = functions_group}),
    awful.key({}, "XF86AudioLowerVolume",
        function () awful.spawn("pulsemixer --change-volume -2") end,
        {description = "Lower volume", group = functions_group}),
    awful.key({}, "XF86AudioRaiseVolume",
        function () awful.spawn("pulsemixer --change-volume +2") end,
        {description = "Raise volume", group = functions_group})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = client_group}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = client_group}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = client_group}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = client_group}),
    awful.key({ modkey, "Shift"   }, ".",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = client_group}),
    awful.key({ modkey, "Shift"   }, ",",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = client_group}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = client_group}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = client_group}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = client_group}),
    awful.key({ modkey, altkey }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = client_group}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = client_group})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View existing tag, even if on other screen
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local curr_screen = awful.screen.focused()
                local tag = curr_screen.tags[i]
                if #tag:clients() == 0 then
                    -- Tag is empty on current screen. Search for it elsewhere
                    for s in screen do
                        local t = s.tags[i]
                        if #t:clients() > 0 then
                            -- Tag is non-empty on another screen
                            awful.screen.focus(t.screen)
                            t:view_only()
                            return
                        elseif t.selected then
                            -- Empty tag is already showing on another screen
                            awful.screen.focus(t.screen)
                            t:view_only()
                            return
                        end
                    end
                end
                -- Tag is either nonempty or empty and unselected everywhere
                tag:view_only()
            end,
            {description = "View tag #"..i, group = tag_group}),
        -- View tag on currently focused screen.
        awful.key({ modkey, altkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = tag_group}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = tag_group}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                    tag:view_only()
                end
            end,
            {description = "move focused client to tag #"..i, group = tag_group}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = tag_group})
    )
end
-- Docs tag
globalkeys = gears.table.join(
    globalkeys,
    awful.key({ modkey, }, "slash",
        function ()
            local scr = awful.screen.focused()
            local tag = awful.tag.find_by_name(scr, "")
            if tag then
                awful.tag.viewtoggle(tag)
            end
            if tag.selected then
                for s in screen do
                    if not (s.index == scr.index) then
                        local t = awful.tag.find_by_name(s, "")
                        if #t:clients() > 0 then
                            for key, client in pairs(t:clients()) do
                                client:move_to_tag(tag)
                            end
                        end
                        t.selected = false
                    end
                end
                if #tag:clients() > 0 then
                    tag:clients()[#tag:clients()]:emit_signal(
                        -- Don't know if context is right... Don't care--works
                        "request::activate", "client.jumpto", {raise = true})
                end
            end
        end,
        {description = "toggle documentation tag", group = tag_group})
)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.center
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          -- "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- Popup documentation reader
    { rule = {instance = "man-doc"},
      properties = {
          floating = true,
          maximized_vertical = true,
          width = 1005,
          above = true,
          placement = awful.placement.left,
          tag = ""
      }
    },

    -- Edit with Emacs frame
    { rule = { name = "Edit with Emacs FRAME" },
      properties = {
          floating = true,
          width = 800,
          height = 500,
          placement = awful.placement.centered,
      }
    },

    -- Messaging Apps

    { -- Half width
        rule_any = {
            name = {
                "Signal",
                "Discord",
            }
        },
        properties = {
            maximized_vertical = true,
            width = 840,
            tag = "",
        }
    },

    { -- Three-quarter width
        rule_any = {
            name = {
                "Gmail", "mail.google.com",
                "Outlook", "outlook.office.com",
                "Pulse SMS", "pulsesms.app",
            },
            class = {
                "zoom"
            }
        },
        except = {
            name = "Settings"
        },
        properties = {
            maximized_vertical = true,
            width = 1200,
            tag = "",
        }
    },

    { -- Zoom settings popover
        match = {
            name = "Settings",
            class = "zoom"
        },
        properties = {
            placement = awful.placement.centered
        }
    },

    -- Default tags
    {
        rule_any = {
            class = {
                "Emacs",
                "Code",
            }
        },
        except = { name = "Edit with Emacs FRAME" },
        properties = { tag = "" }
    },
    {
        rule_any = {
            class = {
                "qutebrowser",
                "firefox",
            }
        }, properties = { tag = "" }
    },
    {
        rule_any = {
            class = {
                "Inkscape",
                "Gimp",
            }
        }, properties = { tag = "" }
    },
    {
        rule_any = {
            class = { "Virt-manager"  }
        }, properties = { tag = "" }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.

    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
