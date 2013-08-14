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
