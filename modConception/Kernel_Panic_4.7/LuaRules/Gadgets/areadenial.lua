function gadget:GetInfo()
	return {
		name = "Area Denial",
		desc = "Lets a weapon's damage persist in an area",
		author = "KDR_11k (David Becker)",
		date = "2007-08-26",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local frameNum=0
local explosionList={}
local weaponInfo={}
local LastSignalTeam=nil

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	if unitDefID == signal then
		LastSignalTeam = teamID
	end
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if (weaponInfo[weaponID]) then
		local w={}
		w.radius=weaponInfo[weaponID].radius
		w.damage=weaponInfo[weaponID].damage/30
		w.expiry=frameNum + weaponInfo[weaponID].ttl
		w.damageFriendly=weaponInfo[weaponID].damageFriendly
		w.id=weaponID;
		w.pos={x=px, y=py, z=pz}
		w.owner=ownerID
		if ownerID and Spring.ValidUnitID(ownerID) then
			w.team=Spring.GetUnitTeam(ownerID)
			table.insert(explosionList,w)
			return false -- spawn the CEG
		elseif weaponID==WeaponDefNames["sigterm"].id then
			w.team=LastSignalTeam
			table.insert(explosionList,w)
			return false -- spawn the CEG
		else
			return true -- does not spawn the CEG
		end
	end
end

function gadget:GameFrame(f)
	frameNum=f
	for i,w in pairs(explosionList) do
		-- If the unit responsible for the damage dies, then pretend a random factory of the same team is the one dealing damage
		-- Otherwise, the handicap.lua gadget makes the Area Denial weapons deal full damage when the unit that fired it dies.
		-- Note: It still doesn't work when the unit dies as the shot is in mid-air (then the damage is attributed to Gaia)
		if not Spring.ValidUnitID(w.owner) or Spring.GetUnitIsDead(w.owner) then
			local sel=Spring.GetTeamUnitsByDefs(w.team,HomeBase)
			if #(sel or {})>=1 then
				w.owner=sel[math.random(1,#sel)]
			else
				sel=Spring.GetTeamUnitsByDefs(w.team,MiniFac)
				if #(sel or {})>=1 then
					w.owner=sel[math.random(1,#sel)]
				else
					w.owner = nil
				end
			end
		end
		-- Find units in the area and damage them
		local ulist = Spring.GetUnitsInSphere(w.pos.x, w.pos.y, w.pos.z, w.radius)
		if ulist then
			for _,u in ipairs(ulist) do
				if w.damageFriendly or not Spring.AreTeamsAllied(Spring.GetUnitTeam(u),w.team) then
					Spring.AddUnitDamage(u, w.damage, 0, w.owner, w.id, 0, 0, 0)
				end
			end
		end
		-- Remove once expired
		if f >= w.expiry then
			explosionList[i] = nil
		end
	end
end

function gadget:Initialize()
	weaponInfo[WeaponDefNames["sigterm"].id] = { radius=350, damage=2000, ttl=100, damageFriendly=true }
	weaponInfo[WeaponDefNames["nx"].id] = { radius=120, damage=100, ttl=1800, damageFriendly=true }
	weaponInfo[WeaponDefNames["infection"].id] = { radius=400, damage=120, ttl=400, damageFriendly=false }
	for w,_ in pairs(weaponInfo) do
		Script.SetWatchWeapon(w, true)
	end
end

end
