
-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock({ align = "right" }, " %a%m%d%H%M ")

--require("conf_widget_cpu")
--require("conf_widget_mem")
--require("conf_widget_bat")
--require("conf_widget_net")
require("conf_vicious_widget")
require("pomodoro")
-- Create a systray
--mysystray = wibox.widget.systray()

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

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
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
    right_layout:add(pomodoro)

    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mylayoutbox[s])
    right_layout:add(mylauncher)

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
end
-- }}}