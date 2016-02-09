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
local selectedUnit = nil
local xUnit, yUnit, zUnit = 0, 0, 0
local newX, newY, newZ = 0, 0, 0

function gadget:RecvLuaMsg(msg, player)
	msgContents = splitString(msg, "++")
	if (msgContents[1] == "Create Unit") then
		createUnit = true
		unitType, team = msgContents[2], tonumber(msgContents[3])
		xUnit, yUnit, zUnit = tonumber(msgContents[4]), tonumber(msgContents[5]), tonumber(msgContents[6])
	elseif (msgContents[1] == "Select Unit") then
		selectedUnit = msgContents[2]
		newX, newY, newZ = tonumber(msgContents[3]), tonumber(msgContents[4]), tonumber(msgContents[5])
	elseif (msgContents[1] == "Deselect Unit") then
		selectedUnit = nil
	elseif (msgContents[1] == "Move Unit") then
		newX, newY, newZ = tonumber(msgContents[2]), tonumber(msgContents[3]), tonumber(msgContents[4])
	end
end

function gadget:GameFrame( frameNumber )
	if (missionName == "LevelEditor" and createUnit) then
		local unitID = Spring.CreateUnit(unitType, xUnit, yUnit, zUnit, "n", team)
		Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {})
		createUnit = false
	elseif (missionName == "LevelEditor" and selectedUnit ~= nil) then
		Spring.SetUnitPosition(selectedUnit, newX, Spring.GetGroundHeight(newX, newZ), newZ)
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
