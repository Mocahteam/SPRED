-- Defines the Mission 2

local lang = Spring.GetModOptions()["language"] -- get the language
local gray = "\255\100\100\100"

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
	local x, y, z = Spring.GetUnitPosition(units.myUnit.id)
	local x2, y2, z2 = Spring.GetUnitPosition(units.unitLost.id)
	-- Compute distance
	local dX = x2 - x
	local dY = z2 - z
	local dirX, dirY
	if dX < 0 then
		if lang == "fr" then
			dirX = "l'Ouest"
		else
			dirX = "West"
		end
	else
		if lang == "fr" then
			dirX = "l'Est"
		else
			dirX = "East"
		end
	end
	if dY < 0 then
		if lang == "fr" then
			dirX = "le Nord"
		else
			dirX = "North"
		end
	else
		if lang == "fr" then
			dirY = "le Sud"
		else
			dirY = "South"
		end
	end
	local dX = math.ceil(math.abs(dX))
	local dY = math.ceil(math.abs(dY))
	if x == startPos.x and z == startPos.z then
		if lang == "fr" then
			msg = "Mission 2\n \n \nLe rapport que vous aviez reçu était correct mais l'OCTET (BYTE) ne se trouve plus au point de ralliement prévu. Des traces vous indiquent qu'il s'est éloigné de "..dX.." unités vers "..dirX.." et "..dY.." unités vers "..dirY..".\n \nDéplacez votre BIT dans ces directions pour rattraper ce BYTE.\n \n"..gray.."Appuyez sur Echap pour continuer"
		else
			msg = "Mission 2\n \n \nThe report you received was true, but the BYTE was moving. Some tracks indicate it moves towards "..dX.." units from "..dirX.." and "..dY.." units from "..dirY..".\n \nMove your BIT in this direction in order to catch up with this BYTE.\n \n"..gray.."Press Escape to continue"
		end
	else
		if not units.myUnit.markerPos.available then
			-- unit moves
			if lang == "fr" then
				msg = "Mission 2\n \nInformations indisponibles...\n \nReconsultez le briefing lorsque votre BIT sera à l'arrêt.\n \n"..gray.."Appuyez sur Echap pour continuer"
			else
				msg = "Mission 2\n \nUnavailable informations...\n \nConsult briefing again when your BIT will be stopped.\n \n"..gray.."Press Escape to continue"
			end
		else
			-- unit is stopped
			if lang == "fr" then
				msg = "Mission 2 \n \n \nVotre BIT c'est déplacé et n'a pas encore retrouvé le BYTE (OCTET). D'après sa nouvelle position et son estimation, le BYTE se trouve à une distance de "..dX.." unités vers "..dirX.." et "..dY.." unités vers "..dirY..".\n \nDéplacez votre BIT dans cette direction.\n \n"..gray.."Appuyez sur Echap pour continuer"
			else
				msg = "Mission 2 \n \n \nYour BIT moved and has not found the BYTE. Depending on its position and its valuation, the BYTE is in "..dX.." units from "..dirX.." and "..dY.." units from "..dirY..".\n \nMove your BIT in this direction.\n \n"..gray.."Press Escape to continue"
			end
		end
	end
	Script.LuaRules.showMessage(msg, false, 500)
end

local function writeLetter(x, y, z, letter)
	if letter == "O" then
		-- write letter
		Spring.MarkerAddLine(x-5, y, z-8, x+5, y, z-8)
		Spring.MarkerAddLine(x+5, y, z-8, x+5, y, z+8)
		Spring.MarkerAddLine(x+5, y, z+8, x-5, y, z+8)
		Spring.MarkerAddLine(x-5, y, z+8, x-5, y, z-8)
	elseif letter == "W" then
		-- write letter
		Spring.MarkerAddLine(x-5, y, z-8, x-2.5, y, z+8)
		Spring.MarkerAddLine(x-2.5, y, z+8, x, y, z)
		Spring.MarkerAddLine(x, y, z, x+2.5, y, z+8)
		Spring.MarkerAddLine(x+2.5, y, z+8, x+5, y, z-8)
	elseif letter == "N" then
		-- write letter
		Spring.MarkerAddLine(x-5, y, z+8, x-5, y, z-8)
		Spring.MarkerAddLine(x-5, y, z-8, x+5, y, z+8)
		Spring.MarkerAddLine(x+5, y, z+8, x+5, y, z-8)
	elseif letter == "S" then
		-- write letter
		Spring.MarkerAddLine(x+5, y, z-8, x-5, y, z-8)
		Spring.MarkerAddLine(x-5, y, z-8, x-5, y, z)
		Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
		Spring.MarkerAddLine(x+5, y, z, x+5, y, z+8)
		Spring.MarkerAddLine(x+5, y, z+8, x-5, y, z+8)
	elseif letter == "E" then
		-- write letter
		Spring.MarkerAddLine(x+5, y, z-8, x-5, y, z-8)
		Spring.MarkerAddLine(x-5, y, z-8, x-5, y, z+8)
		Spring.MarkerAddLine(x-5, y, z+8, x+5, y, z+8)
		Spring.MarkerAddLine(x-5, y, z, x, y, z)
	end
end

local function writeSign(x, y, z, sign)
	if sign == "+" then
		Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
		Spring.MarkerAddLine(x, y, z-5, x, y, z+5)
	elseif sign == "-" then
		Spring.MarkerAddLine(x-5, y, z, x+5, y, z)
	end
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
			-- Add marks around unit
			-- left arrow
			Spring.MarkerAddLine(x-65, y, z, x-25, y, z)
			Spring.MarkerAddLine(x-65, y, z, x-55, y, z+10)
			Spring.MarkerAddLine(x-65, y, z, x-55, y, z-10)
			-- right arrow
			Spring.MarkerAddLine(x+65, y, z, x+25, y, z)
			Spring.MarkerAddLine(x+65, y, z, x+55, y, z+10)
			Spring.MarkerAddLine(x+65, y, z, x+55, y, z-10)
			-- top arrow
			Spring.MarkerAddLine(x, y, z-65, x, y, z-25)
			Spring.MarkerAddLine(x, y, z-65, x+10, y, z-55)
			Spring.MarkerAddLine(x, y, z-65, x-10, y, z-55)
			-- down arrow
			Spring.MarkerAddLine(x, y, z+65, x, y, z+25)
			Spring.MarkerAddLine(x, y, z+65, x+10, y, z+55)
			Spring.MarkerAddLine(x, y, z+65, x-10, y, z+55)
			-- write letters
			if lang == "fr" then
				writeLetter(x-60, y, z-25, "O")
			else
				writeLetter(x-60, y, z-25, "W")
			end
			writeLetter(x+60, y, z-25, "E")
			writeLetter(x-25, y, z-60, "N")
			writeLetter(x-25, y, z+60, "S")
			-- write signs
			writeSign(x-48, y, z+18, "-")
			writeSign(x+48, y, z+18, "+")
			writeSign(x+18, y, z-48, "-")
			writeSign(x+18, y, z+48, "+")
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
