VFS.Include("LuaUI/Widgets/editor/TextColors.lua")
local lang = Spring.GetModOptions()["language"]

conditions_list = {
	{
		type = "start",
		filter = "Game",
		typeText = "Game start",
		text = "When game starts.",
		attributes = {}
	},
	{
		type = "elapsedTime",
		filter = "Game",
		typeText = "Time elapsed",
		text = "<Number> seconds have elapsed.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			}
		}
	},
	{
		type = "repeat",
		filter = "Game",
		typeText = "Periodically true",
		text = "True every <Number> seconds since the begining of the mission.",
		attributes = {
			{
				text = "<Number>",
				type = "text",
				id = "number"
			}
		}
	},
	{
		type = "zone",
		filter = "Unit",
		typeText = "Units are in a zone",
		text = "<Number> units of <UnitSet> are in <Zone>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "underAttack",
		filter = "Unit",
		typeText = "Units are under attack",
		text = "<Number> units of <UnitSet> are under attack.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			}
		}
	},
	{
		type = "dead",
		filter = "Unit",
		typeText = "Units are dead",
		text = "<Number> units of <UnitSet> are dead.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			}
		}
	},
	{
		type = "killed",
		filter = "Unit",
		typeText = "Team killed specific units",
		text = "<Team> killed <Number> units of <UnitSet>.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			}
		}
	},
	{
		type = "hp",
		filter = "Unit",
		typeText = "HP of units",
		text = "Hit points of <Number> units of <UnitSet> are at <Percentage> %.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Percentage>",
				type = "text",
				id = "hp"
			}
		}
	},
	{
		type = "order",
		filter = "Unit",
		typeText = "Units are doing command",
		text = "<Number> units of <UnitSet> are doing <Command>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			}
		}
	},
	{
		type = "numberVariable",
		filter = "Variable",
		typeText = "Compare the value of a variable",
		text = "<Variable> <Comparison> <Number>.",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable",
				hint = "Variables can be defined by going to the menu available through the event panel"
			},
			{
				text = "<Comparison>",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "<Number>",
				type = "text",
				id = "number",
				hint = "You can put numbers, variables and operators in this field (example : \"(var1 + 3) / 2\")"
			}
		}
	},
	{
		type = "booleanVariable",
		filter = "Variable",
		typeText = "Variable is true",
		text = "<Variable> is true.",
		attributes = {
			{
				text = "<Variable>",
				type = "booleanVariable",
				id = "variable",
				hint = "Variables can be defined by going to the menu available through the event panel"
			}
		}
	},
	{
		type = "script",
		filter = "Script",
		typeText = "Evaluate custom boolean",
		text = "Evaluate custom boolean returned by LUA script <Script>.",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
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

-- ADD FILTER TO THE NAME
for i, c in ipairs(conditions_list) do
	c.typeText = c.filter.." - "..c.typeText
end