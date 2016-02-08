
-- In-game, type /luarules bb1 in the console to toggle the ai debug messages

function gadget:GetInfo()
	return {
		name = "Byte Battle: level 1",
		desc = "An AI that looks for opponent and engages fight.",
		author = "Mathieu Muratet",
		date = "2010-10-17",
		license = "Public Domain",
		layer = 83,
		enabled = true
	}
end

-- This algorithm orders army to cross the map in formation. if no-one enemy
-- units are detected, a random search is carried out (for each unit without
-- command queue, a random position is defined ont the map). When one or more
-- enemy units are detected, this algorithm orders units that doesn't attack to
-- lock the nearest enemy unit from unattacking units' center of gravity.

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local BBAI_Debug_Mode=0 -- Must be 0 or 1
local team = {}

local function ChangeAIDebugVerbosity(cmd,line,words,player)
	local lvl=tonumber(words[1])
	if lvl then
		BBAI_Debug_Mode=lvl
		Spring.Echo("BB level 1 AI debug verbosity set to "..BBAI_Debug_Mode)
	else
		if BBAI_Debug_Mode>0 then
			BBAI_Debug_Mode=0
		else
			BBAI_Debug_Mode=1
		end
		Spring.Echo("BB level 1 AI debug verbosity toggled to "..BBAI_Debug_Mode)
	end
	return true
end

local function SetupCmdChangeAIDebugVerbosity()
	local cmd,func,help
	cmd  = "bb1"
	func = ChangeAIDebugVerbosity
	help = " [0|1]: make the BB LUA AI shut up or fill your infolog"
	gadgetHandler:AddChatAction(cmd,func,help)
	Script.AddActionFallback(cmd..' ',help)
end

local function BBAIDebugMessage(t,message)
	if(BBAI_Debug_Mode>0) then
		Spring.Echo("Team["..t.."] "..message)
	end
end

function gadget:Initialize()
	SetupCmdChangeAIDebugVerbosity()
end

function gadget:GameStart()
	-- Initialise AI for all team that are set to use it
	for _,t in ipairs(Spring.GetTeamList()) do
		local _,_,_,ai,side = Spring.GetTeamInfo(t)
		if Spring.GetTeamLuaAI(t)==gadget:GetInfo().name then
			BBAIDebugMessage(t, " assigned to "..gadget:GetInfo().name);
			team[t] = {
				underControl=true,
				step=0,
			}
		else
			team[t] = {
				underControl=false,
			}
		end
	end
end

function gadget:GameFrame(f)
	if f%10 == 0 then
		for _,t in ipairs(Spring.GetTeamList()) do
			if team[t].underControl then
				if team[t].step == 0 then
					-- launch the march
					for _,u in ipairs(Spring.GetTeamUnits(t)) do
						local x, y, z = Spring.GetUnitPosition(u)
						x = Game.mapSizeX - x
						Spring.GiveOrderToUnit(u, CMD.MOVE, {x, Spring.GetGroundHeight(x, z), z}, {})
					end
					team[t].step = f
				else
					-- store visible enemy units
					local enemy = {}
					local cpt = 1
					for _,t2 in ipairs(Spring.GetTeamList()) do
						if not Spring.AreTeamsAllied(t,t2) then
							for _,e in ipairs(Spring.GetTeamUnits(t2)) do
								local pos_x, pos_y, pos_z = Spring.GetUnitPosition(e)
								local _,_,_,_,_,allyTeam = Spring.GetTeamInfo(t)
								if Spring.IsPosInLos(pos_x, pos_y, pos_z, allyTeam) then
									enemy[cpt]=e
									cpt = cpt + 1
								end
							end
						end
					end
					if table.getn(enemy) == 0 then
						-- parse all unit
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							if table.getn(Spring.GetUnitCommands(u)) == 0 then
								-- random search
								local pos_x = math.random(Game.mapSizeX-1)
								local pos_z = math.random(Game.mapSizeZ-1)
								Spring.GiveOrderToUnit(u, CMD.MOVE, {pos_x, Spring.GetGroundHeight(pos_x, pos_z), pos_z}, {})
							end
						end
					else
						local units = {}
						local cpt = 1
						local barX = 0
						local barZ = 0
						-- order to units that haven't target to attack the fisrt enemy unit
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							local attack = false
							local commandQueue = Spring.GetUnitCommands(u)
							if table.getn(commandQueue) == 0 then
								attack = true
							end
							if table.getn(commandQueue) > 0 then
								if commandQueue[1].id ~= CMD.ATTACK then
									attack = true
								end
							end
							if attack then
								units[cpt] = u
								local pos_x, pos_y, pos_z = Spring.GetUnitPosition(u)
								barX = barX + pos_x
								barZ = barZ + pos_z
								cpt = cpt + 1
							end
						end
						if cpt ~= 1 then
							barX = barX / (cpt-1)
							barZ = barZ / (cpt-1)
							local distance = Game.mapSizeX*Game.mapSizeX+Game.mapSizeZ*Game.mapSizeZ
							local select = -1
							for _,e in ipairs(enemy) do
								local enPos_x, enPos_y, enPos_z = Spring.GetUnitPosition(e)
								local dx = barX - enPos_x
								local dz = barZ - enPos_z
								if dx*dx+dz*dz < distance then
									distance = dx*dx+dz*dz
									select = e
								end
							end
							if select ~= -1 then
								for  _,u in ipairs(units) do
									Spring.GiveOrderToUnit(u, CMD.ATTACK, {select}, {})
								end
							end
						end
					end
				end
			end
		end
	end
end

function gadget:GameOver()
	for _,t in ipairs(team) do
		t.underControl = false
	end
end

end
