function gadget:GetInfo()
	return {
		name = "Airstrike",
		desc = "Allows a unit to spawn a bomber",
		author = "KDR_11k (David Becker)",
		date = "2007-08-26",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local airstrike_reload_time = 90
local bomberLauncher
local bomber
local spawnQueue = {}
local destroyQueue = {}

VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local ASDesc = {
		id = CMD_AIRSTRIKE,
		name = "SIGTERM",
		tooltip = 'Send a signal that terminates anything in the target area.',
		type = CMDTYPE.ICON_MAP,
		action = "attack",
		texture = "&.9x.9&unitpics/sigterm.png&bitmaps/frame.tga",
		onlyTexture = true,
		disabled = false,
		cursor = "Attack"
	}
local rechargeList = {}
local rechargeFrame = 0

function gadget:Initialize()
	bomberLauncher = UnitDefNames["terminal"].id
	bomber = "signal"
	GG.rechargeList = rechargeList
	--RegisterCMDID(gadget, CMD_AIRSTRIKE)
end

function gadget:GameFrame(time)
	for i,b in pairs(spawnQueue) do
		local u = Spring.CreateUnit(bomber,b.pos.x, b.pos.y, b.pos.z, b.heading, b.team)
		if u then
			Spring.GiveOrderToUnit(u, CMD.ATTACK, b.target, {})
			Spring.SetUnitNoSelect(u, true)
		else
			Spring.Echo("Error: team["..b.team.."] terminal failed to send signal!")
		end
		spawnQueue[i] = nil
	end
	rechargeFrame = time + airstrike_reload_time*32
	if (time % 16 < 0.0001) then
		for u,t in pairs(rechargeList) do
			d = Spring.FindUnitCmdDesc(u, CMD_AIRSTRIKE)
			if d then
				Spring.SetUnitRulesParam(u,"readyframe",t)
				Spring.SetUnitRulesParam(u,"reloadtime",airstrike_reload_time)
				if t <= time then
					rechargeList[u]=nil
					Spring.EditUnitCmdDesc(u, d, ASDesc )
				else
					text = math.ceil((t - time) / 32) .. "s"
					Spring.EditUnitCmdDesc(u, d, {name = text} )
				end
			end
		end
	end
end

function gadget:UnitCreated(unit, ud, team, builder)
	if (ud == bomberLauncher) then
		Spring.InsertUnitCmdDesc(unit, ASDesc)
		d = Spring.FindUnitCmdDesc(unit, CMD_AIRSTRIKE)
		Spring.EditUnitCmdDesc(unit, d, {disabled = true, name = airstrike_reload_time .. "s", onlyTexture = false} )
		rechargeList[unit] = rechargeFrame
		d = Spring.FindUnitCmdDesc(unit, CMD.STOP)
		Spring.RemoveUnitCmdDesc(unit, d)
		d = Spring.FindUnitCmdDesc(unit, CMD.REPEAT)
		Spring.RemoveUnitCmdDesc(unit, d)
		d = Spring.FindUnitCmdDesc(unit, CMD.FIRE_STATE)
		Spring.RemoveUnitCmdDesc(unit, d)
		d = Spring.FindUnitCmdDesc(unit, CMD.AISELECT)
		if (d) then
			Spring.RemoveUnitCmdDesc(unit, d)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	rechargeList[unitID] = nil
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_AIRSTRIKE and unitDefID==bomberLauncher then
		if rechargeList[unitID] then
			return true, true
		else
			local x,y,z = Spring.GetUnitPosition(unitID)
			table.insert(spawnQueue, {pos = {x = x, y = y, z = z}, target = cmdParams, team = unitTeam, heading = Spring.GetUnitBuildFacing(unitID)} )
			d = Spring.FindUnitCmdDesc(unitID, CMD_AIRSTRIKE)
			Spring.EditUnitCmdDesc(unitID, d, {disabled = true, name = "120s", onlyTexture = false} )
			rechargeList[unitID] = rechargeFrame
			return true, true
		end
	end
	return false, false
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if (unitDefID == UnitDefNames[bomber].id and cmdID ~= CMD.ATTACK) then
		return false
	end
	if rechargeList[unitID] and cmdID == CMD_AIRSTRIKE then
		return false --forbid this command if the unit is still recharging its airstrike
	end
	return true
end

end
