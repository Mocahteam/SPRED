VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

conditions_list = {
	{
		type = "start",
		filter = "Game",
		typeText = "Game start",
		text = "When game starts",
		attributes = {}
	},
	{
		type = "unitEntersZone",
		filter = "Unit",
		typeText = "Unit enters Zone",
		text = "<Unit> enters <Zone>",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "groupEntersZone",
		filter = "Group",
		typeText = "Group enters Zone",
		text = "<Group> enters <Zone>",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	}
}

-- COLOR TEXT
for i, c in ipairs(conditions_list) do
	for ii, attr in ipairs(c.attributes) do
		if textColors[attr.type] then
			c.text = string.gsub(c.text, attr.text, textColors[attr.type]..attr.text.."\255\255\255\255")
			attr.text = textColors[attr.type]..attr.text
		end
	end
end