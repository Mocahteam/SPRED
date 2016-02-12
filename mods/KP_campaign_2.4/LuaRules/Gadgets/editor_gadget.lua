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
local selectedUnits = {}
local xUnit, yUnit, zUnit = 0, 0, 0
local dX, dZ = 0, 0
local moveUnits = false

function gadget:Initialize()
	if (Spring.GetModOptions()["editor"] == "yes") then
		Spring.SendCommands("cheat")
		Spring.SendCommands("godmode")
		Spring.SendCommands("globallos")
	end
end

function gadget:RecvLuaMsg(msg, player)
	moveUnit = false
	msgContents = splitString(msg, "++")
	if (msgContents[1] == "Create Unit") then
		createUnit = true
		unitType, team = msgContents[2], tonumber(msgContents[3])
		xUnit, yUnit, zUnit = tonumber(msgContents[4]), tonumber(msgContents[5]), tonumber(msgContents[6])
	elseif (msgContents[1] == "Move Units") then
		moveUnits = true
		dX, dZ = tonumber(msgContents[2]), tonumber(msgContents[3])
	elseif (msgContents[1] == "Select Units") then
		local tmptable = {}
		for i, u in ipairs(msgContents) do
			if i ~= 1 then
				table.insert(tmptable, u)
			end
		end
		selectedUnits = tmptable
	end
end

function gadget:GameFrame( frameNumber )
	if (missionName == "LevelEditor" and createUnit) then
		local unitID = Spring.CreateUnit(unitType, xUnit, yUnit, zUnit, "n", team)
		Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {})
		createUnit = false
	elseif (missionName == "LevelEditor" and selectedUnits ~= {} and moveUnits) then
		for i, u in ipairs(selectedUnits) do
			curX, _, curZ = Spring.GetUnitPosition(u)
			Spring.SetUnitPosition(u, curX + dX, Spring.GetGroundHeight(curX + dX, curZ - dZ), curZ - dZ)
			Spring.GiveOrderToUnit(u, CMD.STOP, {}, {})
		end
		moveUnits = false
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
