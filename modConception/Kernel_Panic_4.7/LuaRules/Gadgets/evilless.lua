
function gadget:GetInfo()
	return {
		name = "Evilless",
		desc = "Simplify the game by removing special buildings, special abilities, and two third of the sides",
		author = "zwzsg",
		date = "January 2009",
		license = "Public domain",
		layer = 99,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)
local Spring_SetUnitCOBValue = Spring.SetUnitCOBValue or Spring.UnitScript.SetUnitCOBValue

local nospecials = Spring.GetModOptions()["nospecials"]
local systemonly = Spring.GetModOptions()["systemonly"]
local nowall = Spring.GetModOptions()["nowall"]
local nowalls = Spring.GetModOptions()["nowalls"]
nospecials = nospecials and (nospecials==true or nospecials==1 or nospecials=="1")
systemonly = systemonly and (systemonly==true or systemonly==1 or systemonly=="1")
nowalls = nowalls and (nowalls==true or nowalls==1 or nowalls=="1")
nowall = nowall and (nowall==true or nowall==1 or nowall=="1")
nowall = nowall or nowalls
nowalls = nowall or nowalls

local Forbidden={}

function gadget:Initialize()
		-- Create the List of Forbidden Commands
		Forbidden={}
		if nospecials then
			for _,udd in ipairs(SpecialBuilding) do
				table.insert(Forbidden,-udd)
			end
			table.insert(Forbidden,CMD_NX) -- Pointer NX flag
			table.insert(Forbidden,CMD_MINELAUNCHER) -- Byte Mine Launcher
			table.insert(Forbidden,CMD_DEPLOY) -- New Hacker bug exploit
			table.insert(Forbidden,CMD_BOMBARD) -- New Hacker bug exploit
			table.insert(Forbidden,CMD_BUG2MINE) -- Old Hacker bug mine
			table.insert(Forbidden,CMD_BURROW) -- Old Hacker worm burrow
			table.insert(Forbidden,CMD_DISPATCH) -- Network teleport out, must be still allowed for port though
		end
		if nowalls then
			table.insert(Forbidden,-badblock)
		end
end

function gadget:GameFrame(f)

	-- At frame 1, replace all homebases by kernels
	if f==1 and systemonly then
		for _,team in ipairs(Spring.GetTeamList()) do
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,HomeBase)) do
				if Spring.GetUnitDefID(u)~=kernel then
					local x, y, z = Spring.GetUnitPosition(u)
					nu = Spring.CreateUnit(kernel,x,y,z,0,Spring.GetUnitTeam(u))
					Spring.SetUnitBlocking(nu,false)
					Spring_SetUnitCOBValue(nu,82,Spring.GetUnitHeading(u))
					Spring.SetUnitHealth(nu,Spring.GetUnitHealth(u)/UnitDefs[Spring.GetUnitDefID(u)].health*UnitDefs[Spring.GetUnitDefID(nu)].health)
					local c=Spring.GetUnitCommands(u,0xFFFF)
					for i=1,#c do
						Spring.GiveOrderToUnit(nu,c[i].id,c[i].params,c[i].options.coded)
					end
					Spring.DestroyUnit(u,false,true,u)
				end
			end
		end
	end

end

function ModifiedToolTip(u,ucd,udd)
	local oldtooltip=Spring.GetUnitCmdDescs(u)[ucd].tooltip;
	return "\255\255\64\64Disabled in "..(udd==-badblock and "Single Player" or "Evilless").."\n\255\255\255\255"..oldtooltip;
end

function gadget:UnitCreated(u,ud)

	-- Disable the Buttons of Forbidden Commands
	for _,udd in ipairs(Forbidden) do
		local UnitCmdDesc = Spring.FindUnitCmdDesc(u,udd)
		if UnitCmdDesc and ud~=port then
			Spring.EditUnitCmdDesc(u,UnitCmdDesc,{disabled=true,tooltip=ModifiedToolTip(u,UnitCmdDesc,udd)})
		end
	end

end

function gadget:AllowCommand(u, ud, team, cmd, param, opt, synced)
	for _,udd in ipairs(Forbidden) do
		if cmd==udd and ud~=port then
			return false
		end
	end
	return true
end


end
