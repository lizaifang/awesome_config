-- Author: François de Metz

local widget    = widget
local image     = image
local timer     = gears.timer
local awful     = require("awful")
awful.util      = require("awful.util")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local math      = require("math")
local setmetatable = setmetatable

-- 25 min
local pomodoro_time = 60 * 25

local pomodoro_image_path = beautiful.pomodoro_icon or awful.util.getdir("config") .."/pomodoro/pomodoro.png"

-- setup widget
--local pomodoro_image = image(pomodoro_image_path)

pomodoro = wibox.widget.imagebox()
pomodoro:set_image(pomodoro_image_path)

-- setup timers
local pomodoro_timer = timer({ timeout = pomodoro_time })
local pomodoro_tooltip_timer = timer({ timeout = 1 })
local pomodoro_nbsec = 0

local function pomodoro_start()
    pomodoro_timer:start()
    pomodoro_tooltip_timer:start()
    pomodoro.bg    = beautiful.bg_normal
 end

local function pomodoro_stop()
   pomodoro_timer:stop(pomodoro_timer)
   pomodoro_tooltip_timer:stop(pomodoro_tooltip_timer)
   pomodoro_nbsec = 0
end

local function pomodoro_end()
    pomodoro_stop()
    pomodoro.bg    = beautiful.bg_urgent
end

local function pomodoro_notify(text)
   awful.util.spawn("notify-send 'Pomodoro' ".. text .." -i "..pomodoro_image_path)
end

pomodoro_timer:connect_signal("timeout", function(c) 
                                          pomodoro_end()
                                          pomodoro_notify('Ended')  
                                       end)

pomodoro_tooltip_timer:connect_signal("timeout", function(c) 
                                             pomodoro_nbsec = pomodoro_nbsec + 1
                                       end)

pomodoro_tooltip = awful.tooltip({
    objects = { pomodoro },
    timer_function = function()
        if pomodoro_timer.started then
           r = (pomodoro_time - pomodoro_nbsec) % 60
           return 'End in ' .. math.floor((pomodoro_time - pomodoro_nbsec) / 60) .. ' min ' .. r
        else
           return 'pomodoro not started'
        end
    end,
})

local function pomodoro_start_timer()
   if not pomodoro_timer.started then
      pomodoro_start()
      pomodoro_notify('Started')
   else
      pomodoro_stop()
      pomodoro_notify('Canceled')
   end
end

pomodoro:buttons(awful.util.table.join(
                    awful.button({ }, 1, pomodoro_start_timer)
              ))

setmetatable({ mt = {} }, { __call = function () return pomodoro end })
--setmetatable(_M, { __call = function () return pomodoro end })
