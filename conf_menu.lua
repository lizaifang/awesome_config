myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
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
