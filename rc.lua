print("Entered rc.lua: " .. os.time())
-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")
awful.layout = require("awful.layout")
-- Theme handling library
beautiful = require("beautiful")
wibox = require("wibox")
-- menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local conky_popup = require("conky_popup").widget
-- Notification library
-- require("naughty")

app_folders = { "/usr/share/applications/", "~/.local/share/applications/" }

-- require("conf_var")
terminal = "sakura"
editor = os.getenv("EDITOR") or "vim"
-- editor_cmd = terminal .. " -e " .. editor
editor_cmd = "scite"
modkey = "Mod4"



-- require("conf_theme")
confdir = awful.util.getdir("config")
beautiful.init(confdir .. "/default/theme.lua")
-- beautiful.init(confdir .. "/holo/theme.lua")

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}



--require("conf_layout")
layouts =
{
    awful.layout.suit.magnifier,
	awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
}



--require("conf_tag")
tags = {
	screen = {
		{
			name = { "太微", "紫微", "天市" },
			layout = { layouts[7], layouts[7], layouts[7] }
		},
		{
			name = { "鈞", "蒼", "變", "玄", "幽", "顥", "朱", "炎", "陽" },
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		},
		{
			name = { "乙", "丙", "丁" },
			layout = { layouts[7], layouts[7], layouts[7] }
		},
		{
			name = { "天府", "天相", "天梁", "天同", "天樞", "天機" },
			layout = { layouts[7], layouts[7], layouts[7] }
		},
		{
			name = { "甲子", "甲戌", "甲申", "申午", "甲辰", "甲寅" },
			layout = { layouts[7], layouts[7], layouts[7] }
		},
		{
			name = { "戊", "己", "庚", "辛", "壬", "癸" },
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		},
		{
			name = { "休", "生", "傷", "杜", "景", "死", "驚", "開" },
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		},
		{
			name = { "天樞", "天璇", "天璣", "天權", "玉衡", "開陽", "搖光" },
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		},
		{
			name = { "丁卯", "丁巳", "丁未", "丁酉", "丁亥", "丁丑" },
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		},
		{
			name = { "天覆", "地載", "風揚", "雲垂", "龍飛", "虎翼", "鳥翔", "蛇蟠"},
			layout = { layouts[7], layouts[7], layouts[7], layouts[8], layouts[7], layouts[7], layouts[7], layouts[7], layouts[7]}
		}
	}
}

for s = 1, screen.count() do
	if screen.count() > 1 then
		tags[s] = awful.tag.new( tags.screen[s].name , s, tags.screen[s].layout)
	else
		tags[1] = awful.tag.new( tags.screen[2].name , 1, tags.screen[2].layout)
	end
end

--- set current tag
if screen.count() > 1 then
	tags[2][1].selected = false
	tags[2][5].selected = true
else
	tags[1][1].selected = false
	tags[1][5].selected = true
end



-- require("conf_menu")
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end }
}

menu_freq = {
   { "Hotot", "hotot" },
   { "empathy", "empathy" },
   { "filezilla", "filezilla" },
   { "firefox", "firefox -P -UILocale zh-TW" },
   { "opera", "opera" },
   { "amule", "amule" },
}

mymainmenu = awful.menu({ items = { { "Terminal", terminal },
									{ "Pcmanfm", "pcmanfm" },
									{ "Editor", "scite" },
									{ "Chromium", "chromium-browser" },
									{ "Chrome", "google-chrome" },
									{ "VirtualBox", "VirtualBox" },
									{ "freq", menu_freq },
									{ "awesome", myawesomemenu },
                                  },
                          --theme = {width = 300, height=30}
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })


-- require("conf_widget")

-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock({ align = "right" }, " %a%m%d%H%M ")

-- require("conf_widget_cpu")
-- require("conf_widget_mem")
-- require("conf_widget_bat")
-- require("conf_widget_net")
require("conf_vicious_widget")
require("pomodoro")
local common = require("awful.widget.common")
local systray = require("systray")
-- Create a systray
-- mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                  if not c:isvisible() then
                  awful.tag.viewonly(c:tags()[1])
                  end
                  client.focus = c
                  c:raise()
              end),
    awful.button({ }, 3, function ()
                  if instance then
                  instance:hide()
                  instance = nil
                  else
                  instance = awful.menu.clients({ width=250 })
                  end
              end),
    awful.button({ }, 4, function ()
                  awful.client.focus.byidx(1)
                  if client.focus then client.focus:raise() end
              end),
    awful.button({ }, 5, function ()
                  awful.client.focus.byidx(-1)
                  if client.focus then client.focus:raise() end
              end))

-- get Big Screen as MainScreen
main_screen = 1
for s = 1, screen.count() do
    if screen[s].geometry.width > screen[main_screen].geometry.width then
        main_screen = s
    end
end

print("main screen", main_screen)
print("main screen width", screen[main_screen].geometry.width)

main_screen_layout_btn = awful.widget.layoutbox(main_screen)
main_screen_layout_btn:buttons(awful.util.table.join(
                       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

-- let 1366w screen left 1280w workarea
if screen[main_screen].geometry.width == 1366 then
    bar_width = 86
else
    bar_width = beautiful.get_font_height(theme.font) * 1.5
end
bar_width = beautiful.get_font_height(theme.font) * 1.5

myteststatusbar2 = awful.wibar({screen=main_screen, position = "right", align = "center", ontop = true, width=bar_width})
a = wibox.layout.align.vertical()
b = wibox.layout.fixed.vertical()
b2 = wibox.layout.fixed.vertical()
tagl = awful.widget.taglist(main_screen, awful.widget.taglist.filter.all, mytaglist.buttons, nil, common.list_update, wibox.layout.fixed.vertical())
taskl = awful.widget.tasklist(main_screen, awful.widget.tasklist.filter.currenttags, mytasklist.buttons, nil, common.list_update, wibox.layout.fixed.vertical())
b:add(mylauncher)
b:add(tagl)
b:add(taskl)
a:set_top(b)
-- mytextclock2 = awful.widget.textclock("%a%m%d%H%M")
-- a:set_middle()
b2:add(systray())
b2:add(pomodoro)
-- b2:add(mytextclock2)
b2:add(main_screen_layout_btn)
a:set_bottom(b2)
-- reve[s] = wibox({ x = capi.screen[s].geometry.x, y = capi.screen[s].geometry.height-1, width = 1, height = 1, visible = true, ontop = true, opacity = 0})
myteststatusbar2:set_widget( a )
myteststatusbar2:set_bg("#242424")
-- myteststatusbar2.screen = 1

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    --mytaglist[s] = awful.widget.taglist({screen = s, filter = awful.widget.taglist.filter.all, buttons = mytaglist.buttons, base_widget = wibox.layout.fixed.vertical()})

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- task_tip:add_to_object(mytasklist[s])
    -- task_tip = awful.tooltip({
    --     objects = { mytasklist[s] },
    --     timeout = 1800,
    --     timer_function = function ()
    --         cal = ""
    --         cmd = io.popen("lsblk -o NAME,KNAME,FSTYPE,MOUNTPOINT,LABEL,UUID,SIZE,OWNER,GROUP,MODE")
    --         for line in cmd:lines() do
    --             cal = cal .. line .. "\n"
    --         end
    --         return cal
    --     end
    -- })
    -- Create the wibox
    mywibox[s] = awful.wibar({ position = "top", screen = s})
    -- Add widgets to the wibox - order matters

    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylayoutbox)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    right_layout:add(fsicon)
    right_layout:add(diowidget)
    right_layout:add(separator)
    right_layout:add(neticon)
    right_layout:add(netwidget)
    right_layout:add(netupicon)
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(separator)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(separator)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(dateicon)
    right_layout:add(datewidget)
    right_layout:add(separator)
    --right_layout:add(pomodoro)

    -- if s == main_screen then
    --     print("add systray to screen: " .. s)
    --     right_layout:add(wibox.widget.systray())
    -- end

    -- mytextbox = wibox.widget.textbox()
    -- mytextbox.text = "Hello, world!"
    -- myteststatusbar = awful.wibox({ position = "right", align = "center", ontop = false, width = beautiful.get_font_height(theme.font) * 3})
    -- myteststatusbar.widgets = { mytextbox }
    -- myteststatusbar.screen = 1

    -- right_layout:add(mylayoutbox[s])
    -- right_layout:add(mylauncher)
    -- print(screen[s].geometry.height)
    -- print(screen[s].geometry.width)
    -- print(screen[s].workarea.height)
    -- print(screen[s].workarea.width)
    -- print(screen[s].index)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
end
-- }}}
-- require("awful.dbus")
-- local dbus = dbus
-- print(dbus.request_name("session", "org.globalmenu.manager.service"))


-- require("conf_mouse")
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:show() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- require("conf_key")
-- {{{ Key bindings
-- mod + left/right   switch tag
-- awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
-- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

-- mod + shift + left/right   switch tag with client
-- awful.client.movetotag(tags[client.focus.screen][i])
-- function movetoscreentag(t)
--    awful.util.movetoscreen()
--    awful.util.movetag(t)
-- end
-- mod + alt + left/right   switch screen
-- awful.key({ modkey, "Alt" }, "Left", function () awful.screen.focus_relative(-1) end),
-- awful.key({ modkey, "Alt" }, "Right", function () awful.screen.focus_relative(1) end),

-- mod + ctrl + left/right   switch screen with client

-- mod + n   goto tag
-- mod + shift +n   goto tag with client
-- mod + ctrl + n   goto screen with client

-- awful.key({ "Control", "Shift"}, "grave", function () awful.util.spawn(terminal) end),
-- awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),
-- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
-- awful.key({ "Control"          }, "twosuperior", function () teardrop.toggle(terminal .. " -name dropdown","bottom","center",0.80,0.25,true) end)
local scratch = require("scratch")

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "d",      conky_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("pcmanfm") end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

        awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Screen manipulation
    awful.key({ modkey, "Control" }, "Left", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative(1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
--  awful.key({ modkey,           }, "e", revelation.revelation),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
--    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
--    awful.key({ modkey },            "r",     function() awful.util.spawn_with_shell( "exe=`dmenu_path | dmenu -b -nf '#888888' -nb '#222222' -sf '#ffffff' -sb '#285577'` && exec $exe") end),
    awful.key({ modkey },            "r",     function() awful.util.spawn_with_shell( "exe=`dmenu_run -b -nf '#888888' -nb '#222222' -sf '#ffffff' -sb '#285577'` && exec $exe") end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Lua: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Brightness
    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("xbacklight -dec 15") end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("xbacklight -inc 15") end),
    -- Conky
    awful.key({ modkey }, "F10",
              function()
                local clients = client.get()
                local conky = nil
                local i = 1
                while clients[i]
                do
                    if clients[i].class == "Conky"
                    then
                        conky = clients[i]
                    end
                    i = i + 1
                end
                if conky then
                  conky.ontop = true
                end
              end,
              function()
                local clients = client.get()
                local conky = nil
                local i = 1
                while clients[i]
                do
                    if clients[i].class == "Conky"
                    then
                        conky = clients[i]
                    end
                    i = i + 1
                end
                if conky then
                  conky.ontop = false
                end
              end),
    awful.key({}, "F10",
              function()
                local clients = client.get()
                local conky = nil
                local i = 1
                while clients[i] do
                    if clients[i].class == "Conky"
                    then
                        conky = clients[i]
                    end
                    i = i + 1
                end
                if conky then
                    if conky.ontop then
                        conky.ontop = false
                    else
                        conky.ontop = true
                    end
                end
              end),
    awful.key({ modkey }, "b", function ()
        --myteststatusbar2.visible = not myteststatusbar2.visible
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end)
    -- awful.key({ modkey }, "F11", function () scratch.drop("dmenu") end),
    -- awful.key({ modkey }, "F12", function () scratch.drop("sakura", "bottom") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
      awful.key({ modkey, "Shift"   }, "Left",   function (c) awful.client.movetoscreen(c) end),
    awful.key({ modkey, "Shift"   }, "Right",   function (c) awful.client.movetoscreen(c) end),
      -- awful.key({ modkey, "Shift"   }, "Right",  function (c) awful.client.movetotag(c.tags) end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        -- local screen = mouse.screen
                        -- if tags[screen][i] then
                        --     awful.tag.viewonly(tags[screen][i])
                        -- end
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "切换到标签 #"..i, group = "tag"}),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                          -- awful.screen.focus_relative (i) -1, 1
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      -- if client.focus and tags[client.focus.screen][i] then
                      --    awful.client.movetotag(tags[client.focus.screen][i])
                      --    client.focus:move_to_tag(client.focus.screen.tags[i])
                      --    -- awful.client.movetoscreen()
                      --end
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}



--require("conf_rule")
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = 1,
        border_color = "#252525",
        --border_color = beautiful.border_normal,
        focus = true,
        keys = clientkeys,
        buttons = clientbuttons
      }
    },
    {
      rule_any = { class = {
        "MPlayer", "Skype", "Gimp", "Google-chrome", "Wps", "Chrome", "Virtualbox"
        } },
      properties = { floating = true }
    },
    {
      rule_any = { class = {"Guake", "Steam", "Subl3", "jetbrains-android-studio"} },
      properties = {
        --floating = true,
        maximized_vertical = true,
        maximized_horizontal = true
      }
    },
    {
      rule = { class = "Conky" },
      properties = {
        border_width = 0,
        floating = true,
        sticky = true,
        ontop = false,
        -- hidden = false,
        focusable = false,
        size_hints = {
          "program_position",
          "program_size"
        },
        keys = {}
      }
    },
    {
      rule = { class = "Firefox" },
      properties = {
        floating = true,
        -- tag = tags[1][2]
      }
    },
}
-- }}}



--require("conf_signal")

-- {{{ Signals
-- Signal function to execute when a new client appears.
--[[
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
]]

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 0.75
    end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.75
    end)
-- }}}



--require("conf_autorun")
-- {{{ Autorun
autorun = true 
autorunApps = {
    "cmst",
    "ss-qt5",
--  "skype",
--  "feh --bg-scale /home/xifs/Pictures/bamboo2.jpg",
--  "feh --bg-scale /home/xifs/00qbg.png",
}
if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn(autorunApps[app])
    end
end
-- }}}
mywibox[main_screen].visible = false


-- battery warning
local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()
  local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))
  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if (bat_capacity <= 100 and bat_status == "Discharging") then
    theme.border_normal = "#ff0000"
    theme.border_focus  = "#ff0000"
    theme.border_marked = "#ff0000"
  else
    theme.border_normal = "#000000"
    theme.border_focus  = "#535d6c"
    theme.border_marked = "#91231c"
  end
end

battimer = gears.timer({timeout = 60})
battimer:connect_signal("timeout", bat_notification)
battimer:start()

-- end here for battery warning

--require("revelation")
print("Modules loaded: " .. os.time())
