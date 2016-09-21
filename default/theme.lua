---------------------------
-- Default awesome theme --
---------------------------

theme = {}
theme.name          = "default"
theme.confdir       = awful.util.getdir("config")

theme.font          = "WenQuanYi Micro Hei 9"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.confdir .. "/default/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.confdir .. "/default/taglist/squareza.png"
theme.tasklist_floating_icon = theme.confdir .. "/default/icons/sun.png"
--theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
--theme.menu_submenu_icon = theme.confdir .. "/default/submenu.png"
theme.menu_submenu_icon = theme.confdir .. "/default/icons/sun.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.confdir .. "/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.confdir .. "/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.confdir .. "/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
-- theme.wallpaper_cmd = { "awsetbg /media/sda5/Blizzard.Wallpaper.package/body-bg.jpg" }
-- theme.wallpaper_cmd = { "awsetbg /home/xifs/00qbg.png" }
-- theme.wallpaper_cmd = { "awsetbg /home/vehiclee/shot0020.png" }
-- theme.wallpaper_cmd = { "awsetbg /home/37.jpg" }
-- theme.wallpaper = "/home/37.jpg"
-- theme.wallpaper = "/home/lizf/Downloads/wallpaper-2467601.png"
-- theme.wallpaper = "/home/lizf/Downloads/misaka_mikoto_by_ifics-d2zt0fb.png"
-- theme.wallpaper = "/home/shot0003.png"
-- theme.wallpaper = "/home/Misaka-Mikoto-desktopsky-90999.jpg"
-- theme.wallpaper = "/home/lizf/Downloads/rect5399.png"
-- theme.wallpaper = "/home/lizf/Pictures/Bing/RainierMilkyWay_ZH-CN9404321904_1920x1080.jpg"
theme.wallpaper = "/home/lizf/.cache/himawaripy/latest.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = theme.confdir .. "/default/layouts/fairh.png"
theme.layout_fairv      = theme.confdir .. "/default/layouts/fairv.png"
theme.layout_floating   = theme.confdir .. "/default/layouts/floating.png"
theme.layout_magnifier  = theme.confdir .. "/default/layouts/magnifier.png"
theme.layout_max        = theme.confdir .. "/default/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/default/layouts/fullscreen.png"
theme.layout_tilebottom = theme.confdir .. "/default/layouts/tilebottom.png"
theme.layout_tileleft   = theme.confdir .. "/default/layouts/tileleft.png"
theme.layout_tile       = theme.confdir .. "/default/layouts/tilew.png"
theme.layout_tiletop    = theme.confdir .. "/default/layouts/tiletop.png"
theme.layout_spiral     = theme.confdir .. "/default/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/default/layouts/dwindle.png"

theme.awesome_icon = theme.confdir .. "/default/bg.png"

-- {{{ Widget icons
theme.widget_cpu    = theme.confdir .. "/default/icons/cpu.png"
theme.widget_bat    = theme.confdir .. "/default/icons/bat.png"
theme.widget_mem    = theme.confdir .. "/default/icons/mem.png"
theme.widget_fs     = theme.confdir .. "/default/icons/disk.png"
theme.widget_net    = theme.confdir .. "/default/icons/down.png"
theme.widget_netup  = theme.confdir .. "/default/icons/up.png"
theme.widget_wifi   = theme.confdir .. "/default/icons/wifi.png"
theme.widget_mail   = theme.confdir .. "/default/icons/mail.png"
theme.widget_vol    = theme.confdir .. "/default/icons/vol.png"
theme.widget_org    = theme.confdir .. "/default/icons/cal.png"
theme.widget_date   = theme.confdir .. "/default/icons/time.png"
theme.widget_crypto = theme.confdir .. "/default/icons/crypto.png"
theme.widget_sep    = theme.confdir .. "/default/icons/separator.png"
-- }}}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
