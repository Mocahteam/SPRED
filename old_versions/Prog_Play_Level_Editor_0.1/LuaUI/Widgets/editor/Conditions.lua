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
		text = "<Number> units of <UnitSet> are being attacked by <Attacker>.",
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
				text = "<Attacker>",
				type = "unitset",
				id = "attacker"
			}
		}
	},
	{
		type = "attacking",
		filter = "Unit",
		typeText = "Units are attacking",
		text = "<Number> units of <UnitSet> are attacking <Target>.",
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
				text = "<Target>",
				type = "unitset",
				id = "target"
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
		type = "kill",
		filter = "Unit",
		typeText = "Units killed specific units",
		text = "<UnitSet> killed <Number> units of <Target>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Target>",
				type = "unitset",
				id = "target"
			}
		}
	},
	{
		type = "killed",
		filter = "Unit",
		typeText = "Units have been killed by other units",
		text = "<Number> units of <UnitSet> have been killed by <Attacker>.",
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
				text = "<Attacker>",
				type = "unitset",
				id = "attacker"
			}
		}
	},
	{
		type = "hp",
		filter = "Unit",
		typeText = "HP of units",
		text = "Hit points of <Number> units of <UnitSet> are <Comparison> <Percentage> %.",
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
				text = "<Comparison>",
				type = "comparison",
				id = "comparison"
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
		type = "type",
		filter = "Unit",
		typeText = "Units are of specific type",
		text = "<Number> units of <UnitSet> are of type <UnitType>",
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
				text = "<UnitType>",
				type = "unitType",
				id = "type"
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