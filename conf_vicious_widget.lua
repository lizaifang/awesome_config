--require("vicious")
local vicious = require("vicious")

-- {{{ Icons
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_bat)
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
neticon = wibox.widget.imagebox()
neticon:set_image(beautiful.widget_net)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
mailicon = wibox.widget.imagebox()
mailicon:set_image(beautiful.widget_mail)
--volicon = wibox.widget.imagebox()
--volicon:set_image(beautiful.widget_vol)
orgicon = wibox.widget.imagebox()
orgicon:set_image(beautiful.widget_org)
dateicon = wibox.widget.imagebox()
dateicon:set_image(beautiful.widget_date)
cryptoicon = wibox.widget.imagebox()
cryptoicon:set_image(beautiful.widget_crypto)
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)
-- }}}

-- {{{ Battery state
--batwidget = awful.widget.progressbar()
--batwidget:set_width(8)
--batwidget:set_height(10)
--batwidget:set_vertical(true)
--batwidget:set_background_color("#494B4F")
--batwidget:set_border_color(nil)
--batwidget:set_color("#AECF96")
--batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
--vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT1")
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ CPU usage and temperature
--cpugraph  = awful.widget.graph()
--cpuwidget = wibox.widget.textbox()
--tzswidget = wibox.widget.textbox()
--vicious.register(cpugraph,  vicious.widgets.cpu, "$1")
--vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")
--vicious.register(tzswidget, vicious.widgets.thermal, " $1C", 19, "thermal_zone0")
--cpuwidget = awful.widget.graph()
--cpuwidget:set_width(32)
--cpuwidget:set_background_color("#494B4F")
--cpuwidget:set_color("#FF5656")
--cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
--vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)
-- }}}

-- {{{ Memory usage
--membar = awful.widget.progressbar()
--membar:set_vertical(true):set_ticks(true)
--membar:set_height(12):set_width(8):set_ticks_size(2)
--membar:set_background_color(beautiful.fg_off_widget)
-- membar:set_gradient_colors({ beautiful.fg_widget,
--   beautiful.fg_center_widget, beautiful.fg_end_widget
-- })
--membar:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
--vicious.register(membar, vicious.widgets.mem, "$1", 13)
memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "$1%$2MB", 13)
-- }}}


-- {{{ Network usage
netwidget = wibox.widget.textbox()
--vicious.register(netwidget, vicious.widgets.net, '<span color="'
--    .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span> <span color="'
--    .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)
vicious.register(netwidget, vicious.widgets.net, '<span color="'
    .. "#FF5656" ..'">${wlp3s0 down_kb}</span> <span color="'
    .. "#88A175" ..'">${wlp3s0 up_kb}</span>', 3)
-- }}}

-- {{{ DiskIO usage
diowidget = wibox.widget.textbox()
--vicious.register(netwidget, vicious.widgets.net, '<span color="'
--    .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span> <span color="'
--    .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)
diotip = awful.tooltip({
	objects = { fsicon },
	timeout = 1800,
	timer_function = function ()
		cal = ""
		cmd = io.popen("lsblk -o NAME,KNAME,FSTYPE,MOUNTPOINT,LABEL,UUID,SIZE,OWNER,GROUP,MODE")
		for line in cmd:lines() do
			cal = cal .. line .. "\n"
		end
		return cal
	end
})
vicious.register(diowidget, vicious.widgets.dio, '<span color="'
    .. "#FF5656" ..'">${sda write_kb}</span> <span color="'
    .. "#88A175" ..'">${sda read_kb}</span>', 3)
-- }}}

-- {{{ Date and time
dateicon = wibox.widget.imagebox()
dateicon:set_image(beautiful.widget_date)
datewidget = wibox.widget.textbox()
datetip = awful.tooltip({
	objects = { dateicon },
	timeout = 1800,
	timer_function = function ()
		cal = ""
		cmd = io.popen("cal -3")
		for line in cmd:lines() do
			cal = cal .. line .. "\n"
		end
		return cal
	end
})
vicious.register(datewidget, vicious.widgets.date, " %a%m%d%H%M ", 5)
--datewidget:buttons(awful.util.table.join(
--	awful.button({ }, 1, function () exec(bin .. "pylendar.py") end)
--))
-- }}}
