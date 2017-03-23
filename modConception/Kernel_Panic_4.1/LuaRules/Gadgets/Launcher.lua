function gadget:GetInfo()
	return {
		name = "Launcher",
		desc = "Implements the launcher",
		author = "KDR_11k (David Becker)",
		date = "2007-11-18",
		license = "Public Domain",
		layer = 23,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local maxThisUnit = UnitDefNames.logic_bomb.maxThisUnit
local launchedTurret = UnitDefNames.logic_bomb.id
local tlWeapon = WeaponDefNames.minelauncher.id
local createList = {}

function gadget:Initialize()
	Script.SetWatchWeapon(tlWeapon, true)
end

function gadget:Explosion(w, x, y, z, owner)
	if w == tlWeapon and owner then
		table.insert(createList, {owner = owner, x=x,y=y,z=z})
		return true
	end
	return false
end

function gadget:GameFrame(f)
	for i,c in pairs(createList) do
		if (#Spring.GetTeamUnitsByDefs(Spring.GetUnitTeam(c.owner),launchedTurret)<maxThisUnit) then
			Spring.CreateUnit("logic_bomb", c.x, c.y, c.z, 0, Spring.GetUnitTeam(c.owner))
		end
	end
	createList = {}
end

end
