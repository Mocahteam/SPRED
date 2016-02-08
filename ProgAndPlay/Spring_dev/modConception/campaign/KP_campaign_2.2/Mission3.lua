-- Defines the Mission 3

local myUnit
local allyUnit
local enemyUnitsId

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

local function Start ()
		
	-- units initialisation
	myUnit = {id = nil, previousHealth = nil}
	allyUnit = {
		id = nil,
		attacked = false,
		previousHealth = nil,
		previousPos = {
			x = nil,
			z = nil
		},
		markerPos = {
			available = nil,
			x = nil,
			z = nil
		}
	}
	
	-- create my unit
	myUnit.id = Spring.CreateUnit("bit", 1056, Spring.GetGroundHeight(1056, 1900), 1900, "n", 0)
	-- set FireState to "Hold fire" == 0
	Spring.GiveOrderToUnit(myUnit.id, CMD.FIRE_STATE, {0}, {})
	-- store health
	local tmp, maxHealth = Spring.GetUnitHealth(myUnit.id)
	myUnit.previousHealth = maxHealth
	
	-- create ally unit
	local allyX, allyZ = 1056, 1792
	allyUnit.id = Spring.CreateUnit("byte", allyX, Spring.GetGroundHeight(allyX, allyZ), allyZ, "w", 1)
	-- set FireState to "Hold fire" == 0
	Spring.GiveOrderToUnit(allyUnit.id, CMD.FIRE_STATE, {0}, {})
	-- damage units
	tmp, maxHealth = Spring.GetUnitHealth(allyUnit.id)
	allyUnit.previousHealth = maxHealth/4
	Spring.SetUnitHealth(allyUnit.id, allyUnit.previousHealth)
	-- set special data
	allyUnit.previousPos.x = allyX
	allyUnit.previousPos.z = allyZ
	allyUnit.markerPos = {false, nil, nil}
	
	-- create enemy units
--	local myX, _, myZ = Spring.GetUnitPosition(allyUnit.id)
	local enemyX, enemyZ, dist
	-- found a position 730*900 - 1300*1200 / 1600*1200 - 2000*1500 / 10*1200 - 400*1500
	repeat
		enemyX = math.random(Game.mapSizeX)
		enemyZ = math.random(Game.mapSizeZ)
--		dist = math.sqrt((enemyX-myX)*(enemyX-myX) + (enemyZ-myZ)*(enemyZ-myZ))
--	until dist > 700 and dist < 1300
	until (730 < enemyX and enemyX < 1300 and 900 < enemyZ and enemyZ < 1200) or
		(1600 < enemyX and enemyX < 2000 and 1200 < enemyZ and enemyZ < 1500) or
		(10 < enemyX and enemyX < 400 and 1200 < enemyZ and enemyZ < 1500)
	enemyUnitsId = Spring.CreateUnit("bit", enemyX, Spring.GetGroundHeight(enemyX, enemyZ), enemyZ, "s", 2)
	-- set FireState to "Hold fire" == 0
	Spring.GiveOrderToUnit(enemyUnitsId, CMD.FIRE_STATE, {0}, {})
	-- command this unit to attack the byte
	Spring.GiveOrderToUnit(enemyUnitsId, CMD.ATTACK, {allyUnit.id}, {})
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- enable camera auto (specify special positions (as x and z coordinates)  you want in view)
	_G.cameraAuto = {
		enable = true,
		specialPositions = {{776, 1824}, {1272, 1600}}
	}
	SendToUnsynced("enableCameraAuto")
	_G.cameraAuto = nil
end

local function ShowBriefing ()
	local msg
	if lang == "fr" then
		msg = "Mission 3\n \n \nATTENTION !!! Cet OCTET (BYTE) tentait de semer un éclaireur ennemi qui ne doit pas être loin. Protégez le avant qu'il ne soit trop tard.\n \n"..gray.."Appuyez sur Echap pour continuer"
	else
		msg = "Mission 3\n \n \nWARNING !!! This BYTE attempted to escape an enemy scout that is not far. Protect this BYTE before it's too late.\n \n"..gray.."Press Escape to continue"
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function helpMessage()
	local mess
	if lang == "fr" then
		mess = {"Aidez moi !!!", "S'il vous plait...", "AAaarghh", "J'ai besoin d'aide", "Que faites vous ?", "Je ne tiendrai\npas longtemps", "Mon energie diminue", "Il m'en met\nplein la gueule", "Noooonnn"}
	else
		mess = {"Help me !!!", "Please...", "AAaarghh", "I need help", "What do you do?", "I won't resist\na long time", "My energy weakens", "He beats me up", "Noooooo"}
	end
	return mess[math.random(#mess)]
end

local function Update (frameNumber)
	-- defeat condition	
	if not (Spring.ValidUnitID(myUnit.id) and Spring.ValidUnitID(allyUnit.id)) then
		-- set enemy FireState to "Fire at will" == 2
		Spring.GiveOrderToUnit(enemyUnitsId, CMD.FIRE_STATE, {2}, {})
		return -1
	end
	
	-- cancel autoheal
	local health = Spring.GetUnitHealth(myUnit.id)
	if health > myUnit.previousHealth then
		Spring.SetUnitHealth(myUnit.id, myUnit.previousHealth)
	end
	health = Spring.GetUnitHealth(allyUnit.id)
	if health < allyUnit.previousHealth and not allyUnit.attacked then
		allyUnit.attacked = true
	end
	if health > allyUnit.previousHealth then
		Spring.SetUnitHealth(allyUnit.id, allyUnit.previousHealth)
	end
	-- move ally randomly
	if allyUnit.attacked then
		local x, y, z = Spring.GetUnitPosition(allyUnit.id)
		-- update markers
		if x ~= allyUnit.previousPos.x or z ~=allyUnit.previousPos.z then
			-- this unit moves. Check if we must delete markers
			if allyUnit.markerPos.available and (math.abs(x-allyUnit.markerPos.x) > 10 or math.abs(z-allyUnit.markerPos.z) > 10) then
				-- delete markers
				local x = allyUnit.markerPos.x
				local z = allyUnit.markerPos.z
				Spring.MarkerErasePosition(x, Spring.GetGroundHeight(x, z), z)
				allyUnit.markerPos.available = false
				allyUnit.markerPos.x = nil
				allyUnit.markerPos.z = nil
			end
		else
			-- this unit is stopped. Check if we must create markers
			if not allyUnit.markerPos.available then
				allyUnit.markerPos.available = true
				allyUnit.markerPos.x = x
				allyUnit.markerPos.z = z
				-- Add mark
				Spring.MarkerAddPoint(x, Spring.GetGroundHeight(x, z), z, helpMessage())
				local targetX
				local targetZ
				local ennX, _, ennZ = Spring.GetUnitPosition(enemyUnitsId)
				local dist
				-- compute new target not too closer to the ally and the ennemy
				repeat
					targetX = math.random(576, 1472)
					targetZ = math.random(1600, 1824)
					dist = math.sqrt((targetX-x)*(targetX-x) + (targetZ-z)*(targetZ-z))
					dist = math.min(dist, math.sqrt((ennX-x)*(ennX-x) + (ennZ-z)*(ennZ-z)))
				until dist > 60
				Spring.GiveOrderToUnit(allyUnit.id, CMD.MOVE, {targetX, Spring.GetGroundHeight(targetX, targetZ), targetZ}, {})
			end
		end
		-- update previous unit position
		allyUnit.previousPos.x = x
		allyUnit.previousPos.z = z
	end
	
	-- victory condition
	if Spring.ValidUnitID(enemyUnitsId) == false then
		Spring.GiveOrderToUnit(allyUnit.id, CMD.STOP, {}, {})
		if allyUnit.markerPos.available then
			local x = allyUnit.markerPos.x
			local z = allyUnit.markerPos.z
			Spring.MarkerErasePosition(x, Spring.GetGroundHeight(x, z), z)
		end
		Spring.TransferUnit(allyUnit.id, 0)
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
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
