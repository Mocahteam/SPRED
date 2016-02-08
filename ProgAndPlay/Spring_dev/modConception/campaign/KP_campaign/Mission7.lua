-- Defines the Mission 7

local myUnitsId = {}
local enemyUnitsId = {}
local mouseControllerId = {}

local lang = Spring.GetModOptions()["language"] -- get the language

local function Start ()
	-- erase markers teams start position if they exist
	teams = Spring.GetTeamList()
	for i = 1, table.getn(teams) do
		local x, y, z = Spring.GetTeamStartPosition(teams[i])
		Spring.MarkerErasePosition(x, y, z)
	end
		
	-- create my units
	myUnitsId[1] = Spring.CreateUnit("bit", 196, Spring.GetGroundHeight(196, 883), 883, "s", 0)
	myUnitsId[2] = Spring.CreateUnit("bit", 172, Spring.GetGroundHeight(172, 922), 922, "s", 0)
	myUnitsId[3] = Spring.CreateUnit("bit", 228, Spring.GetGroundHeight(228, 1019), 1019, "s", 0)
	myUnitsId[4] = Spring.CreateUnit("bit", 368, Spring.GetGroundHeight(368, 953), 953, "s", 0)
	myUnitsId[5] = Spring.CreateUnit("bit", 425, Spring.GetGroundHeight(425, 1021), 1021, "s", 0)
	myUnitsId[6] = Spring.CreateUnit("bit", 311, Spring.GetGroundHeight(311, 1034), 1034, "s", 0)
	myUnitsId[7] = Spring.CreateUnit("bit", 65, Spring.GetGroundHeight(65, 1056), 1056, "s", 0)
	myUnitsId[8] = Spring.CreateUnit("byte", 282, Spring.GetGroundHeight(282, 950), 950, "s", 0)
	myUnitsId[9] = Spring.CreateUnit("byte", 313, Spring.GetGroundHeight(313, 1087), 1087, "s", 0)
	myUnitsId[10] = Spring.CreateUnit("byte", 209, Spring.GetGroundHeight(209, 1105), 1105, "s", 0)
	myUnitsId[11] = Spring.CreateUnit("assembler", 256, Spring.GetGroundHeight(256, 811), 811, "s", 0)
	
	-- create mouse controller
	mouseControllerId[0] = Spring.CreateUnit("kernel", 1792, Spring.GetGroundHeight(1792,256), 256, "s", 1)
	mouseControllerId[1] = Spring.CreateUnit("socket", 1792, Spring.GetGroundHeight(1792,256), 256, "s", 1)
	
	-- create enemiy units
	enemyUnitsId[1] = Spring.CreateUnit("bit", 1696, Spring.GetGroundHeight(1696, 192), 192, "s", 2)
	enemyUnitsId[2] = Spring.CreateUnit("bit", 1696, Spring.GetGroundHeight(1696, 256), 256, "s", 2)
	enemyUnitsId[3] = Spring.CreateUnit("bit", 1696, Spring.GetGroundHeight(1696, 320), 320, "s", 2)
	enemyUnitsId[4] = Spring.CreateUnit("bit", 1648, Spring.GetGroundHeight(1648, 192), 192, "s", 2)
	enemyUnitsId[5] = Spring.CreateUnit("bit", 1648, Spring.GetGroundHeight(1648, 256), 256, "s", 2)
	enemyUnitsId[6] = Spring.CreateUnit("bit", 1648, Spring.GetGroundHeight(1648, 320), 320, "s", 2)
	enemyUnitsId[7] = Spring.CreateUnit("byte", 1600, Spring.GetGroundHeight(1600, 192), 192, "s", 2)
	enemyUnitsId[8] = Spring.CreateUnit("bit", 1600, Spring.GetGroundHeight(1600, 256), 256, "s", 2)
	enemyUnitsId[9] = Spring.CreateUnit("byte", 1600, Spring.GetGroundHeight(1600, 320), 320, "s", 2)
	enemyUnitsId[10] = Spring.CreateUnit("bit", 1728, Spring.GetGroundHeight(1728, 352), 352, "s", 2)
	enemyUnitsId[11] = Spring.CreateUnit("bit", 1856, Spring.GetGroundHeight(1856, 352), 352, "s", 2)
	enemyUnitsId[12] = Spring.CreateUnit("bit", 1728, Spring.GetGroundHeight(1728, 400), 400, "s", 2)
	enemyUnitsId[13] = Spring.CreateUnit("bit", 1792, Spring.GetGroundHeight(1792, 352), 352, "s", 2)
	enemyUnitsId[14] = Spring.CreateUnit("bit", 1792, Spring.GetGroundHeight(1792, 400), 400, "s", 2)
	enemyUnitsId[15] = Spring.CreateUnit("bit", 1856, Spring.GetGroundHeight(1856, 400), 400, "s", 2)
	enemyUnitsId[16] = Spring.CreateUnit("byte", 1728, Spring.GetGroundHeight(1728, 448), 448, "s", 2)
	enemyUnitsId[17] = Spring.CreateUnit("bit", 1792, Spring.GetGroundHeight(1792, 448), 448, "s", 2)
	enemyUnitsId[18] = Spring.CreateUnit("byte", 1856, Spring.GetGroundHeight(1856, 448), 448, "s", 2)
	enemyUnitsId[19] = Spring.CreateUnit("bit", 1640, Spring.GetGroundHeight(1640, 360), 360, "s", 2)
	enemyUnitsId[20] = Spring.CreateUnit("bit", 1687, Spring.GetGroundHeight(1687, 407), 407, "s", 2)

	
	-- disable mouse
	SendToUnsynced("mouseDisabled", false)
	
	-- point camera to my units
	Spring.SetCameraTarget(256, Spring.GetGroundHeight(256, 990), 990, 1)
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 7\n \n \nVotre armée est fin prête à retourner au combat. Le contrôleur de votre souris est actuellement aux mains de votre adversaire. Il est temps d'aller le récupérer. Lancez l'attaque sur la position (1792, 256).\n \nN'oubliez pas que l'ASSEMBLER (ASSEMBLEUR) peut vous être d'une aide précieuse...\n \nBonne chance commandant."
	else
		msg = "Mission 7\n \n \nAll units are repaired. Now it is time to fight back. The mouse device is protected by your enemy. It is time to get back it. Launch your assault on position (1792, 256).\n \nDon't forget that the ASSEMBLER can provide a precious help...\n \nGood luck."
	end
	Script.LuaRules.showMessage(msg, true, 500)
end

local function Update (frameNumber)
	if frameNumber == 20 then
		-- Add marker to show mouse controller position
		local msg
		if lang == "fr" then
			msg = "Position du contrôleur\nde votre souris (1792, 256)"
		else
			msg = "Mouse device position\n(1792, 256)"
		end
		Spring.MarkerAddPoint(1792, Spring.GetGroundHeight(1792, 256), 256, msg)
		Spring.SetCameraTarget(1792, Spring.GetGroundHeight(1792, 256), 256, 2)
	end
	if frameNumber == 100 then
		-- point camera to my units
		Spring.SetCameraTarget(256, Spring.GetGroundHeight(256, 990), 990, 2)
	end
	
	-- defeat condition
	if Spring.GetTeamUnitCount(0) == 0 or Spring.GetTeamUnitCount(1) == 0 then
		return -1
	end

	-- victory condition
	if Spring.GetTeamUnitCount(2) == 0 then
		Spring.TransferUnit(mouseControllerId[0], 0)
 		Spring.TransferUnit(mouseControllerId[1], 0)
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
	Spring.MarkerErasePosition(256, Spring.GetGroundHeight(256, 990), 990)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
