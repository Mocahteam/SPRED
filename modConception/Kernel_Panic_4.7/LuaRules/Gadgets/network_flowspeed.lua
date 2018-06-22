function gadget:GetInfo()
	return {
		name = "Flow Speed",
		desc = "changes flow speed depending on how many ports (or any small building) you have",
		author = "KDR_11k (David Becker)",
		date = "2008-05-10",
		license = "Public Domain",
		layer = 27,
		enabled = true
	}
end

local bonusPerFac=30
local baseSpeed = UnitDefNames.flow.speed

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

local flow = UnitDefNames.flow.id
local MAX_SPEED=75

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local count={}

local Spring_SetUnitCOBValue = Spring.SetUnitCOBValue or Spring.UnitScript.SetUnitCOBValue

local function UpdateFlowSpeed(team)
	for _,u in ipairs (Spring.GetTeamUnitsByDefs(team,flow)) do
		Spring_SetUnitCOBValue(u,MAX_SPEED, 65536*( baseSpeed + count[team]*bonusPerFac)/30)
	end
end

function gadget:GameFrame(f)
	if f%27==11 then
		for _,t in ipairs(Spring.GetTeamList()) do
			UpdateFlowSpeed(t)
		end
	end
end

function gadget:Initialize()
	for _,t in ipairs(Spring.GetTeamList()) do
		count[t]=0
	end
end

function gadget:UnitFinished(u,ud,team)
	if isSmallBuilding[ud] then
		count[team] = count[team] + 1
		UpdateFlowSpeed(team)
	end
	if ud == flow then
		Spring_SetUnitCOBValue(u,MAX_SPEED, 65536*( baseSpeed + count[team]*bonusPerFac)/30)
	end
end

function gadget:UnitDestroyed(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] - 1
		UpdateFlowSpeed(team)
	end
end

function gadget:UnitTaken(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] - 1
		UpdateFlowSpeed(team)
	end
end

function gadget:UnitGiven(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] + 1
		UpdateFlowSpeed(team)
	elseif ud==flow then
		UpdateFlowSpeed(team)
	end
end

else

--UNSYNCED

return false

end
