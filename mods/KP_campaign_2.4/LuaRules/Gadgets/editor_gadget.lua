function gadget:GetInfo()
	return {
		name = "Editor Gadget",
		desc = "Allows sync code for the level editor",
		author = "zigaroula",
		date = "02/05/2016",
		license = "GPL v2 or later",
		layer = 0,
		enabled   = true
	}
end

-------------------------------------
-- Useful function to split messages into tokens
-------------------------------------
function splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- SYNCED
--
if (gadgetHandler:IsSyncedCode()) then 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local lang = Spring.GetModOptions()["language"] -- get the language
local missionName = Spring.GetModOptions()["missionname"] -- get the name of the current mission
local createUnit = false
local unitType, team = "bit", 0
local newTeam = 0
local selectedUnits = {}
local xUnit, yUnit, zUnit = 0, 0, 0
local dX, dZ = 0, 0
local moveUnits = false
local deleteUnits = false
local transferUnits = false
local resetMap = false
local moveUnitsAnchor = nil
local missionScript = VFS.Include("MissionPlayer.lua") -- TODO : use something different than missionplayer

function gadget:Initialize()
	-- Allow to see everything and select any unit
	if (Spring.GetModOptions()["editor"] == "yes") then
		Spring.SendCommands("cheat")
		Spring.SendCommands("godmode")
		Spring.SendCommands("spectator")
	end
end

function gadget:RecvLuaMsg(msg, player)
	-- Split message into tokens
	msgContents = splitString(msg, "++")
	-- CREATE UNIT : gets informations about type, team and position
	if (msgContents[1] == "Create Unit") then
		createUnit = true
		unitType, team = msgContents[2], tonumber(msgContents[3])
		xUnit, yUnit, zUnit = tonumber(msgContents[4]), tonumber(msgContents[5]), tonumber(msgContents[6])
	-- ANCHOR : gets information about the anchor of the drag movement
	elseif (msgContents[1] == "Anchor") then
		moveUnitsAnchor = tonumber(msgContents[2])
	-- MOVE UNITS : gets the translation vector for drag movement
	elseif (msgContents[1] == "Move Units") then
		moveUnits = true
		local x, z = tonumber(msgContents[2]), tonumber(msgContents[3])
		local refX, _, refZ = Spring.GetUnitPosition(moveUnitsAnchor)
		dX, dZ = x-refX, z-refZ
	-- TRANSLATE UNITS : gets the pressed arrow
	elseif (msgContents[1] == "Translate Units") then
		moveUnits = true
		dX, dZ = tonumber(msgContents[2]), tonumber(msgContents[3])
	-- SELECT UNITS : gets the current unit selection
	elseif (msgContents[1] == "Select Units") then
		local tmptable = {}
		for i, u in ipairs(msgContents) do
			if i ~= 1 then
				table.insert(tmptable, u)
			end
		end
		selectedUnits = tmptable
	-- DELETE SELECTED UNITS : allows unit destruction
	elseif (msgContents[1] == "Delete Selected Units") then
		deleteUnits = true
	-- TRANSFER UNITS : gets the new team of selected units
	elseif (msgContents[1] == "Transfer Units") then
		newTeam = msgContents[2]
		transferUnits = true
	-- NEW MAP : allows reset of the map
	elseif (msgContents[1] == "New Map") then
		resetMap = true
	-- LOAD MAP : gets the file to load
	elseif (msgContents[1] == "Load Map") then
		missionScript.Start(msgContents[2])
	end
end

function gadget:GameFrame( frameNumber )
	-- EDITOR ONLY
	if missionName == "LevelEditor" then
		-- CREATE UNIT
		if createUnit then
			local unitID = Spring.CreateUnit(unitType, xUnit, Spring.GetGroundHeight(xUnit, zUnit), zUnit, "n", team)
			Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {})
			createUnit = false
		-- MOVE UNITS
		elseif moveUnits then
			if selectedUnits ~= {} then
				for i, u in ipairs(selectedUnits) do
					local curX, _, curZ = Spring.GetUnitPosition(u)
					Spring.SetUnitPosition(u, curX + dX, Spring.GetGroundHeight(curX + dX, curZ + dZ), curZ + dZ)
					Spring.GiveOrderToUnit(u, CMD.STOP, {}, {})
				end
			end
			moveUnits = false
		-- DELETE UNITS
		elseif deleteUnits then
			if selectedUnits ~= {} then
				for i, u in ipairs(selectedUnits) do
					Spring.DestroyUnit(u)
				end
			end
			deleteUnits = false
		-- TRANSFER UNITS
		elseif transferUnits then
			for i, u in ipairs(selectedUnits) do
				--Spring.TransferUnit(u, newTeam) --BUGGED
			end
			transfertUnits = false
		-- RESET MAP
		elseif resetMap then
			local units = Spring.GetAllUnits()
			for i = 1,table.getn(units) do
				Spring.DestroyUnit(units[i], false, true)
			end
			resetMap = false
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 
-- UNSYNCED
--
else
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------





--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
