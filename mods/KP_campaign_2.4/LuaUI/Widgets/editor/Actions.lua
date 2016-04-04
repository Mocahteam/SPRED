VFS.Include("LuaUI/Widgets/editor/TextColors.lua")

actions_list = {
	{
		type = "teamWin",
		filter = "Game",
		typeText = "Team wins",
		text = "<Team> wins.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "teamLose",
		filter = "Game",
		typeText = "Team loses",
		text = "<Team> loses.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "centerCamera",
		filter = "Control",
		typeText = "Center camera to position",
		text = "Center camera to <Position>.",
		attributes = {
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "cameraAuto",
		filter = "Control",
		typeText = "Change camera auto state",
		text = "<Toggle> camera auto.",
		attributes = {
			{
				text = "<Toggle>",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "mouse",
		filter = "Control",
		typeText = "Change mouse state",
		text = "<Toggle> mouse control.",
		attributes = {
			{
				text = "<Toggle>",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "createUnitAtPosition",
		filter = "Unit",
		typeText = "Create Unit at Position",
		text = "Create unit of type <UnitType> for <Team> at <Position>.",
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
		type = "createUnitsInZone",
		filter = "Unit",
		typeText = "Create Units in Zone",
		text = "Create <Number> units of type <UnitType> for <Team> within <Zone>.",
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
		type = "orderUnit",
		filter = "Order",
		typeText = "Order unit",
		text = "Order <Unit> to begin <Command>.",
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
		type = "orderUnitPosition",
		filter = "Order",
		typeText = "Order unit to position",
		text = "Order <Unit> to begin <Command> towards <Position>.",
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
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "orderUnitTarget",
		filter = "Order",
		typeText = "Order unit to target",
		text = "Order <Unit> to begin <Command> towards <Target>.",
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
			},
			{
				text = "<Target>",
				type = "unit",
				id = "target"
			}
		}
	},
	{
		type = "orderUnitGroup",
		filter = "Order",
		typeText = "Order units of group",
		text = "Order units of <Group> to begin <Command>.",
		attributes = {
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
		type = "orderUnitGroupPosition",
		filter = "Order",
		typeText = "Order units of group to position",
		text = "Order units of <Group> to begin <Command> towards <Position>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "orderUnitGroupTarget",
		filter = "Order",
		typeText = "Order units of group to target",
		text = "Order units of <Group> to begin <Command> towards <Target>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Target>",
				type = "unit",
				id = "target"
			}
		}
	},
	{
		type = "orderUnitTeam",
		filter = "Order",
		typeText = "Order units of team",
		text = "Order units of <Team> to begin <Command>.",
		attributes = {
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
		type = "orderUnitTeamPosition",
		filter = "Order",
		typeText = "Order units of team to position",
		text = "Order units of <Team> to begin <Command> towards <Position>.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "orderUnitTeamTarget",
		filter = "Order",
		typeText = "Order units of team to target",
		text = "Order units of <Team> to begin <Command> towards <Target>.",
		attributes = {
			{
				text = "<Team>",
				type = "team",
				id = "team"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Target>",
				type = "unit",
				id = "target"
			}
		}
	},
	{
		type = "messageUnit",
		filter = "Message",
		typeText = "Display message above unit",
		text = "Display <Message> over <Unit> for <Time> seconds",
		attributes = {
			{
				text = "<Message>",
				type = "text",
				id = "message"
			},
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Time>",
				type = "number",
				id = "time"
			}
		}
	},
	{
		type = "killUnit",
		filter = "Kill",
		typeText = "Kill unit",
		text = "Kill <Unit>.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			}
		}
	},
	{
		type = "killGroup",
		filter = "Kill",
		typeText = "Kill group",
		text = "Kill units of <Group>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "killTypeTeam",
		filter = "Kill",
		typeText = "Kill units of type of team",
		text = "Kill units of type <UnitType> of <Team>.",
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
			}
		}
	},
	{
		type = "killZone",
		filter = "Kill",
		typeText = "Kill units in zone",
		text = "Kill units in <Zone>",
		attributes = {
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
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