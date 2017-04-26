
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
				neverSeen=true,
				target={x=-1, z=-1},
				formation = {},
				direction = 1,
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
					if team[t].neverSeen == true then
						-- move to ennemy position in formation
						local barX = 0
						local barZ = 0
						local cpt = 0
						-- compute barycenter of my units
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							local pos_x, pos_y, pos_z = Spring.GetUnitPosition(u)
							barX = barX + pos_x
							barZ = barZ + pos_z
							cpt =  cpt + 1
						end
						if cpt ~= 0 then
							barX = barX / cpt
							barZ = barZ / cpt
						end
						if team[t].target.x == -1 then
							-- set target
							team[t].target.x = Game.mapSizeX-barX
							team[t].target.z = Game.mapSizeZ
							-- fill table
							for _,u in ipairs(Spring.GetTeamUnits(t)) do
								local pos_x, pos_y, pos_z = Spring.GetUnitPosition(u)
								team[t].formation[u] = {pos_x-barX, pos_z-barZ}
							end
							-- determine direction
							if barX < Game.mapSizeX / 2 then
								team[t].direction = 1
							else
								team[t].direction = -1
							end
						else
							if math.abs(barX-team[t].target.x) < 500 and math.abs(barZ-team[t].target.z) < 500 then
								team[t].neverSeen = false
							else
								for _,u in ipairs(Spring.GetTeamUnits(t)) do
									local shift = 100
									-- increase shift if unit is an armfig (plane)
									if Spring.GetUnitDefID(u) == 68 then
										shift = 300
									end
									local pos_x = barX+team[t].formation[u][1]+(shift*team[t].direction)
									local pos_z = barZ+team[t].formation[u][2]
									Spring.GiveOrderToUnit(u, CMD.MOVE, {pos_x, Spring.GetGroundHeight(pos_x, pos_z), pos_z}, {})
								end
							end
						end
					else
						-- random search
						for _,u in ipairs(Spring.GetTeamUnits(t)) do
							if table.getn(Spring.GetUnitCommands(u)) == 0 then
								local pos_x = math.random(Game.mapSizeX-1)
								local pos_z = math.random(Game.mapSizeZ-1)
								Spring.GiveOrderToUnit(u, CMD.MOVE, {pos_x, Spring.GetGroundHeight(pos_x, pos_z), pos_z}, {})
							end
						end
					end
				else
					team[t].neverSeen = false
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

function gadget:GameOver()
	for _,t in ipairs(team) do
		t.underControl = false
	end
end

end
