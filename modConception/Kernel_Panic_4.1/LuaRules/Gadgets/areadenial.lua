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

local frameNum
local explosionList={}
local weaponInfo= {}

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if (weaponInfo[weaponID]) then
		local w={}
		w.radius=weaponInfo[weaponID].radius
		w.damage=weaponInfo[weaponID].damage/30
		w.expiry=frameNum + weaponInfo[weaponID].ttl
		w.id=weaponID;
		w.pos={x=px, y=py, z=pz}
		w.owner=ownerID
		table.insert(explosionList,w)
	end
	return false
end

function gadget:GameFrame(f)
	frameNum=f
	for i,w in pairs(explosionList) do
		local ulist = Spring.GetUnitsInSphere(w.pos.x, w.pos.y, w.pos.z, w.radius)
		if (ulist) then
			for _,u in ipairs(ulist) do
				Spring.AddUnitDamage(u, w.damage, 0, w.owner, w.id, 0, 0, 0)
			end
		end
		if f >= w.expiry then
			explosionList[i] = nil
		end
	end
end

function gadget:Initialize()
	weaponInfo[WeaponDefNames["sigterm"].id] = { radius=350, damage=2000, ttl=100 }
	weaponInfo[WeaponDefNames["nx"].id] = { radius=120, damage=100, ttl=1800 }
	weaponInfo[WeaponDefNames["infection"].id] = { radius=400, damage=120, ttl=400 }
	for w,_ in pairs(weaponInfo) do
		Script.SetWatchWeapon(w, true)
	end
end

end
