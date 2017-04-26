-- Defines the tutorial

local unitID

local lang = Spring.GetModOptions()["language"] -- get the language

local function Start ()
	
	-- create my unit for this mission
	unitID = Spring.CreateUnit("bit", 850, Spring.GetGroundHeight(850, 1048), 1048, "e", 0)
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{1250,1048}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
	
	-- Add marker to show target position
	local msg
	if lang == "fr" then
		msg = "Point de ralliement"
	else
		msg = "Rallying point"
	end
	Spring.MarkerAddPoint(1250, Spring.GetGroundHeight(1250, 1048), 1048, msg.."\n(1250, 1048)")
	
	Script.LuaRules.showTuto()
end

local function ShowBriefing ()
end

local function Update (frameNumber)
	
	-- defeat condition	
	if Spring.ValidUnitID(unitID) == false then
		return -1
	end
		
	-- victory condition
	local x, y, z = Spring.GetUnitPosition(unitID)
	if x > 1250-100 and x < 1250+100 and z > 1048-100 and z < 1048+100 then
		return 1
	end
	
	return 0
end

local function Stop ()
	-- delete all units created
	local units = Spring.GetAllUnits() 
	for i = 1,table.getn(units) do
		Spring.DestroyUnit(units[i], false, true)
	end
	
	-- delete marker
	Spring.MarkerErasePosition(1250, Spring.GetGroundHeight(1250, 1048), 1048)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
