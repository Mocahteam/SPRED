function gadget:GetInfo()
	return {
		name = "Network Dispatch",
		desc = "Dispatches Packets from the Buffer",
		author = "KDR_11k (David Becker)",
		date = "2008-02-10",
		license = "Public Domain",
		layer = 25,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local spawnQueue = {}

local offsetList = {
	-3, -3,  2,
	-1, -3,  2,
	 1, -3,  2,
	 3, -3,  1,
	 3, -1,  1,
	 3,  1,  1,
	 3,  3,  0,
	 1,  3,  0,
	-1,  3,  0,
	-3,  3,  3,
	-3,  1,  3,
	-3, -1,  3,
}

local bufferSize

local commandDescription = {
	name="Dispatch",
	type=CMDTYPE.ICON_MAP,
	tooltip="Dispatch Packets from the Buffer (hold alt to dispatch until the buffer is empty)",
	id=CMD_DISPATCH,
	action="dispatch",
	cursor="Unload units",
}

local spawnStun={}
local stunTime=180 --frames before a spawned packet may reenter the buffer

function gadget:Initialize()
	bufferSize = GG.bufferSize
	GG.spawnStun = spawnStun
end

function gadget:GameFrame(t)
	for i,d in pairs(spawnQueue) do
		nu = Spring.CreateUnit(d.name, d.x, d.y, d.z, d.heading, d.team)
		if nu then
			Spring.GiveOrderToUnit(nu, CMD.MOVE, {d.tx, d.ty, d.tz}, {})
			Spring.CallCOBScript(nu, "Spawned", 0)
			spawnStun[nu]=t + stunTime
		else
			Spring.Echo("Error: Failed to spawn-dispatch team["..d.team.."] "..UnitDefNames[d.name].humanName)
		end
		spawnQueue[i]=nil
	end
end

function gadget:UnitCreated(u,ud,team)
	if isTeleporter[ud] then
		Spring.InsertUnitCmdDesc(u, commandDescription)
	end
end

function gadget:UnitDestroyed(u,ud,team)
	spawnStun[u]=nil
end

function gadget:AllowCommand(u,ud,team,cmd,param,opts)
	if cmd == CMD_DISPATCH then
		if isTeleporter[ud] then
			return true
		else
			return false
		end
	end
	return true
end

function gadget:CommandFallback(u,ud,team,cmd,param,opts)
	if cmd == CMD_DISPATCH then
		local index = 0
		local x,y,z = Spring.GetUnitPosition(u)
		while index < 12 and bufferSize[team] > 0 do
			local tx = x + offsetList[3*index +1]*16 + math.random(1,10000) * .0001
			local tz = z + offsetList[3*index +2]*16 + math.random(1,10000) * .0001 --epsilon to avoid zero distances
			local blocking, feature = Spring.TestBuildOrder(UnitDefNames["packet"].id,tx,y,tz,offsetList[3*index +3])
			if not Spring.GetGroundBlocked(tx-8, tz-8, tx+8, tz+8) and blocking==2 and feature==nil then
				bufferSize[team] = bufferSize[team] -1
				Spring.SetTeamRulesParam(team,"bufferSize",bufferSize[team])
				table.insert(spawnQueue, {
					x = tx,
					z = tz,
					y = y,
					name = "packet",
					team = team ,
					tx = param[1],
					ty = param[2],
					tz = param[3],
					heading=offsetList[3*index +3],
				})
			end
			index = index +1
		end
		return true, not opts.alt or bufferSize[team]==0
	end
	return false
end

else

--UNSYNCED

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_DISPATCH, "Unload units", {.5,.5,1,1})
end

end
