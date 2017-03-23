function gadget:GetInfo()
	return {
		name = "Network Enter",
		desc = "lets Packets enter the Network Buffer",
		author = "KDR_11k (David Becker)",
		date = "2008-02-10",
		license = "Public Domain",
		layer = 26,
		enabled = true
	}
end

local enterDist=150

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local absorbQueue = {}
local closeQueue   = {}

local bufferSize
local spawnStun

local commandDescription = {
	name="Enter",
	type=CMDTYPE.ICON_UNIT,
	tooltip="Return this Packet to the Buffer",
	id=CMD_ENTER,
	action="enter",
	cursor="Load units",
}

function gadget:Initialize()
	bufferSize = GG.bufferSize
	spawnStun=GG.spawnStun
end

function gadget:GameFrame(t)
	for i,u in pairs(absorbQueue) do
		Spring.DestroyUnit(u, false, true, u)
		local team = Spring.GetUnitTeam(u)
		bufferSize[team] = bufferSize[team] + 1
		Spring.SetTeamRulesParam(team,"bufferSize",bufferSize[team])
		Spring.CallCOBScript(u, "Dissolve", 0)
		absorbQueue[i]=nil
	end
	for i,u in pairs(closeQueue) do
		Spring.SetUnitMoveGoal(u[1],u[2],u[3],u[4],enterDist * .75)
		closeQueue[i]=nil
	end
end

function gadget:UnitCreated(u,ud,team)
	if ud == packet then
		Spring.InsertUnitCmdDesc(u, commandDescription)
	end
end

function gadget:AllowCommand(u,ud,team,cmd,param,opts)
	if cmd == CMD_ENTER then
		if ud == packet and isTeleporter[Spring.GetUnitDefID(param[1])] and Spring.GetUnitTeam(param[1])==team and not Spring.GetUnitIsStunned(param[1]) then
			return true
		else
			return false
		end
	end
	return true
end

function gadget:CommandFallback(u,ud,team,cmd,param,opts)
	if cmd == CMD_ENTER then
		if Spring.ValidUnitID(param[1]) and isTeleporter[Spring.GetUnitDefID(param[1])] then
			local tx,ty,tz = Spring.GetUnitPosition(param[1])
			local x,y,z = Spring.GetUnitPosition(u)
			local dist = math.sqrt((x-tx)*(x-tx) + (z-tz)*(z-tz))
			if dist < enterDist and (not spawnStun[u] or spawnStun[u] < Spring.GetGameFrame()) then
				table.insert(absorbQueue,u)
				return true,true
			else
				table.insert(closeQueue,{u, tx, ty, tz})
				return true, false
			end
		end
	end
	return false
end

else

--UNSYNCED

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_ENTER, "Load units", {.5,1,.5,1})
end

end
