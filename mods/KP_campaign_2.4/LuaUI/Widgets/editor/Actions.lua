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
		type = "wait",
		filter = "Game",
		typeText = "Wait",
		text = "Wait <Time> seconds.",
		attributes = {
			{
				text = "<Time>",
				type = "number",
				id = "time"
			}
		}
	},
	{
		type = "waitCondition",
		filter = "Game",
		typeText = "Wait for condition",
		text = "Wait for <Condition> to be true.",
		attributes = {
			{
				text = "<Condition>",
				type = "condition",
				id = "condition"
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
				type = "number",
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
		typeText = "Order unit (untargeted order)",
		text = "Order <Unit> to begin <Command> with <Parameters>.",
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
				text = "<Parameters>",
				type = "text",
				id = "parameters"
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
		typeText = "Order units of group (untargeted order)",
		text = "Order units of <Group> to begin <Command> with <Parameters>.",
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
				text = "<Parameters>",
				type = "text",
				id = "parameters"
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
		typeText = "Order units of team (untargeted order)",
		text = "Order units of <Team> to begin <Command> with <Parameters>.",
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
				text = "<Parameters>",
				type = "text",
				id = "parameters"
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
	},
	{
		type = "setHP",
		filter = "HP",
		typeText = "Set HP of unit",
		text = "Set hit points of <Unit> to <Percentage> %.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Percentage>",
				type = "number",
				id = "percentage"
			}
		}
	},
	{
		type = "addToGroup",
		filter = "Group",
		typeText = "Add unit to group",
		text = "Add <Unit> to <Group>.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "transfer",
		filter = "Transfer",
		typeText = "Transfer unit",
		text = "Transfer <Unit> to <Team>.",
		attributes = {
			{
				text = "<Unit>",
				type = "unit",
				id = "unit"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "transferGroup",
		filter = "Transfer",
		typeText = "Transfer units from group",
		text = "Transfer units of <Group> to <Team>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "transferTeam",
		filter = "Transfer",
		typeText = "Transfer units from team",
		text = "Transfer units of <CurrentTeam> to <Team>.",
		attributes = {
			{
				text = "<CurrentTeam>",
				type = "team",
				id = "currentTeam"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "transferType",
		filter = "Transfer",
		typeText = "Transfer units of type",
		text = "Transfer units of type <UnitType> of <CurrentTeam> to <Team>.",
		attributes = {
			{
				text = "<Number>",
				type = "number",
				id = "number"
			},
			{
				text = "<UnitType>",
				type = "unitType",
				id = "unitType"
			},
			{
				text = "<CurrentTeam>",
				type = "team",
				id = "currentTeam"
			},
			{
				text = "<Team>",
				type = "team",
				id = "team"
			}
		}
	},
	{
		type = "teleport",
		filter = "Teleport",
		typeText = "Teleport unit",
		text = "Teleport <Unit> to <Position>.",
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
	},
	{
		type = "teleportGroup",
		filter = "Teleport",
		typeText = "Teleport units of group",
		text = "Teleport units of <Group> to somewhere within <Zone>.",
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
	},
	{
		type = "teleportTeam",
		filter = "Teleport",
		typeText = "Teleport units of team",
		text = "Teleport units of <Team> to somewhere within <Zone>.",
		attributes = {
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
		type = "changeVariable",
		filter = "Variable",
		typeText = "Set number variable",
		text = "Set <Variable> to <Number>",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable"
			},
			{
				text = "<Number>",
				type = "number",
				id = "number"
			}
		}
	},
	{
		type = "changeVariableNumber",
		filter = "Variable",
		typeText = "Change number variable",
		text = "Set <Variable1> to <Variable2> <Operator> <Number>",
		attributes = {
			{
				text = "<Variable1>",
				type = "numberVariable",
				id = "variable1"
			},
			{
				text = "<Variable2>",
				type = "numberVariable",
				id = "variable2"
			},
			{
				text = "<Operator>",
				type = "operator",
				id = "operator"
			},
			{
				text = "<Number>",
				type = "number",
				id = "number"
			}
		}
	},
	{
		type = "changeVariableVariable",
		filter = "Variable",
		typeText = "Change number variable using other variables",
		text = "Set <Variable1> to <Variable2> <Operator> <Variable3>",
		attributes = {
			{
				text = "<Variable1>",
				type = "numberVariable",
				id = "variable1"
			},
			{
				text = "<Variable2>",
				type = "numberVariable",
				id = "variable2"
			},
			{
				text = "<Operator>",
				type = "operator",
				id = "operator"
			},
			{
				text = "<Variable3>",
				type = "numberVariable",
				id = "variable3"
			}
		}
	},
	{
		type = "setBooleanVariable",
		filter = "Variable",
		typeText = "Set boolean variable",
		text = "Set <Variable> to <Boolean>",
		attributes = {
			{
				text = "<Variable>",
				type = "booleanVariable",
				id = "variable"
			},
			{
				text = "<Boolean>",
				type = "boolean",
				id = "boolean"
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