function widget:GetInfo()
	return {
		name = "Editor Commands List",
		desc = "Get and store the commands of the units of the selected mod",
		author = "mocahteam",
		date = "June 24, 2016",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

local json = VFS.Include("LuaUI/Widgets/libs/LuaJSON/dkjson.lua")
local commandsToID, idToCommands, sortedCommandsList, sortedCommandsListUnit = {}, {}, {}, {}

function generateCommandsList(encodedList, encodedUnitList)
	commandsToID = json.decode(encodedList)
	for c, id in pairs(commandsToID) do
		table.insert(sortedCommandsList, c)
		idToCommands[id] = c
	end
	table.sort(sortedCommandsList)
	local commandsUnitList = json.decode(encodedUnitList)
	for u, cl in pairs(commandsUnitList) do
		sortedCommandsListUnit[u] = {}
		for c, id in pairs(cl) do
			table.insert(sortedCommandsListUnit[u], c)
		end
		table.sort(sortedCommandsListUnit[u])
	end
end

function getCommandsList()
	return json.encode(commandsToID).."++"..json.encode(idToCommands).."++"..json.encode(sortedCommandsList).."++"..json.encode(sortedCommandsListUnit)
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("generateCommandsList", generateCommandsList)
	widgetHandler:RegisterGlobal("getCommandsList", getCommandsList)
end