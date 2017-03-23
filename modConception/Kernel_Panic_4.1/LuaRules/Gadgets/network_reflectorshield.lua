function gadget:GetInfo()
	return {
		name = "Network Reflectorshield",
		desc = "Enables the Network firewall",
		author = "KDR_11k (David Becker)",
		date = "2008-02-14",
		license = "Public domain",
		layer = 29,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local reloadTime = 90
local protectionTime = 20
local firewall = UnitDefNames.firewall.id

local Desc = {
		id = CMD_FIREWALL,
		name = "Firewall",
		tooltip = 'Protect all units in the target area with a firewall',
		type = CMDTYPE.ICON_MAP,
		action = "attack",
		disabled = false,
		cursor = "Guard"
	}
local rechargeList = {}
local rechargeFrame = 0

local damageList = {}

local protected = {}

function gadget:Initialize()
	_G.protected=protected
	GG.rechargeList = rechargeList
end

function gadget:GameFrame(time)
	for i,d in pairs(damageList) do
		Spring.AddUnitDamage(d.unit, d.damage)
		damageList[i]=nil
	end
	if ((time + 3) % 16 < 0.0001) then
		for u,t in pairs(rechargeList) do
			if (not Spring.ValidUnitID(u)) or Spring.GetUnitIsDead(u)  then
				rechargeList[u]=nil
				break
			end
			local d = Spring.FindUnitCmdDesc(u, CMD_FIREWALL)
			if d then
				Spring.SetUnitRulesParam(u,"readyframe",t)
				Spring.SetUnitRulesParam(u,"reloadtime",reloadTime)
				if t <= time then
					rechargeList[u]=nil
					Spring.CallCOBScript(u, "Charge", 0)
					Spring.EditUnitCmdDesc(u, d, Desc )
				else
					text = math.ceil((t - time) / 32) .. "s"
					Spring.EditUnitCmdDesc(u, d, {disabled = true, name = text} )
				end
			end
		end
		for u,t in pairs(protected) do
			if t <= time then
				protected[u]=nil
			end
		end
	end
end

function gadget:UnitCreated(unit, ud, team, builder)
	if (ud == firewall) then
		Spring.InsertUnitCmdDesc(unit, Desc)
		d = Spring.FindUnitCmdDesc(unit, CMD_FIREWALL)
		Spring.EditUnitCmdDesc(unit, d, {disabled = true, name = reloadTime .. "s", onlyTexture = false} )
		rechargeList[unit] = Spring.GetGameFrame() + reloadTime*32
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	rechargeList[unitID] = nil
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_FIREWALL then
		if rechargeList[unitID] then
			return true, false
		else
			rechargeList[unitID] = Spring.GetGameFrame() + reloadTime * 32
			Spring.CallCOBScript(unitID, "Discharge", 0)
			Spring.PlaySoundFile("sounds/built.wav",10)
			local ownTeam=Spring.GetUnitAllyTeam(unitID)
			for _,u in ipairs(Spring.GetUnitsInCylinder(cmdParams[1], cmdParams[3], 300)) do
				if Spring.GetUnitAllyTeam(u) == ownTeam then
					protected[u] = Spring.GetGameFrame() + protectionTime * 32
				end
			end
			return true, true
		end
	end
	return false, false
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmd == CMD_FIREWALL and not unitDefID == firewall then
		return false
	end
	return true
end

function gadget:UnitDamaged(u, ud, team, damage, para, weapon, au, aud, ateam)
	if damage>0.0001 and protected[u] and not para then
		Spring.SetUnitHealth(u, Spring.GetUnitHealth(u) + damage*.5)
		if au and ateam ~= team and Spring.ValidUnitID(au) and not Spring.GetUnitIsDead(au) then
			table.insert(damageList,{unit = au, damage = damage*.5})
		end
	end
end

else

local phase = 0

function gadget:DrawWorld()
	local _,_,_,_,_,ateam = Spring.GetTeamInfo(Spring.GetLocalTeamID())
	local _,specView = Spring.GetSpectatingState()
	phase=phase+.03
	gl.Texture(":a:bitmaps/kpsfx/shieldEffect.png")
	gl.Blending(GL.SRC_ALPHA, GL.ONE)
	gl.Color(.1,1,.1,1)
	gl.TexGen(GL.T, GL.TEXTURE_GEN_MODE, GL.OBJECT_LINEAR)
	gl.TexGen(GL.T, GL.OBJECT_PLANE, 0, .1, 0, phase)
	gl.DepthTest(GL.LEQUAL)
	gl.Culling(GL.BACK)
	gl.PolygonOffset(-10,-10)

	for u,_ in spairs(SYNCED.protected) do
		local x,y,z = Spring.GetUnitPosition(u)
		if x then
			local los =  Spring.GetPositionLosState(x,y,z, ateam)
			if los or specView then
				gl.Unit(u,true)
			end
		end
	end

	gl.PolygonOffset(false)
	gl.Culling(false)
	gl.TexGen(GL.S,false)
    gl.TexGen(GL.T,false)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	gl.Texture(false)
end

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_FIREWALL, "Guard", {.5,.5,1,1})
end

end
