-- Defines the Mission 1

local unitID, maxHealth, tmp

local lang = Spring.GetModOptions()["language"] -- get the language

local function Start ()
	
	-- create my unit for this mission
	unitID = Spring.CreateUnit("bit", 1792, Spring.GetGroundHeight(1792, 1792), 1792, "n", 0)
	
	-- store unit maxHealth
	tmp, maxHealth = Spring.GetUnitHealth(unitID)
	
	-- damage unit
	Spring.SetUnitHealth(unitID, maxHealth/4)
	
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
		specialPositions = {{1983,1279}}
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
	Spring.MarkerAddPoint(1983, Spring.GetGroundHeight(1983, 1279), 1279, msg.."\n(1983, 1279)")
	
	-- -- point camera to my unit
	-- local x, y, z = Spring.GetUnitPosition(unitID)
	-- Spring.SetCameraTarget(x, y, z, 1)
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 1\n \n \nDepuis un certain nombre d'années, une guerre secrète fait rage au sein même des ordinateurs. Des attaques ont régulièrement lieu contre d'innocentes victimes. Aujourd'hui c'est votre tour. Votre agresseur a capturé le contrôleur de votre souris. Vous devez le récupérer. Votre seule solution : la programmation.\n \nLors de la précédente attaque, vous avez perdu de nombreuses entités et celles qui vous restent sont dispersées sur la carte. Un seul BIT est encore sous votre contrôle.\n \nUn rapport vous est parvenu vous indiquant qu'un BYTE (OCTET) se trouverait au point de ralliement (1983, 1279). Déplacez votre unique entité à cette position pour tenter de retrouver le BYTE perdu. Bon courage commandant..."
	else
		msg = "Mission 1\n \n \nFor a certain number of years, a secret war has been rife inside computers. Steady attacks have been led against innocent victims. Today is your turn. Your aggressor captured your mouse controller. You must recover it. Your only solution: programming.\n \nYou lost a lot of units in the last attack. Units currently alive are dispersed on the map. You have only one BIT under control.\n \nYou received a report that indicates that a BYTE would be at the rallying point (1983, 1279). Move your single unit to this position for trying to find the BYTE. Good luck..."
	end
	Script.LuaRules.showMessage(msg, true, 500)
end

local function Update (frameNumber)
	-- if frameNumber == 20 then
		-- -- Add marker to show target position
		-- local msg
		-- if lang == "fr" then
			-- msg = "Point de ralliement"
		-- else
			-- msg = "Rallying point"
		-- end
		-- Spring.MarkerAddPoint(1983, Spring.GetGroundHeight(1983, 1279), 1279, msg.."\n(1983, 1279)")
		-- Spring.SetCameraTarget(1983, Spring.GetGroundHeight(1983, 1279), 1279, 2)
	-- end
	-- if frameNumber == 80 then
		-- -- point camera to my unit
		-- local x, y, z = Spring.GetUnitPosition(unitID)
		-- Spring.SetCameraTarget(x, y, z, 2)
	-- end
	
	-- defeat condition	
	if Spring.ValidUnitID(unitID) == false then
		return -1
	end
	
	-- cancel autoheal
	Spring.SetUnitHealth(unitID, maxHealth/4)
	
	-- victory condition
	local x, y, z = Spring.GetUnitPosition(unitID)
	if x > 1983-100 and x < 1983+100 and z > 1279-100 and z < 1279+100 then
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
	Spring.MarkerErasePosition(1983, Spring.GetGroundHeight(1983, 1279), 1279)
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
