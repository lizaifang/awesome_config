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
-- Notification library
-- require("naughty")

require("conf_var")
require("conf_theme")
require("conf_layout")
require("conf_tag")
require("conf_menu")
require("conf_widget")
require("conf_mouse")
require("conf_key")
require("conf_rule")
require("conf_signal")
require("conf_autorun")
--require("revelation")
print("Modules loaded: " .. os.time())
