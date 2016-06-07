-- Defines the Mission 4

local myUnits = {}
local lostUnits = {}

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()
		
	-- units initialisation
	for i = 1,2 do
		myUnits[i] = {id = nil, maxHealth = nil}
	end
	for i = 1,8 do
		lostUnits[i] = {id = nil, maxHealth = nil}
	end
	
	-- create my unit
	myUnits[1].id = Spring.CreateUnit("bit", 1120, Spring.GetGroundHeight(1120, 1760), 1760, "n", 0)
	myUnits[2].id = Spring.CreateUnit("byte", 1056, Spring.GetGroundHeight(1056, 1792), 1792, "w", 0)
	
	-- create lost units
	lostUnits[1].id = Spring.CreateUnit("byte", 449, Spring.GetGroundHeight(449, 1758), 1758, "s", 1)
	lostUnits[2].id = Spring.CreateUnit("byte", 507, Spring.GetGroundHeight(507, 1894), 1894, "s", 1)
	lostUnits[3].id = Spring.CreateUnit("bit", 1461, Spring.GetGroundHeight(1461, 1453), 1453, "s", 1)
	lostUnits[4].id = Spring.CreateUnit("bit", 1379, Spring.GetGroundHeight(1379, 1444), 1444, "s", 1)
	lostUnits[5].id = Spring.CreateUnit("bit", 1438, Spring.GetGroundHeight(1438, 1313), 1313, "s", 1)
	lostUnits[6].id = Spring.CreateUnit("bit", 1328, Spring.GetGroundHeight(1328, 1381), 1381, "s", 1)
	lostUnits[7].id = Spring.CreateUnit("bit", 1311, Spring.GetGroundHeight(1311, 1311), 1311, "s", 1)
	lostUnits[8].id = Spring.CreateUnit("bit", 1408, Spring.GetGroundHeight(1408, 1266), 1266, "s", 1)
	
	
	-- damage units and store units maxHealth
	local tmp
	for i = 1,table.getn(myUnits) do
		tmp, myUnits[i].maxHealth = Spring.GetUnitHealth(myUnits[i].id)
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
	end
	for i = 1,table.getn(lostUnits) do
		tmp, lostUnits[i].maxHealth = Spring.GetUnitHealth(lostUnits[i].id)
		Spring.SetUnitHealth(lostUnits[i].id, lostUnits[i].maxHealth/4)
	end
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{479,1825}, {1400, 1371}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 4\n \n \nPour vous remercier de votre aide, l'OCTET (BYTE) se rallie � notre cause et vous informe que d'autres entit�s partisanes se sont regroup�es non loin de l�. Il vous communique les coordonn�es de la formation d'OCTETS qu'il tentait de rejoindre avant votre arriv�e (479, 1825). Il vous indique �galement qu'un ensemble de BITS s'est rassembl� aux coordonn�es (1400, 1371).\n \nAfin de r�cup�rer ces nouvelles forces, ordonnez � vos deux entit�s de rejoindre leurs compatriotes respectifs.\n \n"..gray.."Appuyez sur Echap pour continuer"
	else
		msg = "Mission 4\n \n \nIn order to thank you for your help, the BYTE is won over and tells you that other partisan units are reassembled not far. It gives you the position (479, 1825) of a BYTE group that it tries to rally. Moreover, it warns you that a group of BITS is forming at position (1400, 1371).\n \nTo retrieve these units, command your two units to meet up with their respective groups.\n \n"..gray.."Press Escape to continue"
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function Update (frameNumber)
	if frameNumber == 20 then
		-- Add marker to show bytes position
		local msg
		if lang == "fr" then
			msg = "Point de ralliement\ndes bytes (479, 1825)"
		else
			msg = "Bytes rallying point\n(479, 1825)"
		end
		Spring.MarkerAddPoint(479, Spring.GetGroundHeight(479, 1825), 1825, msg)
		-- Add marker to show bits position
		if lang == "fr" then
			msg = "Point de ralliement\ndes bits (1400, 1371)"
		else
			msg = "Bits rallying point\n(1400, 1371)"
		end
		Spring.MarkerAddPoint(1400, Spring.GetGroundHeight(1400, 1371), 1371, msg)
	end
	
	-- defeat condition	
	local defeat = false
	for i = 1,table.getn(myUnits) do
		defeat = defeat or Spring.ValidUnitID(myUnits[i].id) == false
	end
	for i = 1,table.getn(lostUnits) do
		defeat = defeat or Spring.ValidUnitID(lostUnits[i].id) == false
	end
	if defeat then
		return -1
	end
	
	-- cancel autoheal
	for i = 1,table.getn(myUnits) do
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
	end
	for i = 1,table.getn(lostUnits) do
		Spring.SetUnitHealth(lostUnits[i].id, lostUnits[i].maxHealth/4)
	end
	
	
	-- victory condition
	local myBitX, myBitY, myBitZ = Spring.GetUnitPosition(myUnits[1].id)
	local myByteX, myByteY, myByteZ = Spring.GetUnitPosition(myUnits[2].id)
	if myBitX > 1300 and myBitX < 1500 and myBitZ > 1271 and myBitZ < 1471
			and myByteX > 379 and myByteX < 579 and myByteZ > 1725 and myByteZ < 1925 then
	  -- reclaim the lost units
		for i = 1,table.getn(lostUnits) do
			Spring.TransferUnit(lostUnits[i].id, 0)
		end
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
	Spring.MarkerErasePosition(479, Spring.GetGroundHeight(479, 1825), 1825)
	Spring.MarkerErasePosition(1400, Spring.GetGroundHeight(1400, 1371), 1371)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
