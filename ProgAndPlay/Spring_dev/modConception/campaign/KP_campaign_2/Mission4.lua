-- Defines the Mission 4

local myUnits = {}

local lang = Spring.GetModOptions()["language"] -- get the language

local function Start ()
		
	-- units initialisation
	for i = 1,10 do
		myUnits[i] = {id = nil, maxHealth = nil}
	end
	
	-- create my unit
	myUnits[1].id = Spring.CreateUnit("bit", 1400, Spring.GetGroundHeight(1400, 1371), 1371, "w", 0)
	myUnits[2].id = Spring.CreateUnit("bit", 1461, Spring.GetGroundHeight(1461, 1453), 1453, "w", 0)
	myUnits[3].id = Spring.CreateUnit("bit", 1379, Spring.GetGroundHeight(1379, 1444), 1444, "w", 0)
	myUnits[4].id = Spring.CreateUnit("bit", 1438, Spring.GetGroundHeight(1438, 1313), 1313, "w", 0)
	myUnits[5].id = Spring.CreateUnit("bit", 1328, Spring.GetGroundHeight(1328, 1381), 1381, "w", 0)
	myUnits[6].id = Spring.CreateUnit("bit", 1311, Spring.GetGroundHeight(1311, 1311), 1311, "w", 0)
	myUnits[7].id = Spring.CreateUnit("bit", 1408, Spring.GetGroundHeight(1408, 1266), 1266, "w", 0)
	myUnits[8].id = Spring.CreateUnit("byte", 479, Spring.GetGroundHeight(479, 1825), 1825, "n", 0)
	myUnits[9].id = Spring.CreateUnit("byte", 449, Spring.GetGroundHeight(449, 1758), 1758, "n", 0)
	myUnits[10].id = Spring.CreateUnit("byte", 507, Spring.GetGroundHeight(507, 1894), 1894, "n", 0)	
	
	-- damage units and store units maxHealth
	local tmp
	for i = 1,table.getn(myUnits) do
		tmp, myUnits[i].maxHealth = Spring.GetUnitHealth(myUnits[i].id)
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
	end
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- minimize minimap
	Spring.SendCommands("minimap min")
	
	-- disable a set of widgets
	-- widget named : Kernel Panic Mission Briefing
	Spring.SendCommands("luaui disablewidget Kernel Panic Mission Briefing")
	-- widget named : Kernel Panic Automatic Tip Dispenser
	Spring.SendCommands("luaui disablewidget Kernel Panic Automatic Tip Dispenser")
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{256,1024}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
	
	-- Add marker to show rally point
	local msg
	if lang == "fr" then
		msg = "Point de ralliement\n(256, 1024)"
	else
		msg = "Rallying point\n(256, 1024)"
	end
	Spring.MarkerAddPoint(256, Spring.GetGroundHeight(256, 1024), 1024, msg)
		
	-- -- point camera to initial bits position
	-- Spring.SetCameraTarget(1400, Spring.GetGroundHeight(1400, 1371), 1371, 1)
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 4\n \n \nToutes les entités que vous possédez ont subi de lourds dommages lors de la précédente attaque. Vous devez les réparer avant de lancer la contre-attaque.\nLe dernier ASSEMBLER (ASSEMBLEUR) encore en marche et capable d'effectuer les réparations est en route vers le point de ralliement aux coordonnées (256, 1024).\n \nDéplacez toute votre armée à la rencontre de cet ASSEMBLER (ASSEMBLEUR)."
	else
		msg = "Mission 4\n \n \nAll units you control are weakened. You must repair them before starting a counter attack.\nThe latest ASSEMBLER available to repair your units is moving to the rallying point (256, 1024).\n \nMove all units to this position."
	end
	Script.LuaRules.showMessage(msg, true, 500)
end

local function Update (frameNumber)
	-- if frameNumber == 20 then
		-- -- point camera to bytes position
		-- Spring.SetCameraTarget(479, Spring.GetGroundHeight(479, 1825), 1825, 2)
	-- end
	-- if frameNumber == 80 then
		-- -- Add marker to show rally point
		-- local msg
		-- if lang == "fr" then
			-- msg = "Point de ralliement\n(256, 1024)"
		-- else
			-- msg = "Rallying point\n(256, 1024)"
		-- end
		-- Spring.MarkerAddPoint(256, Spring.GetGroundHeight(256, 1024), 1024, msg)
		-- Spring.SetCameraTarget(256, Spring.GetGroundHeight(256, 1024), 1024, 2)
	-- end
	-- if frameNumber == 140 then
		-- -- point camera to initial bits position
		-- Spring.SetCameraTarget(1400, Spring.GetGroundHeight(1400, 1371), 1371, 2)
	-- end
	
	-- defeat condition
	for i = 1,table.getn(myUnits) do
		if Spring.ValidUnitID(myUnits[i].id) == false then
			return -1
		end
	end
	
	-- cancel autoheal
	for i = 1,table.getn(myUnits) do
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
	end

	-- victory condition
	for i = 1,table.getn(myUnits) do
		local x, y, z = Spring.GetUnitPosition(myUnits[i].id)
		if x > 500 or z < 620 or z > 1438 then
			return 0
		end
	end
	
	return 1
end

local function Stop ()
	-- delete all units created
	local units = Spring.GetAllUnits() 
	for i = 1,table.getn(units) do
		Spring.DestroyUnit(units[i], false, true)
	end
	
	-- delete marker
	Spring.MarkerErasePosition(256, Spring.GetGroundHeight(256, 1024), 1024)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
