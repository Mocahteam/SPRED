

-- This is unused for Spring versions <= 0.76
-- This replaces LuaCob for Spring versions > 0.76

function gadget:GetInfo()
	return {
		name = "LuaCOB",
		desc = "All the former LuaCOB stuff",
		author = "KDR_11k (David Becker)",
		date = "January 2008",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local destroyQueue = {}
local replaceQueue={}
local createQueue={}
local customtoggleQueue={}

local Spring_SetUnitCOBValue = Spring.SetUnitCOBValue or Spring.UnitScript.SetUnitCOBValue

function gadget:GameFrame(t)
	for i,u in pairs(destroyQueue) do
		Spring.DestroyUnit(u, true, false, u) --using selfD to prevent plane crashing anim
		destroyQueue[i]=nil
	end
	for i,u in pairs(replaceQueue) do
		local x, y, z
		x, y, z = Spring.GetUnitPosition(u.unit)
		nu = Spring.CreateUnit(u.target,x,y,z,0,u.team)
		if nu then
			if u.LineageRoot then
				Spring.SetUnitLineage(nu,u.team,true)
			end
			Spring.SetUnitBlocking(nu, false)
			Spring_SetUnitCOBValue(nu, 82, Spring.GetUnitHeading(u.unit))
			Spring.SetUnitHealth(nu, Spring.GetUnitHealth(u.unit) / UnitDefs[Spring.GetUnitDefID(u.unit)].health * UnitDefs[Spring.GetUnitDefID(nu)].health)
			local c = Spring.GetUnitCommands(u.unit,0xFFFF)
			for i = 1, #c do
				Spring.GiveOrderToUnit(nu, c[i].id, c[i].params, c[i].options.coded)
			end
			Spring.DestroyUnit(u.unit, false, true, u.unit)
		else
			Spring.Echo("Error: Failed to replace team["..u.team.."] "..UnitDefs[Spring.GetUnitDefID(u.unit)].humanName.." with "..UnitDefNames[u.target].humanName)
		end
		replaceQueue[i] = nil
	end
	for i,u in pairs(createQueue) do
		Spring.CreateUnit(u.target,u.x,u.y,u.z,0,u.team)
		createQueue[i] = nil
	end
	for i,u in pairs(customtoggleQueue) do
		Spring.GiveOrderToUnit(u.unit,CMD.INSERT,{-1,u.cmdid,CMD.OPT_SHIFT,u.state},{"alt"})
		customtoggleQueue[i] = nil
	end
end

function Destroy(u, ud, team)
	table.insert(destroyQueue, u)
end

function GetCentralHeading(unit, ud, team)
	local x=0
	local z=0
	local count = 0
	for _,u in ipairs(Spring.GetAllUnits()) do
		local tempx, tempz
		tempx, _, tempz = Spring.GetUnitPosition(u)
		x = x + tempx
		z = z + tempz
		count = count + 1
	end
	local ux, uz
	ux, _, uz = Spring.GetUnitPosition(unit)
	return Spring.GetHeadingFromVector(x/count-ux, x/count-uz)
end

function SwitchToExploit(u,ud,team)
	table.insert(replaceQueue, {unit=u, team=team, target="exploit" })
end

function SwitchToBug(u,ud,team)
	table.insert(replaceQueue, {unit=u, team=team, target="bug" })
end

function GetHealth(u, ud, team, target)
	return Spring.GetUnitHealth(target)
end

function GetMyHealth(u, ud, team)
	return Spring.GetUnitHealth(u)
end

function GetLogicBombLeft(u, ud, team)
	return UnitDefNames.logic_bomb.maxThisUnit-#Spring.GetTeamUnitsByDefs(team,UnitDefNames.logic_bomb.id)
end

function GiveExpMobile(u, ud, team)
	local x, y, z
	x, y, z = Spring.GetUnitPosition(u)
	z=z+80
	table.insert(createQueue, {x=x, y=y, z=z, team=team, target="expmobile" })
end

function IsParalyzed(u,ud,team)
	return Spring.GetUnitIsStunned(u)
end

function Damage(u, ud, team, value)
	Spring.AddUnitDamage(u,value,0,-1,WeaponDefNames.sigterm.id)
end

function GetWhetherONSMode()
	return Spring.GetModOptions()["ons"] and Spring.GetModOptions()["ons"]~="0"
end

function GetONSInfo(u,ud,team)
	if GetWhetherONSMode() then
		if GG.GetUnitONSInfo then
			return GG.GetUnitONSInfo(u)
		else
			Spring.Echo("ons.lua broken!")
		end
	end
	return false,false,false,false,false,false,false,false,false
end

function GetWeaponLoadState(u,ud,team,weapon)
	-- In 95 weapons are 1-indexed, before they were 0-indexed
	angleGood, loaded, reloadFrame, salvoLeft, numStockpiled = Spring.GetUnitWeaponState(u,weapon-(Game.gameName and 0 or 1))
	return loaded
end

function GetBackInTime(u,ud,team)
	table.insert(replaceQueue, {unit=u, team=team, target="holeOLD", LineageRoot=true })
	for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,UnitDefNames.window.id)) do
		table.insert(replaceQueue, {unit=u, team=team, target="windowold" })
	end
end

function GoToGensokyo(u,ud,team)
	table.insert(replaceQueue, {unit=u, team=team, target="thbase", LineageRoot=true })
	for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,UnitDefNames.port.id)) do
		table.insert(replaceQueue, {unit=u, team=team, target="thminifac" })
	end
end

function SetBurrowState(u,ud,team,state)
	table.insert(customtoggleQueue, {unit=u, cmdid = 32104, state = state}) -- 32104 is the ID of the custom command burrow
end

function SetAlphaThreshold(u,ud,team,alpha)
	if GG.Synced_Set_Alpha_Threshold then
		GG.Synced_Set_Alpha_Threshold(u,math.max(0,math.min(255,alpha)/255))
	end
end

function GetNextShape(u,ud,team)
	local ShapeCodes={
			[UnitDefNames.rock.id]=1,
			[UnitDefNames.paper.id]=2,
			[UnitDefNames.scissors.id]=3,
		}
	for _,q in ipairs(Spring.GetFactoryCommands(u,5) or {}) do
		if ShapeCodes[-q.id] then
			return ShapeCodes[-q.id]
		end
	end
	return 0
end


function gadget:Initialize()
	gadgetHandler:RegisterGlobal("Destroy", Destroy)
	gadgetHandler:RegisterGlobal("GetCentralHeading", GetCentralHeading)
	gadgetHandler:RegisterGlobal("SwitchToExploit", SwitchToExploit)
	gadgetHandler:RegisterGlobal("SwitchToBug", SwitchToBug)
	gadgetHandler:RegisterGlobal("GetHealth", GetHealth)
	gadgetHandler:RegisterGlobal("GetMyHealth", GetMyHealth)
	gadgetHandler:RegisterGlobal("GetLogicBombLeft", GetLogicBombLeft)
	gadgetHandler:RegisterGlobal("GiveExpMobile", GiveExpMobile)
	gadgetHandler:RegisterGlobal("IsParalyzed", IsParalyzed)
	gadgetHandler:RegisterGlobal("Damage", Damage)
	gadgetHandler:RegisterGlobal("GetWhetherONSMode",GetWhetherONSMode)
	gadgetHandler:RegisterGlobal("GetBackInTime", GetBackInTime)
	gadgetHandler:RegisterGlobal("GoToGensokyo", GoToGensokyo)
	gadgetHandler:RegisterGlobal("SetBurrowState", SetBurrowState)
	gadgetHandler:RegisterGlobal("GetONSInfo", GetONSInfo)
	gadgetHandler:RegisterGlobal("GetWeaponLoadState", GetWeaponLoadState)
	gadgetHandler:RegisterGlobal("GetBeamSource", GetBeamSource)
	gadgetHandler:RegisterGlobal("SetAlphaThreshold", SetAlphaThreshold)
	gadgetHandler:RegisterGlobal("GetNextShape", GetNextShape)
end

end
