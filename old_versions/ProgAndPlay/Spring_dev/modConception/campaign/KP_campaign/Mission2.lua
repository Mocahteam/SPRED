-- Defines the Mission 2

local lang = Spring.GetModOptions()["language"] -- get the language

local units = {
	myUnit = {
		id = nil,
		maxHealth = nil,
		previousPos = {
			x = nil,
			z = nil
		},
		markerPos = {
			available = nil,
			x = nil,
			z = nil
		}
	},
	unitLost = {
		id = nil,
		maxHealth = nil
	}
}

local startPos = {
	x = 1983,
	z = 1279
}

local function Start ()
	-- erase markers teams start position if they exist
	teams = Spring.GetTeamList()
	for i = 1, table.getn(teams) do
		local x, y, z = Spring.GetTeamStartPosition(teams[i])
		Spring.MarkerErasePosition(x, y, z)
	end
	
	-- create my unit
	units.myUnit.id = Spring.CreateUnit("bit", startPos.x, Spring.GetGroundHeight(startPos.x, startPos.z), startPos.z, "s", 0)
	units.myUnit.previousPos = {startPos.x, startPos.z}
	units.myUnit.markerPos = {false, nil, nil}
	-- create unit lost
	units.unitLost.id = Spring.CreateUnit("byte", 1056, Spring.GetGroundHeight(1056, 1792), 1792, "s", 1)
	
	-- store units maxHealth
	local tmp
	tmp, units.myUnit.maxHealth = Spring.GetUnitHealth(units.myUnit.id)
	tmp, units.unitLost.maxHealth = Spring.GetUnitHealth(units.unitLost.id)
	
	-- damage units
	Spring.SetUnitHealth(units.myUnit.id, units.myUnit.maxHealth/4)
	Spring.SetUnitHealth(units.unitLost.id, units.unitLost.maxHealth/4)
	
	-- disable mouse
	SendToUnsynced("mouseDisabled", true)
	
	-- point camera to my unit
	local x, y, z = Spring.GetUnitPosition(units.myUnit.id)
	Spring.SetCameraTarget(x, y, z, 1)
end

local function ShowBriefing ()
	local msg
	local x, y, z = Spring.GetUnitPosition(units.myUnit.id)
	local x2, y2, z2 = Spring.GetUnitPosition(units.unitLost.id)
	-- Compute angle and distance
	local dist = math.ceil(math.sqrt((x-x2)*(x-x2)+(z-z2)*(z-z2)))
	local angl
	if dist ~= 0 then
		angl = math.ceil(math.deg(math.acos((z-z2)/dist)))
	end
	if x < x2 then
		angl = -angl
	end
	if x == startPos.x and z == startPos.z then
		if lang == "fr" then
			msg = "Mission 2\n \n \nLe rapport que vous aviez reçu était correct mais le BYTE (OCTET) ne se trouve plus au point de ralliement prévu. Des traces vous indiquent qu'il s'est éloigné dans la direction "..angl.."° par rapport au Nord (sens anti-horaire). La fraîcheur des indices vous indique qu'il n'est pas loin.\n \nDéplacez votre BIT de "..dist.." unités dans cette direction."
		else
			msg = "Mission 2\n \n \nThe report you received was true, but the BYTE was moving. Some tracks indicate it moves towards "..angl.."° from North (counter-clockwise) and it is not far.\n \nMove your BIT to "..dist.." distance units in this direction."
		end
	else
		if not units.myUnit.markerPos.available then
			-- unit moves
			if lang == "fr" then
				msg = "Mission 2\n \nInformations indisponibles...\n \nReconsultez le briefing lorsque votre BIT sera à l'arrêt."
			else
				msg = "Mission 2\n \nUnavailable informations...\n \nConsult briefing again when your BIT will be stopped."
			end
		else
			-- unit is stopped
			if lang == "fr" then
				msg = "Mission 2 \n \n \nVotre BIT c'est déplacé et n'a pas encore retrouvé le BYTE (OCTET). D'après sa nouvelle position et son estimation, le BYTE se trouve à une distance de "..dist.." unités dans la direction "..angl.."° par rapport au Nord (sens anti-horaire).\n \nDéplacez votre BIT vers la position indiquée."
			else
				msg = "Mission 2 \n \n \nYour BIT moved and has not found the BYTE. Depending on its position and its valuation, the BYTE is in "..dist.." distance units towards "..angl.."° from North (counter-clockwise).\n \nMove your BIT to indicated position."
			end
		end
	end
	Script.LuaRules.showMessage(msg, true, 500)
end

local function Update (frameNumber)
	
	-- defeat condition	
	if Spring.ValidUnitID(units.myUnit.id) == false or Spring.ValidUnitID(units.unitLost.id) == false  then
		return -1
	end

	local x, y, z = Spring.GetUnitPosition(units.myUnit.id)
	-- update markers
	if x ~= units.myUnit.previousPos.x or z ~= units.myUnit.previousPos.z then
		-- this unit moves. Check if we must delete markers
		if units.myUnit.markerPos.available then
			-- delete markers
			local x = units.myUnit.markerPos.x
			local z = units.myUnit.markerPos.z
			Spring.MarkerErasePosition(x, Spring.GetGroundHeight(x, z), z)
			units.myUnit.markerPos.available = false
			units.myUnit.markerPos.x = nil
			units.myUnit.markerPos.z = nil
		end
	else
		-- this unit is stopped. Check if we must create markers
		if not units.myUnit.markerPos.available then
			units.myUnit.markerPos.available = true
			units.myUnit.markerPos.x = x
			units.myUnit.markerPos.z = z
			-- Compute angle and distance
			local x2, y2, z2 = Spring.GetUnitPosition(units.unitLost.id)
			local dist = math.ceil(math.sqrt((x-x2)*(x-x2)+(z-z2)*(z-z2)))
			local angl = 0
			if dist ~= 0 then
				angl = math.ceil(math.deg(math.acos((z-z2)/dist)))
			end
			if x < x2 then
				angl = -angl
			end
			-- Add marker to print distance and orientation
			local msg
			if lang == "fr" then
				msg = "Distance : "..dist.." unités.\nOrientation :"..angl.."°."
			else
				msg = "Distance : "..dist.." units.\nDirection :"..angl.."°."
			end
			Spring.MarkerAddPoint(x, y, z, msg)
			-- Add line to show orientation
			Spring.MarkerAddLine(x, y, z, x-(x-x2)/dist*75, y-(y-y2)/dist*75, z-(z-z2)/dist*75)
		end
	end
	-- update previous unit position
	units.myUnit.previousPos.x = x
	units.myUnit.previousPos.z = z

	-- cancel autoheal
	Spring.SetUnitHealth(units.myUnit.id, units.myUnit.maxHealth/4)
	Spring.SetUnitHealth(units.unitLost.id, units.unitLost.maxHealth/4)
	
	-- victory condition
	local myX, myY, myZ = Spring.GetUnitPosition(units.myUnit.id)
	local lostX, lostY, lostZ = Spring.GetUnitPosition(units.unitLost.id)
	if myX > lostX-100 and myX < lostX+100 and myZ > lostZ-100 and myZ < lostZ+100 then
    -- reclaim the unit lost
		Spring.TransferUnit(units.unitLost.id, 0)
		return 1
	end

	return 0
end

local function Stop ()
	-- delete all units created
	local allUnits = Spring.GetAllUnits() 
	for i = 1,table.getn(allUnits) do
		Spring.DestroyUnit(allUnits[i], false, true)
	end
	-- delete markers
	local x = units.myUnit.markerPos.x
	local z = units.myUnit.markerPos.z
	if x ~= nil and z ~= nil then
		Spring.MarkerErasePosition(x, Spring.GetGroundHeight(x, z), z)
	end
end

local Mission = {}

Mission.Start = Start
Mission.ShowBriefing = ShowBriefing
Mission.Update = Update
Mission.Stop = Stop

return Mission
