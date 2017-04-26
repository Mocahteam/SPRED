-- Defines the Mission 7

local myUnits = {}

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()
		
	-- units initialisation
	for i = 1,11 do
		myUnits[i] = {id = nil, previousHealth = nil, autoHeal = nil, idleAutoHeal}
	end
	
	-- create my units
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
	myUnits[11].id = Spring.CreateUnit("assembler", 256, Spring.GetGroundHeight(256, 811), 811, "s", 0)
	
	-- damage units and store units autoHeal and idleAutoHeal (except for assembler) 
	for i = 1,table.getn(myUnits)-1 do
		myUnits[i].previousHealth = Spring.GetUnitHealth(myUnits[i].id)/4
		Spring.SetUnitHealth(myUnits[i].id, myUnits[i].previousHealth)
		myUnits[i].autoHeal = UnitDefs[Spring.GetUnitDefID(myUnits[i].id)]["autoHeal"]
		myUnits[i].idleAutoHeal = UnitDefs[Spring.GetUnitDefID(myUnits[i].id)]["idleAutoHeal"]
	end
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 7\n \n \nVotre armée est maintenant regroupée et vous disposez du dernier ASSEMBLEUR (ASSEMBLER) du secteur encore en marche.\n \nOrdonnez lui de réparer toute votre armée.\n \n"..gray.."Appuyez sur Echap pour continuer"
	else
		msg = "Mission 7\n \n \nYour army is now grouped together and you control the latest available ASSEMBLER.\n \nUse it to repair your weakened units.\n \n"..gray.."Press Escape to continue"
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function Update (frameNumber)
	
	-- defeat condition
	for i = 1,table.getn(myUnits) do
		if Spring.ValidUnitID(myUnits[i].id) == false then
			return -1
		end
	end
		
	-- cancel autoheal
	for i = 1,table.getn(myUnits)-1 do
		local currentHealth = Spring.GetUnitHealth(myUnits[i].id)
		if currentHealth == myUnits[i].previousHealth+myUnits[i].autoHeal or
				currentHealth == myUnits[i].previousHealth+myUnits[i].idleAutoHeal then
			Spring.SetUnitHealth(myUnits[i].id, myUnits[i].previousHealth)
		else
			myUnits[i].previousHealth = currentHealth
		end
	end
	
	-- cancels FIGHT order of the assembler, otherwise end the mission is too easy
	commands = Spring.GetUnitCommands(myUnits[11].id)
	if commands ~= nil then
		for i = 1,table.getn(commands) do
			if commands[i].id == CMD.FIGHT then
				Spring.GiveOrderToUnit(myUnits[11].id, CMD.STOP, {}, {})
			end
		end
	end

	-- victory condition
	for i = 1,table.getn(myUnits) do
		local health, maxHealth = Spring.GetUnitHealth(myUnits[i].id)
		if health < maxHealth then
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
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
