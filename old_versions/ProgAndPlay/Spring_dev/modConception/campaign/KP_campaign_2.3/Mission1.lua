-- Defines the Mission 1

local unitID, maxHealth, tmp

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()
	
	-- create my unit for this mission
	unitID = Spring.CreateUnit("bit", 1792, Spring.GetGroundHeight(1792, 1792), 1792, "n", 0)
	
	-- store unit maxHealth
	tmp, maxHealth = Spring.GetUnitHealth(unitID)
	
	-- damage unit
	Spring.SetUnitHealth(unitID, maxHealth/4)
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
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
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 1\n \n \nVous allez devoir constituer et commander un groupe d'intervention spéciale pour mener une attaque éclair sur un poste de commandement peu défendu. Si vous atteignez cet objectif final, nos ennemis s'en trouveront désorientés et nous exploiterons cet avantage pour mettre un terme à la \"guerre numérique\".\n \nUn rapport vous est parvenu vous indiquant qu'un BYTE (OCTET) se trouverait au point de ralliement (1983, 1279). Déplacez votre unique entité à cette position pour tenter de rallier à notre cause le BYTE solitaire. Bon courage...\n \n"..gray.."Appuyez sur Echap pour continuer"
	else
		msg = "Mission 1\n \n \nYou have to form and command a rapid deployment force in order to lightning strike an ennemy headquarters weakly defended. If you reach this final objective, ennemies will be desoriented and we will use this advantage to end this \"digital war\".\n \nYou received a report that indicates that a BYTE would be at the rallying point (1983, 1279). Move your single unit to this position for trying to rallying the solitary BYTE to our cause. Good luck...\n \n"..gray.."Press Escape to continue"
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function Update (frameNumber)
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
