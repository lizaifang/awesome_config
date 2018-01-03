---------------------------------------------------------------------------
--- Popup widget which shows current hotkeys and their descriptions.
--
-- @author Yauheni Kirylau &lt;yawghen@gmail.com&gt;
-- @copyright 2014-2015 Yauheni Kirylau
-- @module awful.hotkeys_popup.widget
---------------------------------------------------------------------------

local capi = {
    screen = screen,
    client = client,
    keygrabber = keygrabber,
}
local awful = require("awful")
local gtable = require("gears.table")
local gstring = require("gears.string")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local vicious = require("vicious")

-- Stripped copy of this module https://github.com/copycat-killer/lain/blob/master/util/markup.lua:
local markup = {}
-- Set the font.
function markup.font(font, text)
    return '<span font="' .. tostring(font) .. '">' .. tostring(text) .. '</span>'
end

-- Set the foreground.
function markup.fg(color, text)
    return '<span foreground="' .. tostring(color) .. '">' .. tostring(text) .. '</span>'
end

-- Set the background.
function markup.bg(color, text)
    return '<span background="' .. tostring(color) .. '">' .. tostring(text) .. '</span>'
end

local function join_plus_sort(modifiers)
    if #modifiers < 1 then return "none" end
    table.sort(modifiers)
    return table.concat(modifiers, '+')
end

local function get_screen(s)
    return s and capi.screen[s]
end


local widget = {
    group_rules = {},
}

--- Don't show hotkeys without descriptions.
widget.hide_without_description = true

--- Merge hotkey records into one if they have the same modifiers and
-- description.
widget.merge_duplicates = true


--- Hotkeys widget background color.
-- @beautiful beautiful.hotkeys_bg
-- @tparam color hotkeys_bg

--- Hotkeys widget foreground color.
-- @beautiful beautiful.hotkeys_fg
-- @tparam color hotkeys_fg

--- Hotkeys widget border width.
-- @beautiful beautiful.hotkeys_border_width
-- @tparam int hotkeys_border_width

--- Hotkeys widget border color.
-- @beautiful beautiful.hotkeys_border_color
-- @tparam color hotkeys_border_color

--- Hotkeys widget shape.
-- @beautiful beautiful.hotkeys_shape
-- @tparam [ o p t ] gears.shape hotkeys_shape
-- @see gears.shape

--- Foreground color used for hotkey modifiers (Ctrl, Alt, Super, etc).
-- @beautiful beautiful.hotkeys_modifiers_fg
-- @tparam color hotkeys_modifiers_fg

--- Background color used for miscellaneous labels of hotkeys widget.
-- @beautiful beautiful.hotkeys_label_bg
-- @tparam color hotkeys_label_bg

--- Foreground color used for hotkey groups and other labels.
-- @beautiful beautiful.hotkeys_label_fg
-- @tparam color hotkeys_label_fg

--- Main hotkeys widget font.
-- @beautiful beautiful.hotkeys_font
-- @tparam string|lgi.Pango.FontDescription hotkeys_font

--- Font used for hotkeys' descriptions.
-- @beautiful beautiful.hotkeys_description_font
-- @tparam string|lgi.Pango.FontDescription hotkeys_description_font

--- Margin between hotkeys groups.
-- @beautiful beautiful.hotkeys_group_margin
-- @tparam int hotkeys_group_margin


--- Create an instance of widget with hotkeys help.
-- @tparam [ o p t ] table args Configuration options for the widget.
-- @tparam [ o p t ] boolean args.hide_without_description Don't show hotkeys without descriptions.
-- @tparam [ o p t ] boolean args.merge_duplicates Merge hotkey records into one if
-- they have the same modifiers and description.
-- @tparam [ o p t ] int args.width Widget width.
-- @tparam [ o p t ] int args.height Widget height.
-- @tparam [ o p t ] color args.bg Widget background color.
-- @tparam [ o p t ] color args.fg Widget foreground color.
-- @tparam [ o p t ] int args.border_width Border width.
-- @tparam [ o p t ] color args.border_color Border color.
-- @tparam [ o p t ] gears.shape args.shape Widget shape.
-- @tparam [ o p t ] string|lgi.Pango.FontDescription args.font Main widget font.
-- @tparam [ o p t ] string|lgi.Pango.FontDescription args.description_font Font used for hotkeys' descriptions.
-- @tparam [ o p t ] color args.modifiers_fg Foreground color used for hotkey
-- modifiers (Ctrl, Alt, Super, etc).
-- @tparam [ o p t ] color args.label_bg Background color used for miscellaneous labels.
-- @tparam [ o p t ] color args.label_fg Foreground color used for group and other
-- labels.
-- @tparam [ o p t ] int args.group_margin Margin between hotkeys groups.
-- @tparam [ o p t ] table args.labels Labels used for displaying human-readable keynames.
-- @tparam [ o p t ] table args.group_rules Rules for showing 3rd-party hotkeys. @see `awful.hotkeys_popup.keys.vim`.
-- @return Widget instance.
function widget.new(args)
    args = args or {}
    local widget_instance = {
        hide_without_description = (args.hide_without_description == nil) and widget.hide_without_description or args.hide_without_description,
        merge_duplicates = (args.merge_duplicates == nil) and widget.merge_duplicates or args.merge_duplicates,
        group_rules = args.group_rules or gtable.clone(widget.group_rules),
        labels = args.labels or {
            Mod4 = "Super",
            Mod1 = "Alt",
            Escape = "Esc",
            Insert = "Ins",
            Delete = "Del",
            Backspace = "BackSpc",
            Return = "Enter",
            Next = "PgDn",
            Prior = "PgUp",
            ['#108'] = "Alt Gr",
            Left = '←',
            Up = '↑',
            Right = '→',
            Down = '↓',
            ['#67'] = "F1",
            ['#68'] = "F2",
            ['#69'] = "F3",
            ['#70'] = "F4",
            ['#71'] = "F5",
            ['#72'] = "F6",
            ['#73'] = "F7",
            ['#74'] = "F8",
            ['#75'] = "F9",
            ['#76'] = "F10",
            ['#95'] = "F11",
            ['#96'] = "F12",
            ['#10'] = "1",
            ['#11'] = "2",
            ['#12'] = "3",
            ['#13'] = "4",
            ['#14'] = "5",
            ['#15'] = "6",
            ['#16'] = "7",
            ['#17'] = "8",
            ['#18'] = "9",
            ['#19'] = "0",
            ['#20'] = "-",
            ['#21'] = "=",
            Control = "Ctrl"
        },
        _additional_hotkeys = {},
        _cached_wiboxes = {},
        _cached_awful_keys = nil,
        _colors_counter = {},
        _group_list = {},
        _widget_settings_loaded = false,
    }


    function widget_instance:_load_widget_settings()
        if self._widget_settings_loaded then return end
        self.width = args.width or dpi(1200)
        self.height = args.height or dpi(800)
        self.bg = args.bg or beautiful.hotkeys_bg or beautiful.bg_normal
        self.fg = args.fg or beautiful.hotkeys_fg or beautiful.fg_normal
        self.border_width = args.border_width or beautiful.hotkeys_border_width or beautiful.border_width
        self.border_color = args.border_color or beautiful.hotkeys_border_color or self.fg
        self.shape = args.shape or beautiful.hotkeys_shape
        self.modifiers_fg = args.modifiers_fg or beautiful.hotkeys_modifiers_fg or beautiful.bg_minimize or "#555555"
        self.label_bg = args.label_bg or beautiful.hotkeys_label_bg or self.fg
        self.label_fg = args.label_fg or beautiful.hotkeys_label_fg or self.bg
        self.opacity = args.opacity or beautiful.hotkeys_opacity or 1
        -- self.font = args.font or beautiful.hotkeys_font or "Monospace Bold 48"
        self.font = "Monospace Bold 48"
        -- self.description_font = args.description_font or beautiful.hotkeys_description_font or "Monospace 36"
        self.description_font = "Monospace 36"
        self.group_margin = args.group_margin or beautiful.hotkeys_group_margin or dpi(6)
        self.label_colors = beautiful.xresources.get_current_theme()
        self._widget_settings_loaded = true
    end


    function widget_instance:_create_wibox(s, available_groups)
        s = get_screen(s)
        local wa = s.workarea
        local height = (self.height < wa.height) and self.height or
                (wa.height - self.border_width * 2)
        local width = (self.width < wa.width) and self.width or
                (wa.width - self.border_width * 2)

        -- arrange hotkey groups into columns
        local line_height = beautiful.get_font_height(self.font)
        local group_label_height = line_height + self.group_margin
        -- -1 for possible pagination:
        local max_height_px = height - group_label_height
        local column_layouts = {}
        for _, group in ipairs(available_groups) do
            local keys = gtable.join(self._cached_awful_keys[group], self._additional_hotkeys[group])
            local joined_descriptions = ""
            for i, key in ipairs(keys) do
                joined_descriptions = joined_descriptions .. key.description .. (i ~= #keys and "\n" or "")
            end
            -- +1 for group label:
            local items_height = gstring.linecount(joined_descriptions) * line_height + group_label_height
            local current_column
            local available_height_px = max_height_px
            local add_new_column = true
            for i, column in ipairs(column_layouts) do
                if ((column.height_px + items_height) < max_height_px) or
                        (i == #column_layouts and column.height_px < max_height_px / 2) then
                    current_column = column
                    add_new_column = false
                    available_height_px = max_height_px - current_column.height_px
                    break
                end
            end
            local overlap_leftovers
            if items_height > available_height_px then
                local new_keys = {}
                overlap_leftovers = {}
                -- +1 for group title and +1 for possible hyphen (v):
                local available_height_items = (available_height_px - group_label_height * 2) / line_height
                for i = 1, #keys do
                    table.insert(((i < available_height_items) and new_keys or overlap_leftovers), keys[i])
                end
                keys = new_keys
                table.insert(keys, { key = markup.fg(self.modifiers_fg, "▽"), description = "" })
            end
            if not current_column then
                current_column = { layout = wibox.layout.fixed.vertical() }
            end
            --            current_column.layout:add(self:_group_label(group))
--
--            local function insert_keys(_keys, _add_new_column)
--                local max_label_width = 0
--                local max_label_content = ""
--                local joined_labels = ""
--                for i, key in ipairs(_keys) do
--                    local length = string.len(key.key or '') + string.len(key.description or '')
--                    local modifiers = key.mod
--                    if not modifiers or modifiers == "none" then
--                        modifiers = ""
--                    else
--                        length = length + string.len(modifiers) + 1 -- +1 for "+" character
--                        modifiers = markup.fg(self.modifiers_fg, modifiers .. "+")
--                    end
--                    local rendered_hotkey = markup.font(self.font,
--                        modifiers .. (key.key or "") .. " ") .. markup.font(self.description_font,
--                        key.description or "")
--                    if length > max_label_width then
--                        max_label_width = length
--                        max_label_content = rendered_hotkey
--                    end
--                    joined_labels = joined_labels .. rendered_hotkey .. (i ~= #_keys and "\n" or "")
--                end
--                current_column.layout:add(wibox.widget.textbox(joined_labels))
--                local max_width, _ = wibox.widget.textbox(max_label_content):get_preferred_size(s)
--                max_width = max_width + self.group_margin
--                if not current_column.max_width or max_width > current_column.max_width then
--                    current_column.max_width = max_width
--                end
--                -- +1 for group label:
--                current_column.height_px = (current_column.height_px or 0) +
--                        gstring.linecount(joined_labels) * line_height + group_label_height
--                if _add_new_column then
--                    table.insert(column_layouts, current_column)
--                end
--            end

            --            insert_keys(keys, add_new_column)
            --            if overlap_leftovers then
            --                current_column = {layout=wibox.layout.fixed.vertical()}
            --                insert_keys(overlap_leftovers, true)
            --            end
        end

        -- arrange columns into pages
        local available_width_px = width
        local pages = {}
        local columns = wibox.layout.fixed.horizontal()
        local previous_page_last_layout
        for _, item in ipairs(column_layouts) do
            if item.max_width > available_width_px then
                --                previous_page_last_layout:add(
                --                    self:_group_label("PgDn - Next Page", self.label_bg)
                --                )
                table.insert(pages, columns)
                columns = wibox.layout.fixed.horizontal()
                available_width_px = width - item.max_width
                --                item.layout:insert(
                --                    1, self:_group_label("PgUp - Prev Page", self.label_bg)
                --                )
            else
                available_width_px = available_width_px - item.max_width
            end
            local column_margin = wibox.container.margin()
            column_margin:set_widget(item.layout)
            column_margin:set_left(self.group_margin)
            columns:add(column_margin)
            previous_page_last_layout = item.layout
        end
        -----------------------------------
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
        dateicon = wibox.widget {
            image  = beautiful.widget_date,
            resize = false,
            resize_allowed = false,
            forced_height = 16,
            forced_widget = 16,
            widget = wibox.widget.imagebox
        }


        cryptoicon = wibox.widget.imagebox()
        cryptoicon:set_image(beautiful.widget_crypto)
        separator = wibox.widget.imagebox()
        separator:set_image(beautiful.widget_sep)
        dateicon = wibox.widget.imagebox()
        dateicon:set_image(beautiful.widget_date)

        netwidget = wibox.widget.textbox()
        vicious.register(netwidget, vicious.widgets.net, 'wlp3s0 rx: <span color="'
                .. "#FF5656" .. '">${wlp3s0 down_kb}/s</span> wlp3s0 tx: <span color="'
                .. "#88A175" .. '">${wlp3s0 up_kb}/s</span>', 3)


        --- 1st value as state of requested battery
        --- 2nd as charge level in percent
        --- 3rd as remaining (charging or discharging) time
        --- 4th as the wear level in percent and 5th value for the present dis-/charge rate in Watt.
        batwidget = wibox.widget.textbox()

        cputext = wibox.widget {
            widget = wibox.widget.textbox
        }
        vicious.cache(vicious.widgets.cpu)
        -- vicious.register(cputext, vicious.widgets.cpu, "$2% $3% $4% $5%", 3)

        memwidget = wibox.widget.textbox()
        vicious.cache(vicious.widgets.mem)
        --- 1st value as memory usage in percent
        --- 2nd as memory usage
        --- 3rd as total system memory
        --- 4th as free memory
        --- 5th as swap usage in percent
        --- 6th as swap usage
        --- 7th as total system swap
        --- 8th as free swap and 9th as memory usage with buffers and cache
        -- vicious.register(memwidget, vicious.widgets.mem, "mem:$1% used:$2MB swp:$5% used:$6MB", 13)


        diowidget = wibox.widget.textbox()
        vicious.register(diowidget, vicious.widgets.dio, 'sda w: <span color="'
                .. "#FF5656" .. '">${sda write_kb}/s</span> sda r: <span color="'
                .. "#88A175" .. '">${sda read_kb}/s</span>', 3)

        datewidget = wibox.widget.textbox()
        vicious.register(datewidget, vicious.widgets.date, '<span color="#D7D3C5"> %a  %Y-%m-%d %H:%M </span>', 5)


        --- 1st value as usage of all CPUs/cores
        --- 2nd as usage of first CPU/core
        --- 3rd as usage of second CPU/core etc.
        --- cpuwidget = wibox.widget.textbox()
        --- cpuwidget = wibox.widget.progressbar(wibox.container.rotate)
        cpuwidget = wibox.widget {
            background_color = "#ff000033",
            max_value = 100,
            width = 100,
            height = 24,
            step_width = 3,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            direction     = 'east',
            widget = wibox.widget.graph
        }
        -- vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)

        memrow = wibox.layout.fixed.vertical()
        memrow:add(datewidget)
        --- ${color D7D3C5}$acpitemp 'C
        --- ${color}|Processes:${color D7D3C5}  $running_processes|$processes
        memrow:add(cputext)
        -- memrow:add(cpuwidget)
        --- ${color}${cpugraph cpu0 13,36 AEA08E 9F907D} ${color}${cpugraph cpu2 13,36 AEA08E 9F907D}
        --- ${color}${cpugraph cpu1 13,36 AEA08E 9F907D} ${color}${cpugraph cpu3 13,36 AEA08E 9F907D}
        memrow:add(memwidget)
        --- ${color}|Mem: ${color D7D3C5} ${color}${membar 2,64}${color D7D3C5}

        memrow:add(batwidget)
        --- ${battery_percent BAT0}% ${battery_bar 2,64 BAT0}

        memrow:add(netwidget)
        --- ${color}${upspeedgraph wlp3s0 13,36 AEA08E 9F907D}${color 909090} ${color}${downspeedgraph wlp3s0 13,36 AEA08E 9F907D}${color 909090}
        memrow:add(diowidget)
        --- ${color}${diskiograph_read 13,36 AEA08E 9F907D}${color 909090} ${color}${diskiograph_write 13,36 AEA08E 9F907D}${color 909090}


        -- Takes an (optional) argument which, if true, includes remote file systems, only local file systems are included by default
        -- Returns a table with string keys, using mount points as a base: {/ size_mb}, {/ size_gb}, {/ used_mb}, {/ used_gb}, {/ used_p}, {/ avail_mb}, {/ avail_gb}, {/ avail_p}, {/home size_mb} etc.

--        fstext = wibox.widget.textbox()
--        vicious.register(fswidet, vicious.widgets.fs, '/ : <span color="'
--                .. "#FF5656" .. '">${/ size_gb}/s</span> sda r: <span color="'
--                .. "#88A175" .. '">${/ size_}/ avail_gb</span>', 3)

        -- fsbarwidget = wibox.widget.progressbar()


        -- fsbar = wibox.widget {
        --     max_value     = 100,
        --     color = '#88A175',
        --     background_color = '#D7D7C5',
        --     opacity = 1,
        --     widget        = wibox.widget.progressbar,
        -- }
        -- vicious.register(fsbar, vicious.widgets.fs, '$2', 3)
--        vicious.register(fsbar, vicious.widgets.fs, '${/ used_p}', 3)

        fswidget = wibox.widget.textbox()
        vicious.register(fswidget, vicious.widgets.fs, 'sda : <span color="'
                .. "#FF5656" .. '">${/ size_gb}GB</span>/ <span color="'
                .. "#88A175" .. '">${/ avail_mb}MB</span>', 3)

        fswidget2 = wibox.widget.textbox()
        vicious.register(fswidget2, vicious.widgets.fs, 'tmp : <span color="'
                .. "#FF5656" .. '">${/tmp size_gb}GB</span> / <span color="'
                .. "#88A175" .. '">${/tmp avail_mb}MB</span>', 3)

        fswidget3 = wibox.widget.textbox()
        vicious.register(fswidget3, vicious.widgets.fs, 'sdb : <span color="'
                .. "#FF5656" .. '">${/media/sdb1 size_gb}GB</span> / <span color="'
                .. "#88A175" .. '">${/media/sdb1 avail_mb}MB</span>', 3)

        ostext = wibox.widget.textbox()
        -- vicious.register(ostext, vicious.widgets.os, '$1 $2 $3 $4 $5 $6%', 3)
        vicious.register(ostext, vicious.widgets.os, '<span font="Monospace Bold 12">$1 $2 $3 $4 $5 $6%</span>', 3)
        memrow:add(ostext)

        thermaltext = wibox.widget.textbox()
        vicious.register(thermaltext, vicious.widgets.thermal, '$1 $2 $3 $4', 3)
        memrow:add(thermaltext)

        uptimetext = wibox.widget.textbox()
        vicious.register(uptimetext, vicious.widgets.uptime, 'Uptime: $1d $2h $3m Load: $4 $5 $6', 3)
        memrow:add(uptimetext)

        wifitext = wibox.widget.textbox()
        vicious.register(wifitext, vicious.widgets.wifi("wlan0"), 'Wifi: ${ssid}, ${mode}, ${chan}, ${rate}, ${link}, ${linp}% ${sign}', 3)
        memrow:add(wifitext)

        memrow:add(fswidget)
        memrow:add(fswidget3)
       -- memrow:add(fsbar)
        memrow:add(fswidget2)
--        memrow:add(wibox.widget {
--                value              = 0.5,
--                max_value          = 1,
--                min_value          = 0,
--                widget             = wibox.container.radialprogressbar
--            })
        cpuarctext = wibox.widget {
                text   = math.pi/2,
                align  = "center",
                valign = "center",
                widget = wibox.widget.textbox,
            }
        cpuarc = wibox.widget {
            cpuarctext,
            colors = {
                beautiful.bg_normal,
                beautiful.bg_highlight,
                beautiful.border_color,
            },
            -- value = 30,
            max_value    = 100,
            min_value    = 0,
            rounded_edge = false,
            bg           = "#ff000033",
            start_angle  = math.pi/2,
            border_width = 2,
            forced_width = 100,
            forced_height = 100,
--            opacity
--            thickness = 10,
            border_color = "#ff000033",
            widget       = wibox.container.arcchart,
            set_value = function(self, value)
                self.value = tonumber(value)
            end,
        }
        memrow:add(cpuarc)

        batarctext = wibox.widget {
            align  = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        }
        batarc = wibox.widget {
            batarctext,
            colors = {
                beautiful.bg_normal,
                beautiful.bg_highlight,
                beautiful.border_color,
            },
            -- value = 30,
            max_value    = 100,
            min_value    = 0,
            rounded_edge = false,
            bg           = "#ff000033",
            start_angle  = math.pi/2,
            border_width = 2,
            forced_width = 100,
            forced_height = 100,
--            opacity
--            thickness = 10,
            border_color = "#ff000033",
            widget       = wibox.container.arcchart,
            set_value = function(self, value)
                self.value = tonumber(value)
            end,
        }
        memrow:add(batarc)
        -- vicious.register(batwidget, vicious.widgets.bat, "bat: $1 $2%", 61, "BAT0")
        vicious.register(batwidget, vicious.widgets.bat,
        function (widget, args)
            batarc:set_value(args[2])
            batarctext:set_text(args[2])
            return string.format("Battery: %s %02d%%", args[1], args[2])
        end, 31, "BAT0")

        memarctext = wibox.widget {
            align  = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        }
        memarc = wibox.widget {
            memarctext,
            colors = {
                beautiful.bg_normal,
                beautiful.bg_highlight,
                beautiful.border_color,
            },
            -- value = 30,
            max_value    = 100,
            min_value    = 0,
            rounded_edge = false,
            bg           = "#ff000033",
            start_angle  = math.pi/2,
            border_width = 2,
            forced_width = 200,
            forced_height = 200,
--            opacity
--            thickness = 10,
            border_color = "#ff000033",
            widget       = wibox.container.arcchart,
            set_value = function(self, value)
                self.value = tonumber(value)
            end,
        }
        memrow:add(memarc)
        -- vicious.register(memarc, vicious.widgets.mem, "$1", 3)
        -- vicious.register(memarctext, vicious.widgets.mem, "$1", 3)
        -- vicious.register(memwidget, vicious.widgets.mem, "mem:$1% used:$2MB swp:$5% used:$6MB", 13)
        vicious.register(memwidget, vicious.widgets.mem,
        function (widget, args)
            memarc:set_value(args[1])
            memarctext:set_text(args[1])
            return string.format("Mem: %02d%% %dMB Swap: %02d%% %dMB", args[1], args[2], args[5], args[6])
            -- memwidget:set_text("Mem:$1% used:$2MB Swap:$5% used:$6MB")
        end, 3)


    local cal = wibox.widget {
        date         = os.date('*t'),
        font         = 'Monospace 8',
        spacing      = 2,
        week_numbers = true,
        start_sunday = false,
        long_weekdays = true,
        widget       = wibox.widget.calendar.month
    }
    memrow:add(cal)


    ctext = wibox.widget.textbox()
    cgraph = wibox.widget {
        ctext,
        max_value = 100,
        background_color = "#494B4F",
        stack = true,
        width = 100,
        height = 60,
        stack_colors = { "#FF5656", "#88A175", "#AECF96" },
        widget = wibox.widget.graph
    }
    -- vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)
    -- vicious.register(cpuarc, vicious.widgets.cpu, "$2", 3)
    -- vicious.register(cpuarctext, vicious.widgets.cpu, "$2", 3)
    -- vicious.register(cputext, vicious.widgets.cpu, "$2% $3% $4% $5%", 3)
    vicious.register(cputext, vicious.widgets.cpu,
      function (widget, args)
        cpuarc:set_value(args[1])
        cpuarctext:set_text(args[1])
        cpuwidget:add_value(args[1])
        ctext:set_text(args[1])
        cgraph:add_value(args[2], 1) -- Core 1, color 1
        cgraph:add_value(args[3], 2) -- Core 2, color 2
        cgraph:add_value(args[4], 3) -- Core 3, color 3
        return string.format("%02d%% %02d%% %02d%% %02d%%", args[2], args[3], args[4], args[5])
      end, 3)
    memrow:add(cgraph)

    mtext = wibox.widget.textbox()
    mgraph = wibox.widget {
        mtext,
        max_value = 100,
        background_color = "#494B4F",
        -- border_color = beautiful.bg_widget,
        stack = true,
        width = 120,
        height = 60,
        stack_colors = { "#FF5656", "#88A175", "#AECF96" },
        widget = wibox.widget.graph
    }
    -- vicious.register(mtext, vicious.widgets.mem,
    --   function (widget, args)
    --     mtext:set_text(args[1])
    --     mgraph:add_value(args[1], 1)
    --     mgraph:add_value(args[5], 2)
    --     return args[1]
    --   end, 3)
    memrow:add(mgraph)

cpugraph0 = wibox.layout.fixed.vertical()
-- cpugraph0:set_width(120):set_height(20)
-- -- cpugraph0:set_border_color(nil)
-- -- cpugraph0:set_border_color(beautiful.bg_widget)
-- -- cpugraph0:set_background_color(beautiful.bg_widget)
-- cpugraph0:set_color({
--   type = "linear",
--   from = { 0, 120 },
--   to = { 0, 0 },
--   stops = {
--     { 0, beautiful.fg_widget },
--     { 0.25, beautiful.fg_center_widget },
--     { 1, beautiful.fg_end_widget }
--   }
-- })
-- vicious.register(cpugraph0, vicious.widgets.cpu, "$2", 3)

membar = wibox.layout.fixed.vertical()
-- membar:set_vertical(false)
-- membar:set_width(120)
-- membar:set_height(120)
-- membar:set_ticks(false):set_ticks_size(2)
-- membar:set_border_color(nil)
-- membar:set_background_color(beautiful.bg_widget)
-- membar:set_color({
--   type = "linear",
--   from = { 0, 0 },
--   to = { 120, 0 },
--   stops = {
--     { 0, beautiful.fg_widget },
--     { 0.25, beautiful.fg_center_widget },
--     { 1, beautiful.fg_end_widget }
--   }
-- })
-- vicious.register(membar, vicious.widgets.mem, "$1", 3)

        columns = wibox.layout.flex.horizontal()
--        columns:add(datewidget)
        --- columns:add(fsicon)
--        columns:add(diowidget)
        --- columns:add(separator)
        --- columns:add(neticon)
--        columns:add(netwidget)
        --- columns:add(netupicon)
        --- columns:add(separator)
        --- columns:add(cpuicon)
--        columns:add(cpuwidget)
        --- columns:add(separator)
        -- columns:add(memicon)
        columns:add(memrow)
        columns:add(cpugraph0)
        -- columns:add(membar)
        --- columns:add(separator)
        --- columns:add(baticon)
--        columns:add(batwidget)
--        columns:add(dateicon)


--        columns:add(rows)
        table.insert(pages, columns)

        local mywibox = wibox({
            ontop = true,
            bg = self.bg,
            fg = self.fg,
            opacity = self.opacity,
            border_width = self.border_width,
            border_color = self.border_color,
            shape = self.shape,
        })
        mywibox:geometry({
            x = wa.x + math.floor((wa.width - width - self.border_width * 2) / 2),
            y = wa.y + math.floor((wa.height - height - self.border_width * 2) / 2),
            width = width,
            height = height,
        })
        mywibox:set_widget(columns)
        mywibox:buttons(gtable.join(awful.button({}, 1, function() mywibox.visible = false end),
            awful.button({}, 3, function() mywibox.visible = false end)))

        local widget_obj = {}
        widget_obj.current_page = 1
        widget_obj.wibox = mywibox
        function widget_obj.page_next(_self)
            if _self.current_page == #pages then return end
            _self.current_page = _self.current_page + 1
            _self.wibox:set_widget(pages[_self.current_page])
        end

        function widget_obj.page_prev(_self)
            if _self.current_page == 1 then return end
            _self.current_page = _self.current_page - 1
            _self.wibox:set_widget(pages[_self.current_page])
        end

        function widget_obj.show(_self)
            _self.wibox.visible = true
        end

        function widget_obj.hide(_self)
            _self.wibox.visible = false
        end

        return widget_obj
    end


    --- Show popup with hotkeys help.
    -- @tparam [ o p t ] client c Client.
    -- @tparam [ o p t ] screen s Screen.
    function widget_instance:show_help(c, s)
        --- self:_import_awful_keys()
        self:_load_widget_settings()

        c = c or capi.client.focus
        s = s or (c and c.screen or awful.screen.focused())

        local available_groups = {}
        for group, _ in pairs(self._group_list) do
            local need_match
            for group_name, data in pairs(self.group_rules) do
                if group_name == group and (data.rule or data.rule_any or data.except or data.except_any) then
                    if not c or not awful.rules.matches(c, {
                        rule = data.rule,
                        rule_any = data.rule_any,
                        except = data.except,
                        except_any = data.except_any
                    }) then
                        need_match = true
                        break
                    end
                end
            end
            if not need_match then table.insert(available_groups, group) end
        end

        local joined_groups = join_plus_sort(available_groups)
        if not self._cached_wiboxes[s] then
            self._cached_wiboxes[s] = {}
        end
        if not self._cached_wiboxes[s][joined_groups] then
            self._cached_wiboxes[s][joined_groups] = self:_create_wibox(s, available_groups)
        end
        local help_wibox = self._cached_wiboxes[s][joined_groups]
        help_wibox:show()

        return capi.keygrabber.run(function(_, key, event)
            if event == "release" then return end
            if key then
                if key == "Next" then
                    help_wibox:page_next()
                elseif key == "Prior" then
                    help_wibox:page_prev()
                else
                    capi.keygrabber.stop()
                    help_wibox:hide()
                end
            end
        end)
    end

    --- Add hotkey group rules for third-party applications.
    -- @tparam string group hotkeys group name,
    -- @tparam table data rule data for the group
    -- see `awful.hotkeys_popup.key.vim` as an example.
    function widget_instance:add_group_rules(group, data)
        self.group_rules[group] = data
    end

    return widget_instance
end

local function get_default_widget()
    if not widget.default_widget then
        widget.default_widget = widget.new()
    end
    return widget.default_widget
end

--- Show popup with hotkeys help (default widget instance will be used).
-- @tparam [ o p t ] client c Client.
-- @tparam [ o p t ] screen s Screen.
function widget.show_help(...)
    return get_default_widget():show_help(...)
end

return widget

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
