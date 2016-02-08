-- Defines the Mission 6

local myUnits = {}

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()
		
	-- units initialisation
	for i = 1,11 do
		myUnits[i] = {id = nil, maxHealth = nil, x = nil, y = nil, z = nil}
	end
	
	-- create my unit
	myUnits[1].id = Spring.CreateUnit("bit", 95, Spring.GetGroundHeight(95, 883), 883, "n", 0)
	myUnits[2].id = Spring.CreateUnit("bit", 193, Spring.GetGroundHeight(193, 922), 922, "n", 0)
	myUnits[3].id = Spring.CreateUnit("bit", 228, Spring.GetGroundHeight(228, 1019), 1019, "n", 0)
	myUnits[4].id = Spring.CreateUnit("bit", 368, Spring.GetGroundHeight(368, 894), 894, "n", 0)
	myUnits[5].id = Spring.CreateUnit("bit", 425, Spring.GetGroundHeight(425, 1021), 1021, "n", 0)
	myUnits[6].id = Spring.CreateUnit("bit", 343, Spring.GetGroundHeight(343, 969), 969, "n", 0)
	myUnits[7].id = Spring.CreateUnit("bit", 65, Spring.GetGroundHeight(65, 974), 974, "n", 0)
	myUnits[8].id = Spring.CreateUnit("byte", 282, Spring.GetGroundHeight(282, 1011), 1011, "n", 0)
	myUnits[9].id = Spring.CreateUnit("byte", 349, Spring.GetGroundHeight(349, 1060), 1060, "n", 0)
	myUnits[10].id = Spring.CreateUnit("byte", 170, Spring.GetGroundHeight(170, 1105), 1105, "n", 0)
	myUnits[11].id = Spring.CreateUnit("assembler", 64, Spring.GetGroundHeight(64, 64), 64, "s", 0)
	
	-- damage units and store units maxHealth and initial position (except for assembler) 
	local tmp
	for i = 1,table.getn(myUnits)-1 do
		tmp, myUnits[i].maxHealth = Spring.GetUnitHealth(myUnits[i].id)
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
		myUnits[i].x, myUnits[i].y, myUnits[i].z = Spring.GetUnitPosition(myUnits[i].id)
	end
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{256,811}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
	
	-- Add marker to show rally point
	local msg
	if lang == "fr" then
		msg = "Point de ralliement\nde l'assembleur(256, 811)"
	else
		msg = "Assembler rallying point\n(256, 811)"
	end
	Spring.MarkerAddPoint(256, Spring.GetGroundHeight(256, 811), 811, msg)
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 6\n \n \nL'ASSEMBLEUR (ASSEMBLER) vient d'apparaître sur la carte, aidez le à rejoindre le reste de votre armée.\n \nDéplacez l'ASSEMBLEUR et uniquement lui aux coordonnées (256, 811).\n \n"..gray.."Appuyez sur Echap pour continuer"
	else
		msg = "Mission 6\n \n \nThe ASSEMBLER has just entered on the map, help it to join your army.\n \nMove the ASSEMBLER and just it to (256, 811).\n \n"..gray.."Press Escape to continue"
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function Update (frameNumber)
	-- defeat condition
	for i = 1,table.getn(myUnits)-1 do
		if Spring.ValidUnitID(myUnits[i].id) == false then
			return -1
		end
		local x, y, z = Spring.GetUnitPosition(myUnits[i].id)
		if x ~= myUnits[i].x or y ~= myUnits[i].y or z ~= myUnits[i].z then
			return -1
		end
	end
	
	-- cancel autoheal
	for i = 1,table.getn(myUnits)-1 do
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].maxHealth/4)
	end

	-- victory condition
	local x, y, z = Spring.GetUnitPosition(myUnits[11].id)
	if x > 256-100 and x < 256+100 and z > 811-100 and z < 811+100 then
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
	Spring.MarkerErasePosition(256, Spring.GetGroundHeight(256, 811), 811)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
