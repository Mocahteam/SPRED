VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

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
		typeText = "Repeated event",
		text = "Every <Number> seconds.",
		attributes = {
			{
				text = "<Number>",
				type = "number",
				id = "number"
			}
		}
	},
	{
		type = "unit_zone",
		filter = "Zone",
		typeText = "Unit is in a zone",
		text = "<Unit> is in <Zone>.",
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
		type = "team_zone",
		filter = "Zone",
		typeText = "Units of team are in a zone",
		text = "<Number> units of <Team> are in <Zone>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "group_zone",
		filter = "Zone",
		typeText = "Units of group are in a zone",
		text = "<Number> units of <Group> are in <Zone>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Group>",
				type = "group",
				id = "Group"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "type_zone",
		filter = "Zone",
		typeText = "Units of specific type are in a zone",
		text = "<Number> units of type <UnitType> are in <Zone>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			},
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "unit_underAttack",
		filter = "Attacked",
		typeText = "Unit is under attack",
		text = "<Unit> is under attack.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			}
		}
	},
	{
		type = "team_underAttack",
		filter = "Attacked",
		typeText = "Units of team are under attack",
		text = "<Number> units of <Team> are under attack.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "group_underAttack",
		filter = "Attacked",
		typeText = "Units of group are under attack",
		text = "<Number> units of <Group> are under attack.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "type_underAttack",
		filter = "Attacked",
		typeText = "Units of specific type are under attack",
		text = "<Number> units of type <UnitType> are under attack.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			}
		}
	},
	{
		type = "unit_dead",
		filter = "Dead",
		typeText = "Unit is dead",
		text = "<Unit> is dead.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			}
		}
	},
	{
		type = "team_dead",
		filter = "Dead",
		typeText = "Units of team are dead",
		text = "<Number> units of <Team> are dead.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "group_dead",
		filter = "Dead",
		typeText = "Units of group are dead",
		text = "<Number> units of <Group> are dead.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "type_dead",
		filter = "Dead",
		typeText = "Units of specific type are dead",
		text = "<Number> units of type <UnitType> are dead.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "numberComparison"
			},
			{
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			}
		}
	},
	{
		type = "killed",
		filter = "Kill",
		typeText = "Team killed specific unit",
		text = "<Team> killed <Unit>.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			}
		}
	},
	{
		type = "killed_unit",
		filter = "Kill",
		typeText = "Team killed units",
		text = "<Team> killed <Number> units.",
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
			}
		}
	},
	{
		type = "killed_team",
		filter = "Kill",
		typeText = "Team killed units of target team",
		text = "<Team> killed <Number> units of <TargetTeam>.",
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
				text = "<TargetTeam>",
				type = "team",
				id = "targetTeam"
			}
		}
	},
	{
		type = "killed_group",
		filter = "Kill",
		typeText = "Team killed units of group",
		text = "<Team> killed <Number> units of <Group>.",
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
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "killed_type",
		filter = "Kill",
		typeText = "Team killed units of specific type",
		text = "<Team> killed <Number> units of type <UnitType>.",
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
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			}
		}
	},
	{
		type = "unit_hp",
		filter = "HP",
		typeText = "HP of unit",
		text = "Hit points of <Unit> are at <Percentage> %.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Percentage>",
				type = "numberComparison",
				id = "hp"
			}
		}
	},
	{
		type = "group_hp",
		filter = "HP",
		typeText = "HP of units of group",
		text = "Hit points of <Number> units of <Group> are at <Percentage> %.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Percentage>",
				type = "numberComparison",
				id = "hp"
			}
		}
	},
	{
		type = "team_hp",
		filter = "HP",
		typeText = "HP of units of team",
		text = "Hit points of <Number> units of <Team> are at <Percentage> %.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Percentage>",
				type = "numberComparison",
				id = "hp"
			}
		}
	},
	{
		type = "unit_order",
		filter = "Order",
		typeText = "Unit is doing command",
		text = "<Unit> is doing <Command>.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			}
		}
	},
	{
		type = "group_order",
		filter = "Order",
		typeText = "Units of group are doing command",
		text = "<Number> units of <Group> are doing <Command>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			}
		}
	},
	{
		type = "team_order",
		filter = "Order",
		typeText = "Units of team are doing command",
		text = "<Number> units of <Team> are doing <Command>.",
		attributes = {
			{
				text = "<Number>",
				type = "numberComparison",
				id = "number"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			}
		}
	},
	{
		type = "variableVSnumber",
		filter = "Variable",
		typeText = "Comparison between variable and number",
		text = "<Variable> is <Comparison> <Number>.",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable"
			},
			{
				text = "<Comparison>",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "<Number>",
				type = "number",
				id = "number"
			}
		}
	},
	{
		type = "variableVSvariable",
		filter = "Variable",
		typeText = "Comparison between two variables",
		text = "<Variable> is <Comparison> <Variable>.",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable1"
			},
			{
				text = "<Comparison>",
				type = "comparison",
				id = "comparison"
			},
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable2"
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
				id = "variable"
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