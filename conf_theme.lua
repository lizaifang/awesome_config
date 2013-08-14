confdir = awful.util.getdir("config")
beautiful.init(confdir .. "/default/theme.lua")

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}