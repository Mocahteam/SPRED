function gadget:GetInfo()
	return {
		name = "Bombard",
		desc = "Weaponless bombard implementation",
		author = "KDR_11k (David Becker)",
		date = "2008-02-10",
		license = "Public Domain",
		layer = 21,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local mgList={}
local cmdList={}

local desc= {
	id = CMD_BOMBARD,
	name = "Bombard",
	tooltip = "Transform into artillery and attack target\r\nTip: hold alt to just deploy in range",
	type = CMDTYPE.ICON_UNIT_OR_MAP,
	action = "dgun",
	cursor = "Capture",
	disabled = false
}

function gadget:UnitCreated(u, ud, team)
	if ud == bug then
		Spring.InsertUnitCmdDesc(u,desc)
	end
end

function gadget:AllowCommand(u, ud, team, cmd, param, opt)
	if cmd == CMD_BOMBARD then
		return  param[1] and ud==bug
	end
	return true
end

function gadget:CommandFallback(u,ud,team,cmd,param,opt)
	if cmd == CMD_BOMBARD then
		local x,y,z = Spring.GetUnitPosition(u)
		local tx,ty,tz
		if param[2] then
			tx=param[1]
			ty=param[2]
			tz=param[3]
		else
			if param[1] and Spring.ValidUnitID(param[1]) then
				tx,ty,tz=Spring.GetUnitPosition(param[1])
			else
				return false
			end
		end
		local dist = math.sqrt((x-tx)*(x-tx)+(y-ty)*(y-ty)+(z-tz)*(z-tz))
		if dist > 1150 then
			table.insert(mgList,{u=u,tx=tx,ty=ty,tz=tz,r=1150})
			return true,false
		else
			table.insert(cmdList, {u=u,attack=not opt.alt,param=param})
			return true,true
		end
	end
	return false
end

function gadget:GameFrame(f)
	for i,d in pairs(mgList) do
		Spring.SetUnitMoveGoal(d.u,d.tx,d.ty,d.tz,d.r)
		mgList[i]=nil
	end
	for i,c in pairs(cmdList) do
		Spring.GiveOrderToUnit(c.u,CMD_DEPLOY,{},{})
		if c.attack then
			Spring.GiveOrderToUnit(c.u,CMD.INSERT,{-1,CMD.ATTACK,0,c.param[1],c.param[2],c.param[3]},{"alt"})
		end
		cmdList[i]=nil
	end
end

else

--UNSYNCED

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_BOMBARD, "Capture",{1,.5,.5,.9})
end

end
