
-- In-game, type /luarules bb2 in the console to toggle the ai debug messages

function gadget:GetInfo()
	return {
		name = "Byte Battle: level 2",
		desc = "An AI that looks for opponent, engages fight and manages each byte independently.",
		author = "Mathieu Muratet",
		date = "2010-10-17",
		license = "Public Domain",
		layer = 83,
		enabled = true
	}
end

-- This algorithm orders army to cross the map in formation. If no-one enemy
-- units are detected, a random search is carried out (for each unit without
-- command queue, a random position is defined ont the map). When one or more
-- enemy units are detected, this algorithm orders each unit to lock the
-- nearest enemy unit.

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local BBAI_Debug_Mode=0 -- Must be 0 or 1
local team = {}

local function ChangeAIDebugVerbosity(cmd,line,words,player)
	local lvl=tonumber(words[1])
	if lvl then
		BBAI_Debug_Mode=lvl
		Spring.Echo("BB level 2 AI debug verbosity set to "..BBAI_Debug_Mode)
	else
		if BBAI_Debug_Mode>0 then
			BBAI_Debug_Mode=0
		else
			BBAI_Debug_Mode=1
		end
		Spring.Echo("BB level 2 AI debug verbosity toggled to "..BBAI_Debug_Mode)
	end
	return true
end

local function SetupCmdChangeAIDebugVerbosity()
	local cmd,func,help
	cmd  = "bb2"
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

local function inactive(t)
	local wait = true
	for _,u in ipairs(Spring.GetTeamUnits(t)) do
		wait = wait and table.getn(Spring.GetUnitCommands(u)) == 0
	end
	return wait
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
	if (f+5)%10 == 0 then
		for _,t in ipairs(Spring.GetTeamList()) do
			if team[t].underControl then
				if team[t].step == 0 then
					-- launch the march
					for _,u in ipairs(Spring.GetTeamUnits(t)) do
						local pos_x, pos_y, pos_z = Spring.GetUnitPosition(u)
						pos_x = Game.mapSizeX - pos_x
						Spring.GiveOrderToUnit(u, CMD.MOVE, {pos_x, pos_y, pos_z}, {})
					end
					team[t].step = 1
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
						-- random search
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							if table.getn(Spring.GetUnitCommands(u)) == 0 then
								local pos_x = math.random(Game.mapSizeX-1)
								local pos_z = math.random(Game.mapSizeZ-1)
								Spring.GiveOrderToUnit(u, CMD.MOVE, {pos_x, Spring.GetGroundHeight(pos_x, pos_z), pos_z}, {})
							end
						end
					else
						-- order units to attack the nearest enemy unit
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							local myPos_x, myPos_y, myPos_z = Spring.GetUnitPosition(u)
							local distance = Game.mapSizeX*Game.mapSizeX+Game.mapSizeZ*Game.mapSizeZ
							local select = -1
							for _,e in ipairs(enemy) do
								local enPos_x, enPos_y, enPos_z = Spring.GetUnitPosition(e)
								local dx = myPos_x - enPos_x
								local dz = myPos_z - enPos_z
								if dx*dx+dz*dz < distance then
									distance = dx*dx+dz*dz
									select = e
								end
							end
							if select ~= -1 then
								-- order unit to attack selected unit only if
								-- it doesn't attack it already
								local commandQueue = Spring.GetUnitCommands(u)
								local attack = true
								if commandQueue ~= nil and table.getn(commandQueue) > 0 then
									if commandQueue[1].id == CMD.ATTACK then
										if commandQueue[1].param ~= nil and table.getn(commandQueue[1].param) == 1 then
											if select == commandQueue[1].param[1] then
												attack = false
											end
										end
									end
								end
								if attack then
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
