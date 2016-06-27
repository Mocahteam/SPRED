VFS.Include("LuaUI/Widgets/editor/TextColors.lua")
local lang = Spring.GetModOptions()["language"]

actions_list = {
	{
		type = "win",
		filter = "Game",
		typeText = "Player wins",
		text = "<Player> wins with state <State>.",
		attributes = {
			{
				text = "<Player>",
				type = "player",
				id = "team"
			},
			{
				text = "<State>",
				type = "text",
				id = "outputState",
				hint = "This string will be used as output state for the scenario editor"
			}
		}
	},
	{
		type = "lose",
		filter = "Game",
		typeText = "Player loses",
		text = "<Player> loses with <State>.",
		attributes = {
			{
				text = "<Player>",
				type = "player",
				id = "team"
			},
			{
				text = "<State>",
				type = "text",
				id = "outputState",
				hint = "This string will be used as output state for the scenario editor"
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
				type = "text",
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
				id = "condition",
				hint = "The condition can be chosen within the conditions of this event, which may not be part of the trigger of this event."
			}
		}
	},
	{
		type = "waitTrigger",
		filter = "Game",
		typeText = "Wait for trigger",
		text = "Wait for <Trigger> to be true.",
		attributes = {
			{
				text = "<Trigger>",
				type = "text",
				id = "trigger",
				hint = "This field must be filled with an boolean expression of the conditions of this event. For example, given an event with 3 conditions C1, C2 and C3, the trigger can be \"C1 or C2\"."
			}
		}
	},
	{
		type = "enableWidget",
		filter = "Game",
		typeText = "Enable Widget",
		text = "Enable <Widget>.",
		attributes = {
			{
				text = "<Widget>",
				type = "widget",
				id = "widget"
			}
		}
	},
	{
		type = "disableWidget",
		filter = "Game",
		typeText = "Disable Widget",
		text = "Disable <Widget>.",
		attributes = {
			{
				text = "<Widget>",
				type = "widget",
				id = "widget"
			}
		}
	},
	{
		type = "feedback",
		filter = "Game",
		typeText = "Change feedback state",
		text = "Feedback is now <State>.",
		attributes = {
			{
				text = "<State>",
				type = "toggle",
				id = "toggle"
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
		text = "Camera auto is now <State>.",
		attributes = {
			{
				text = "<State>",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "mouse",
		filter = "Control",
		typeText = "Change mouse state",
		text = "Mouse is now <State>",
		attributes = {
			{
				text = "<State>",
				type = "toggle",
				id = "toggle"
			}
		}
	},
	{
		type = "createUnits",
		filter = "Unit",
		typeText = "Create Units in Zone",
		text = "Create <Number> units of type <UnitType> for <Team> within <Zone>.",
		attributes = {
			{
				text = "<Number>",
				type = "text",
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
		type = "kill",
		filter = "Unit",
		typeText = "Kill units",
		text = "Kill <UnitSet>.",
		attributes = {
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
		typeText = "Set HP of units",
		text = "Set hit points of <UnitSet> to <Percentage> %.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Percentage>",
				type = "text",
				id = "percentage"
			}
		}
	},
	{
		type = "transfer",
		filter = "Unit",
		typeText = "Transfer units",
		text = "Transfer <UnitSet> to <Team>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
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
		filter = "Unit",
		typeText = "Teleport units",
		text = "Teleport <UnitSet> to <Position>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Position>",
				type = "position",
				id = "position"
			}
		}
	},
	{
		type = "order",
		filter = "Order",
		typeText = "Order units (untargeted order)",
		text = "Order <UnitSet> to begin <Command> with <Parameters>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Parameters>",
				type = "textSplit",
				id = "parameters",
				hint = "Parameters can be specified as numbers separated by ||. Please refer to the game documentation to know which parameter to use."
			}
		}
	},
	{
		type = "orderPosition",
		filter = "Order",
		typeText = "Order units to position",
		text = "Order <UnitSet> to begin <Command> towards <Position>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
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
		type = "orderTarget",
		filter = "Order",
		typeText = "Order units to target",
		text = "Order <UnitSet> to begin <Command> towards <Target>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Command>",
				type = "command",
				id = "command"
			},
			{
				text = "<Target>",
				type = "unitset",
				id = "target"
			}
		}
	},
	{
		type = "messageGlobal",
		filter = "Message",
		typeText = "Display message",
		text = "Display <Message>.",
		attributes = {
			{
				text = '<Message>',
				type = "textSplit",
				id = "message",
				hint = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
			}
		}
	},
	{
		type = "messagePosition",
		filter = "Message",
		typeText = "Display message at position",
		text = "Display <Message> at <Position> for <Time> seconds.",
		attributes = {
			{
				text = '<Message>',
				type = "textSplit",
				id = "message",
				hint = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
			},
			{
				text = "<Position>",
				type ="position",
				id = "position"
			},
			{
				text = "<Time>",
				type = "text",
				id = "time",
				hint = "You can put 0 in this field for an infinite duration."
			}
		}
	},
	{
		type = "messageUnit",
		filter = "Message",
		typeText = "Display message above units",
		text = "Display <Message> over units of <UnitSet> for <Time> seconds",
		attributes = {
			{
				text = "<Message>",
				type = "textSplit",
				id = "message",
				hint = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Time>",
				type = "text",
				id = "time",
				hint = "You can put 0 in this field for an infinite duration."
			}
		}
	},
	{
		type = "bubbleUnit",
		filter = "Message",
		typeText = "Display message in a bubble above units",
		text = "Display <Message> in a bubble over <UnitSet> for <Time> seconds",
		attributes = {
			{
				text = "<Message>",
				type = "textSplit",
				id = "message",
				hint = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
			},
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Time>",
				type = "text",
				id = "time",
				hint = "You can put 0 in this field for an infinite duration."
			}
		}
	},
	{
		type = "markerPosition",
		filter = "Message",
		typeText = "Display marker at position",
		text = "Display a marker with <Message> at <Position> for <Time> seconds.",
		attributes = {
			{
				text = '<Message>',
				type = "textSplit",
				id = "message",
				hint = "Multiple messages can be defined using || to split them. A random one will be picked each time this action is called."
			},
			{
				text = "<Position>",
				type ="position",
				id = "position"
			},
			{
				text = "<Time>",
				type = "text",
				id = "time",
				hint = "You can put 0 in this field for an infinite duration."
			}
		}
	},
	{
		type = "addToGroup",
		filter = "Group",
		typeText = "Add units to group",
		text = "Add <UnitSet> to <Group>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "removeFromGroup",
		filter = "Group",
		typeText = "Remove units from group",
		text = "Remove <UnitSet> from <Group>.",
		attributes = {
			{
				text = "<UnitSet>",
				type = "unitset",
				id = "unitset"
			},
			{
				text = "<Group>",
				type = "group",
				id = "group"
			}
		}
	},
	{
		type = "union",
		filter = "Group",
		typeText = "Union between 2 Unitsets",
		text = "Set <Group> to the union between <UnitSet1> and <UnitSet2>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<UnitSet1>",
				type = "unitset",
				id = "unitset1"
			},
			{
				text = "<UnitSet2>",
				type = "unitset",
				id = "unitset2"
			}
		}
	},
	{
		type = "intersection",
		filter = "Group",
		typeText = "Intersection between 2 Unitsets",
		text = "Set <Group> to the intersection between <UnitSet1> and <UnitSet2>.",
		attributes = {
			{
				text = "<Group>",
				type = "group",
				id = "group"
			},
			{
				text = "<UnitSet1>",
				type = "unitset",
				id = "unitset1"
			},
			{
				text = "<UnitSet2>",
				type = "unitset",
				id = "unitset2"
			}
		}
	},
	{
		type = "showZone",
		filter = "Zone",
		typeText = "Show zone in game",
		text = "Show <Zone> in game.",
		attributes = {
			{
				text = "<Zone>",
				type = "zone",
				id = "zone"
			}
		}
	},
	{
		type = "hideZone",
		filter = "Zone",
		typeText = "Hide zone in game",
		text = "Hide <Zone> in game.",
		attributes = {
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
				id = "variable",
				hint = "Variables can be defined by going to the menu available through the event panel"
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
		type = "changeVariableRandom",
		filter = "Variable",
		typeText = "Change the value of a variable randomly",
		text = "Set <Variable> to a random integer between <Min> and <Max>.",
		attributes = {
			{
				text = "<Variable>",
				type = "numberVariable",
				id = "variable",
				hint = "Variables can be defined by going to the menu available through the event panel"
			},
			{
				text = "<Min>",
				type = "text",
				id = "min"
			},
			{
				text = "<Max>",
				type = "text",
				id = "max"
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
				id = "variable",
				hint = "Variables can be defined by going to the menu available through the event panel"
			},
			{
				text = "<Boolean>",
				type = "boolean",
				id = "boolean"
			}
		}
	},
	{
		type = "script",
		filter = "Script",
		typeText = "Execute custom script",
		text = "Execute custom LUA script <Script>",
		attributes = {
			{
				text = "<Script>",
				type = "text",
				id = "script"
			}
		}
	}
}

-- Disable PP actions when not in a PP version of Spring
if not Game.isPPEnabled then
	for i, a in ipairs(actions_list) do
		if a.type == "feedback" then
			table.remove(actions_list, i)
			break
		end
	end
end

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