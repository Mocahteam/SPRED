VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

actions_list = {
	{
		type = "createUnitAtPosition",
		filter = "Unit",
		typeText = "Create Unit at Position",
		text = "Create unit of type <UnitType> for <Team> at <Position>",
		attributes = {
			{
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "moveUnitToPosition",
		filter = "Unit",
		typeText = "Move Unit to Position",
		text = "Move <Unit> to <Position>",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	}
}

-- COLOR TEXT
for i, a in ipairs(actions_list) do
	for ii, attr in ipairs(a.attributes) do
		if textColors[attr.type] then
			a.text = string.gsub(a.text, attr.text, textColors[attr.type]..attr.text.."\255\255\255\255")
			attr.text = textColors[attr.type]..attr.text
		end
	end
end

-- ADD FILTER TO THE NAME
for i, a in ipairs(actions_list) do
	a.typeText = a.filter.." - "..a.typeText
end