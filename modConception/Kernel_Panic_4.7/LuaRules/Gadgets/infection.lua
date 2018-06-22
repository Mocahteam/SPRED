function gadget:GetInfo()
	return {
		name = "Infection",
		desc = "Makes certain weapons spawn zombies",
		author = "KDR_11k (David Becker)",
		date = "2007-08-26",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local zombie="virus"
local zombieID=UnitDefNames[zombie].id
local infectedList={}
local infectionzones={}
local infector={}
local spawnList={}
local frame

function gadget:Initialize()
	infector[WeaponDefNames["virusbeam"].id] = 90
	infector[WeaponDefNames["virusdeath"].id] = 180
--	infector[WeaponDefNames["bugshot"].id] = 40
	infector[WeaponDefNames["wormsplash"].id] = 200
	infector[WeaponDefNames["infection"].id] = 30
end

function gadget:GameFrame(f)
	frame=f
	for i,u in pairs(spawnList) do
		Spring.CreateUnit(zombie,u.x, u.y, u.z, u.f, u.team)
		spawnList[i]=nil
	end
	for i,u in pairs(infectedList) do
		if u.expiry <= frame then
			infectedList[i] = nil
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if(unitDefID ~= zombieID) then
		if (infectedList[unitID] and infectedList[unitID].expiry > frame) then
			local u={}
			u.x, u.y, u.z = Spring.GetUnitPosition(unitID)
			u.team=infectedList[unitID].team
			u.f=math.floor((Spring.GetUnitHeading(unitID)+106496.0)/16384.0)
			while u.f>3 do
				u.f=u.f-4
			end
			table.insert(spawnList,u)
			infectedList[unitID] = nil
		end
	end
end


-- The addition of a projectile parameter in 95.0 caused the parameters attackerID, attackerDefID, attackerTeam to shift
-- For version prior to 95.0:
--function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
-- For 95.0 and beyond
function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, projectileID, attackerID, attackerDefID, attackerTeam)
	if attackerDefID and not attackerTeam then-- Fix to add retrocompatibility
		attackerID, attackerDefID, attackerTeam = projectileID, attackerID, attackerDefID
	end
	if (infector[weaponID] and attackerID and unitDefID ~= zombieID and unitTeam ~= attackerTeam) then
		if (not infectedList[unitID]) then
			infectedList[unitID] = {}
		end
		infectedList[unitID].expiry = frame + infector[weaponID]
		infectedList[unitID].team = attackerTeam
	end
end

end
