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

VFS.Include("LuaUI/Widgets/editor/Misc.lua") -- Miscellaneous useful functions

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
local newX, newZ = 0, 0
local angle = 0
local faceAngles = {}
local moveUnits = false
local deleteUnits = false
local transferUnits = false
local rotateUnits = false
local faceUnits = false
local resetMap = false
local moveUnitsAnchor = nil
local relativepos = {}
local hpPercent = -1
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
		relativepos = {}
		moveUnitsAnchor = tonumber(msgContents[2])
		newX, _, newZ = Spring.GetUnitPosition(moveUnitsAnchor)
		for i, u in ipairs(selectedUnits) do
			local curX, _, curZ = Spring.GetUnitPosition(u)
			local refX, _, refZ = Spring.GetUnitPosition(moveUnitsAnchor)
			relativepos[u] = { dx = curX - refX, dz = curZ - refZ }
		end
	-- MOVE UNITS : gets the translation vector for drag movement
	elseif (msgContents[1] == "Move Units") then
		moveUnits = true
		newX, newZ = tonumber(msgContents[2]), tonumber(msgContents[3])
	-- TRANSLATE UNITS : gets the pressed arrow
	elseif (msgContents[1] == "Translate Units") then
		moveUnits = true
		newX, _, newZ = Spring.GetUnitPosition(moveUnitsAnchor)
		local dX, dZ = tonumber(msgContents[2]), tonumber(msgContents[3])
		newX = newX + dX
		newZ = newZ + dZ
	-- ROTATE UNITS : computes the angle of rotation
	elseif (msgContents[1] == "Rotate Units") then
		rotateUnits = true
		local x, z = msgContents[2], msgContents[3]
		local refX, _, refZ = Spring.GetUnitPosition(moveUnitsAnchor)
		local vectX, vectZ = x - refX, z - refZ
		local length = math.sqrt(vectX*vectX + vectZ*vectZ)
		if length > 0 then
			angle = math.atan2(vectX/length, vectZ/length)
		end
	-- FACE UNITS : make units face a point
	elseif (msgContents[1] == "Face Units") then
		faceUnits = true
		local x, z = msgContents[2], msgContents[3]
		faceAngles = {}
		for i, u in ipairs(selectedUnits) do
			local refX, _, refZ = Spring.GetUnitPosition(u)
			local vectX, vectZ = x - refX, z - refZ
			local length = math.sqrt(vectX*vectX + vectZ*vectZ)
			if length > 0 then
				faceAngles[i] = math.atan2(vectX/length, vectZ/length)
			end
		end
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
	-- CHANGE HP : change hp of selected units
	elseif (msgContents[1] == "Change HP") then
		hpPercent = tonumber(msgContents[2])/100
	end
end

function gadget:GameFrame( frameNumber )
	-- EDITOR ONLY
	if missionName == "LevelEditor" then
		-- CREATE UNIT
		if createUnit then
			local unitID = Spring.CreateUnit(unitType, xUnit, Spring.GetGroundHeight(xUnit, zUnit), zUnit, "s", team)
			Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {})
			createUnit = false
		-- MOVE UNITS
		elseif moveUnits then
			if selectedUnits ~= {} then
				Spring.SetUnitPosition(moveUnitsAnchor, newX, Spring.GetGroundHeight(newX, newZ), newZ)
				Spring.GiveOrderToUnit(moveUnitsAnchor, CMD.STOP, {}, {})
				for i, u in ipairs(selectedUnits) do
					if relativepos[u] ~= nil then
						local xtar, ztar = newX + relativepos[u].dx, newZ + relativepos[u].dz
						Spring.SetUnitPosition(u, xtar, Spring.GetGroundHeight(xtar, ztar), ztar)
						Spring.GiveOrderToUnit(u, CMD.STOP, {}, {})
					end
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
				-- Spring.TransferUnit(u, newTeam) --BUGGED
			end
			transfertUnits = false
		-- ROTATE UNITS
		elseif rotateUnits then
			for i, u in ipairs(selectedUnits) do
				Spring.SetUnitRotation(u, 0, -angle, 0)
			end
			rotateUnits = false
		-- FACE UNITS
		elseif faceUnits then
			for i, u in ipairs(selectedUnits) do
				Spring.SetUnitRotation(u, 0, -faceAngles[i], 0)
			end
			faceUnits = false
		-- RESET MAP
		elseif resetMap then
			local units = Spring.GetAllUnits()
			for i = 1,table.getn(units) do
				Spring.DestroyUnit(units[i], false, true)
			end
			resetMap = false
		-- CHANGE HP OF SELECTED UNITS
		elseif hpPercent > 0 and hpPercent <= 1 then
			for i, u in ipairs(selectedUnits) do
				local _, mh = Spring.GetUnitHealth(u)
				Spring.SetUnitHealth(u, hpPercent * mh)
			end
			hpPercent = -1
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
