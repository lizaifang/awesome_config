-- {{{ Autorun
autorun = true 
autorunApps = {
--	"skype",
--	"feh --bg-scale /home/xifs/Pictures/bamboo2.jpg",
--	"feh --bg-scale /home/xifs/00qbg.png",
}
if autorun then
	for app = 1, #autorunApps do
		awful.util.spawn(autorunApps[app])
	end
end
-- }}}
