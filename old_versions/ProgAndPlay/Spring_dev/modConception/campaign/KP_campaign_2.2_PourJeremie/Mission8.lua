-- Defines the Mission 8

local myUnitsId = {}
local enemyUnitsId = {}
local mouseControllerId = {}

local lang = Spring.GetModOptions()["language"] -- get the language
local debriefing = false
local frameNumDebrief = nil
local gray = "\255\100\100\100"

local function Start ()
		
	-- create my units
	myUnitsId[1] = Spring.CreateUnit("bit", 95, Spring.GetGroundHeight(95, 883), 883, "n", 0)
	myUnitsId[2] = Spring.CreateUnit("bit", 193, Spring.GetGroundHeight(193, 922), 922, "n", 0)
	myUnitsId[3] = Spring.CreateUnit("bit", 228, Spring.GetGroundHeight(228, 1019), 1019, "n", 0)
	myUnitsId[4] = Spring.CreateUnit("bit", 368, Spring.GetGroundHeight(368, 894), 894, "n", 0)
	myUnitsId[5] = Spring.CreateUnit("bit", 425, Spring.GetGroundHeight(425, 1021), 1021, "n", 0)
	myUnitsId[6] = Spring.CreateUnit("bit", 343, Spring.GetGroundHeight(343, 969), 969, "n", 0)
	myUnitsId[7] = Spring.CreateUnit("bit", 65, Spring.GetGroundHeight(65, 974), 974, "n", 0)
	myUnitsId[8] = Spring.CreateUnit("byte", 282, Spring.GetGroundHeight(282, 1011), 1011, "n", 0)
	myUnitsId[9] = Spring.CreateUnit("byte", 349, Spring.GetGroundHeight(349, 1060), 1060, "n", 0)
	myUnitsId[10] = Spring.CreateUnit("byte", 170, Spring.GetGroundHeight(170, 1105), 1105, "n", 0)
	myUnitsId[11] = Spring.CreateUnit("assembler", 256, Spring.GetGroundHeight(256, 811), 811, "n", 0)
	
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
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{1792, 256}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
end

local function ShowBriefing ()
	local msg
	local pause
	if not debriefing then
		if lang == "fr" then
			msg = "Mission 8\n \n \nVotre groupe d'intervention spéciale est fin prêt à retourner au combat. Le poste de commandement ennemi est proche de votre position. Lancez l'attaque sur la position (1792, 256).\n \nN'oubliez pas que l'ASSEMBLEUR (ASSEMBLER) peut vous être d'une aide précieuse...\n \nBonne chance.\n \n"..gray.."Appuyez sur Echap pour continuer"
		else
			msg = "Mission 8\n \n \nAll units are repaired. Now it is time to fight back. The ennemy headquarters is near from your position. Launch your assault on position (1792, 256).\n \nDon't forget that the ASSEMBLER can provide a precious help...\n \nGood luck.\n \n"..gray.."Press Escape to continue"
		end
		pause = false
	else
		if lang == "fr" then
			msg = "Grace à votre groupe d'intervention et à vos compétences de programmeur, vous avez pu remporter une grande victoire. \n \nCe poste de commandement va nous apporter un avantage certain pour la suite du conflit. De nombreux systèmes vont pouvoir être reprogrammés.\n \nEn attendant vos compétences peuvent nous être à nouveau utiles, travaillez et tenez vous prêt...\n \n"..gray.."Appuyez sur Echap pour continuer"
		else
			msg = "Thanks to your rapid deployment force and your programming skills, you won a great victory.\n \nThis headquarters will give us advantages for next conflicts. Several systems could be implemented again.\n \nTill then, your skills are interresting for us, continue to study and get ready...\n \n"..gray.."Press Escape to continue"
		end
		pause = true
	end
	Script.LuaRules.showMessage(msg, pause, 500)
end

local function Update (frameNumber)
	if frameNumber == 40 then
		-- Add marker to show mouse controller position
		local msg
		if lang == "fr" then
			msg = "Position du poste\nde commandement (1792, 256)"
		else
			msg = "Headquarters position\n(1792, 256)"
		end
		Spring.MarkerAddPoint(1792, Spring.GetGroundHeight(1792, 256), 256, msg)
	end
	
	-- defeat condition
	if Spring.GetTeamUnitCount(0) == 0 or Spring.GetTeamUnitCount(1) == 0 then
		return -1
	end

	-- victory condition
	if Spring.GetTeamUnitCount(2) == 0 then
		if frameNumDebrief ==  nil then
			-- delete marker
			Spring.MarkerErasePosition(1792, Spring.GetGroundHeight(1792, 256), 256)
			-- show debriefing
			debriefing = true
			ShowBriefing ()
			frameNumDebrief = frameNumber
		else
			if frameNumber > frameNumDebrief+10 then
				Spring.TransferUnit(mouseControllerId[0], 0)
		 		Spring.TransferUnit(mouseControllerId[1], 0)
				return 1
			end
		end
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
	Spring.MarkerErasePosition(1792, Spring.GetGroundHeight(1792, 256), 256)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
