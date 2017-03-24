function gadget:GetInfo()
	return {
		name = "Special Attack",
		desc = "Gives units special attack options",
		author = "KDR_11k (David Becker), modified by zwzsg",
		date = "2007-08-26",
		license = "Public domain",
		layer = 21,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local GHOST_PARAM = -12563

local special={}
local cooldown={}
local replacelist={}

function gadget:Initialize()
	local desc= {
			id = CMD_NX,
			name = "NX Flag",
			tooltip = "Set the target area on fire",
			type = CMDTYPE.ICON_MAP,
			action = "dgun",
			texture = "&.1x.1&unitpics/nxflag.png&bitmaps/frame.tga",
			onlyTexture = true,
			disabled = false,
			cursor = "Capture"
		}
	for id,weaponDef in pairs(WeaponDefs) do
		for name,param in weaponDef:pairs() do
			-- Spring.Echo(name,param)
		end
	end
	if ((Spring.GetModOptions()["nx"] ~= nil) and (Spring.GetModOptions()["nx"] == false) or (Spring.GetModOptions()["nx"] == "0")) then
		desc.disabled=true
	end
	-- If pointer has a second weapon
	-- I would like to check if the weapon name match nx or something, but every time I try to get the property of a weapon it return nil
	if UnitDefNames["pointer"]["weapons"][2] then
		special[UnitDefNames["pointer"].id] = {}
		special[UnitDefNames["pointer"].id][0] = {
			replaceWith = CMD.ATTACK,
			CobFuncName = "SpecialAttack",
			desc = desc
		}
	end
	local desc= {
			id = CMD_DEPLOY,
			name = "Deploy",
			tooltip = "Transform into artillery emplacement\r\nTip: The button is queuable, the hotkey is not.",
			type = CMDTYPE.ICON,
			action = "deploy",
			disabled = false
		}
	special[UnitDefNames["bug"].id] = {}
	special[UnitDefNames["bug"].id][1] = {
		replaceWith = nil,
		CobFuncName = "DeployNoTarget",
		desc = desc
	}
	local desc= {
			id = CMD_UNDEPLOY,
			name = "Undeploy",
			tooltip = "Transform into bug",
			type = CMDTYPE.ICON,
			action = "undeploy",
			disabled = false
		}
	special[UnitDefNames["exploit"].id] = {}
	special[UnitDefNames["exploit"].id][2] = {
		replaceWith = nil,
		CobFuncName = "SpecialAttack",
		desc = desc,
	}
	local desc= {
			id = CMD_BUG2MINE,
			name = "Mine",
			tooltip = "Transform into mine\r\nTip: The button is queuable, the hotkey is not.",
			type = CMDTYPE.ICON,
			action = "deploy",
			disabled = false
		}
	special[UnitDefNames["bugold"].id] = {}
	special[UnitDefNames["bugold"].id][3] = {
		replaceWith = nil,
		CobFuncName = "Mine",
		desc = desc,
	}
	local desc= {
			id = CMD_MINE2BUG,
			name = " Bug ",
			tooltip = "Transform back into bug",
			type = CMDTYPE.ICON,
			action = "undeploy",
			disabled = false
		}
	special[UnitDefNames["bugold"].id][4] = {
		replaceWith = nil,
		CobFuncName = "Bug",
		desc = desc,
	}
-- CMD_BOMBARD now handled by its own .lua file
--	local desc= {
--			id = CMD_BOMBARD,
--			name = "Bombard",
--			tooltip = "Transform into artillery and attack target.",
--			type = CMDTYPE.ICON_MAP,
--			action = "dgun",
--			cursor = "Capture",
--			disabled = false
--		}
--	special[UnitDefNames["bug"].id][5] = {
--		replaceWith = CMD.DGUN,
--		CobFuncName = "DeployTarget",
--		desc = desc
--	}
	local desc= {
			id = CMD_MINELAUNCHER,
			name = "Launch Mines",
			tooltip = "Launches several mines in a forward arc,\r\nat the cost of 6000 hitpoints. 10s reload.",
			type = CMDTYPE.ICON,
			action = "launchmines",
			texture = "&.9x.9&unitpics/logic_bomb.pcx&bitmaps/frame.tga", -- .9 borders -> inverted image
			onlyTexture = true,
			disabled = false
		}
	if ((Spring.GetModOptions()["minelauncher"] ~= nil) and (Spring.GetModOptions()["minelauncher"] == false) or (Spring.GetModOptions()["minelauncher"] == "0")) then
		desc.disabled=true
	end
	-- If byte has a second weapon
	-- I would like to perform a test on weapon name or something, but every time I try to get the property of a weapon it return nil
	if UnitDefNames["pointer"]["weapons"][2] then
		special[UnitDefNames["byte"].id] = {}
		special[UnitDefNames["byte"].id][6] = {
			replaceWith = nil,
			CobFuncName = "LaunchMines",
			desc = desc,
	}
	end
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	if(special[unitDefID] and special[unitDefID][cmdID - CMD_SPECIAL]) then
		-- Muratet (check if we found the "ghost" parameter
		doReplacement = true
		if type(cmdParams) == "table" then
			for k, v in pairs(cmdParams) do
				if v == GHOST_PARAM then
					doReplacement = false
				end
			end
		end
		if doReplacement then
			table.insert(replacelist, {unitID = unitID, cmd = cmdID - CMD_SPECIAL, unitDefID = unitDefID, cmdParams = cmdParams})
		end
		-- table.insert(replacelist, {unitID = unitID, cmd = cmdID - CMD_SPECIAL, unitDefID = unitDefID, cmdParams = cmdParams})
		--
		return true, true
	end
	return false, false
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if (special[unitDefID]) then
		for _,d in pairs(special[unitDefID]) do
			Spring.InsertUnitCmdDesc(unitID, d.desc)
			if(d.desc.name == "Bombard") then
				Spring.RemoveUnitCmdDesc(unitID, Spring.FindUnitCmdDesc(unitID, CMD.DGUN)) -- remove the DGun button
			end
		end
	end
end

function gadget:GameFrame(f)
	for i,c in pairs(replacelist) do
		Spring.CallCOBScript(c.unitID, special[c.unitDefID][c.cmd].CobFuncName, 0, c.cmd, c.cmdParams[1], c.cmdParams[2], c.cmdParams[3])
		if special[c.unitDefID][c.cmd].replaceWith then
			-- Don't insert attack order if (due to repeat) the exact same attack order is already in the queue
			local Queue=Spring.GetCommandQueue(c.unitID)
			if not Queue
				or not Queue[1]
				or Queue[1].id~=special[c.unitDefID][c.cmd].replaceWith
				or #Queue[1].params~=3
				or Queue[1].params[1]~=c.cmdParams[1]
				or Queue[1].params[2]~=c.cmdParams[2]
				or Queue[1].params[3]~=c.cmdParams[3] then
				Spring.GiveOrderToUnit(c.unitID, CMD.INSERT, {0, special[c.unitDefID][c.cmd].replaceWith, 0, c.cmdParams[1], c.cmdParams[2], c.cmdParams[3]}, {"alt"})
				-- Muratet (requeue a ghost of the original order => The engine will not be able to execute this order (gadget:CommandFallback will be recall) but we need it in queue for Prog&Play calls, see PP_Unit_ActionOnPosition in case of sycnrhonized call)
				Spring.GiveOrderToUnit(c.unitID, CMD.INSERT, {1, CMD_NX, 0, c.cmdParams[1], c.cmdParams[2], c.cmdParams[3], GHOST_PARAM}, {"alt"})
				--
			end
		end -- CMD_NX
		replacelist[i]=nil
	end
end

end
