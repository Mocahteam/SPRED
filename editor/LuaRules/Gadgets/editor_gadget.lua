function gadget:GetInfo()
	return {
		name = "Editor Gadget",
		desc = "Allows sync code for the level editor",
		author = "mocahteam",
		date = "June 24, 2016",
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
local hideMenu = Spring.GetModOptions()["hidemenu"] -- know if menu is hidden
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
local loadMap = false
local unitsInfo = {}
local moveUnitsAnchor = nil
local relativepos = {}
local initialized = false
local cleaned = false

function gadget:Initialize()
	-- Allow to see everything and select any unit
	Spring.SendCommands("cheat")
	Spring.SendCommands("godmode")
	Spring.SendCommands("spectator")
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
		loadMap = true
		unitsInfo = json.decode(msgContents[2])
	end
end

function gadget:GameFrame( frameNumber )
	if not hideMenu then
		SendToUnsynced("finishedLoading")
	else
		if not initialized then
			-- INITIALIZE COMMANDS LIST
			initialized = true
			local cmdList = {}
			local cmdListUnit = {}
			for id, unitDef in pairs(UnitDefs) do
				local unitType = unitDef.name
				cmdListUnit[unitType] = {}
				local id = Spring.CreateUnit(unitType, 0, 0, 0, "s", 0)
				Spring.GiveOrderToUnit(id, CMD.STOP, {}, {})
				Spring.GiveOrderToUnit(id, CMD.FIRE_STATE, {0}, {})
				local cmds = Spring.GetUnitCmdDescs(id)
				for i, cmd in ipairs(cmds) do
					if cmd.id < 0 then
						cmdList["Build "..UnitDefNames[cmd.name].humanName] = cmd.id
						cmdListUnit[unitType]["Build "..UnitDefNames[cmd.name].humanName] = cmd.id
					else
						cmdList[cmd.name] = cmd.id
						cmdListUnit[unitType][cmd.name] = cmd.id
					end
				end
				Spring.DestroyUnit(id, true, true)
			end
			SendToUnsynced("commands".."++"..json.encode(cmdList).."++"..json.encode(cmdListUnit))
		end
		if initialized then
			-- Delete units at the beginning
			if not cleaned and frameNumber > 0 then
				local units = Spring.GetAllUnits()
				if units.n ~= 0 then
					for i, u in ipairs(units) do
						Spring.DestroyUnit(u, true, true)
					end
					cleaned = true
					if Spring.GetModOptions().tobeloaded then
						SendToUnsynced("beginLoadLevel".."++"..Spring.GetModOptions().tobeloaded)
					else
						SendToUnsynced("beginLoadLevel")
					end
					SendToUnsynced("finishedLoading")
				end
			end
			if cleaned then
				-- CREATE UNIT
				if createUnit then
					local unitID = Spring.CreateUnit(unitType, xUnit, Spring.GetGroundHeight(xUnit, zUnit), zUnit, "s", team)
					Spring.GiveOrderToUnit(unitID, CMD.FIRE_STATE, {0}, {})
					createUnit = false
					-- saveSate will be managed by the callin widget:UnitCreated in editor_userinterface.lua
				-- DELETE UNITS
				elseif deleteUnits then
					if selectedUnits ~= {} then
						for i, u in ipairs(selectedUnits) do
							Spring.DestroyUnit(u, false, true)
						end
					end
					deleteUnits = false
					-- saveSate will be managed by the callin widget:UnitDestroyed in editor_userinterface.lua
				-- TRANSFER UNITS
				elseif transferUnits then
					for i, u in ipairs(selectedUnits) do
						Spring.TransferUnit(u, newTeam)
						Spring.GiveOrderToUnit(u, CMD.FIRE_STATE, {0}, {})
						Spring.GiveOrderToUnit(u, CMD.STOP, {}, {})
					end
					transferUnits = false
					SendToUnsynced("saveState")
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
					SendToUnsynced("requestSave")
				-- ROTATE UNITS
				elseif rotateUnits then
					for i, u in ipairs(selectedUnits) do
						Spring.SetUnitRotation(u, 0, -angle, 0)
					end
					rotateUnits = false
					SendToUnsynced("requestSave")
				-- FACE UNITS
				elseif faceUnits then
					for i, u in ipairs(selectedUnits) do
						Spring.SetUnitRotation(u, 0, -faceAngles[i], 0)
					end
					faceUnits = false
					SendToUnsynced("requestSave")
				-- RESET MAP
				elseif resetMap then
					local units = Spring.GetAllUnits()
					for i = 1,table.getn(units) do
						Spring.DestroyUnit(units[i], false, true)
					end
					resetMap = false
				-- INSTANTIATE UNITS AND KEEP THEIR IDs
				elseif loadMap then
					local unitsNewIDs = {}
					for i, u in ipairs(unitsInfo) do
						local newId = Spring.CreateUnit(u.type, u.position.x, u.position.y, u.position.z, "s", u.team)
						Spring.SetUnitRotation(newId, 0, -u.orientation, 0)
						Spring.GiveOrderToUnit(newId, CMD.STOP, {}, {})
						Spring.GiveOrderToUnit(newId, CMD.FIRE_STATE, {0}, {})
						table.insert(unitsNewIDs, {oldId = u.id, newId = newId})
					end
					SendToUnsynced("loadmap".."++"..json.encode(unitsNewIDs))
					loadMap = false
				end
			end
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

function gadget:RecvFromSynced(msg)
	local msgContents = splitString(msg, "++")
	if msgContents[1] == "loadmap" then
		Script.LuaUI.GetNewUnitIDsAndContinueLoadMap(msgContents[2])
	end
	if msg == "saveState" then
		Script.LuaUI.saveState() --registered by editor_user_interface.lua
	end
	if msg == "requestSave" then
		Script.LuaUI.requestSave() --registered by editor_user_interface.lua
	end
	if msgContents[1] == "commands" then
		Script.LuaUI.generateCommandsList(msgContents[2], msgContents[3]) -- registered from editor_userinterface.lua
	end
	if msgContents[1] == "beginLoadLevel" then
		Script.LuaUI.beginLoadLevel(msgContents[2]) -- registered from editor_user_interface.lua
	end
	if msgContents[1] == "finishedLoading" then
		Script.LuaUI.finishedLoading() -- registered from editor_loading_screen.lua
	end
end

-- disable mouse tp control units
function gadget:MousePress(x, y, button)
	return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end
