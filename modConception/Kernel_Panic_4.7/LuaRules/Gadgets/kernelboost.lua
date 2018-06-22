function gadget:GetInfo()
	return {
		name = "Kernel boost",
		desc = "boosts the Kernel's production rate with territory",
		author = "KDR_11k (David Becker)",
		date = "2008-04-29",
		license = "Public Domain",
		layer = 21,
		enabled = true
	}
end

local bonusPerFac=.2

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

local count={}

function gadget:AllowUnitBuildStep(builder, team, u, ud, amount)
	local bud = Spring.GetUnitDefID(builder)
	if isHomeBase[bud] then
		Spring.SetUnitBuildSpeed(builder, UnitDefs[bud].buildSpeed * (1 + count[team] * bonusPerFac))
		--Spring.Echo("toot")
		--local _,_,_,_,b = Spring.GetUnitHealth(u)
		--b = b + amount * count[team] * bonusPerFac
		--Spring.SetUnitHealth(u, {build=b})
	end
	return true
end

function gadget:Initialize()
	for _,t in ipairs(Spring.GetTeamList()) do
		count[t]=0
	end
end

function gadget:UnitFinished(u,ud,team)
	if isSmallBuilding[ud] then
		count[team] = count[team] + 1
	end
end

function gadget:UnitDestroyed(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] - 1
	end
end

function gadget:UnitTaken(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] - 1
	end
end

function gadget:UnitGiven(u,ud,team)
	local _,_,b = Spring.GetUnitIsStunned(u)
	if isSmallBuilding[ud] and not b then
		count[team] = count[team] + 1
	end
end

else

--UNSYNCED

return false

end
