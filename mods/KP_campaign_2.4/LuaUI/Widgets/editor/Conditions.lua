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
		type = "win",
		filter = "Game",
		typeText = "Team won",
		text = "<Team> has won the game.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "lose",
		filter = "Game",
		typeText = "Team lost",
		text = "<Team> has lost the game.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
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
		type = "unitZone",
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
		type = "unitTeamZone",
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
		type = "unitGroupZone",
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
		type = "unitTypeZone",
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
		type = "deadUnit",
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
		type = "deadTeamUnits",
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
		type = "deadGroupUnits",
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
		type = "deadTypeUnits",
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
		type = "teamKilledUnits",
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
		type = "teamKilledUnitsType",
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
		type = "hpUnit",
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
		type = "hpUnitGroup",
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
		type = "hpUnitTeam",
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