
-- In-game, type /luarules kpai in the console to toggle the ai debug messages

function gadget:GetInfo()
	return {
		name = "Invasion AI",
		desc = "You have no chance to survive make your time!!",
		author = "KDR_11k (David Becker), modified by zwzsg",
		date = "2010-11-20",
		license = "Public Domain",
		layer = 82,
		enabled = true
	}
end

local STATE_EMPTY    =0
local STATE_OWN      =1
local STATE_ENEMY    =2
local STATE_HOMEBASE =3 -- Not used anymore
local STATE_LOCKED   =4

if (gadgetHandler:IsSyncedCode()) then

--SYNCED
VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
VFS.Include("LuaRules/Gadgets/new_cmd_id.lua",nil)

local teamData={}
local unitPos={}
local spots={}

local orders={}
local minifacCreated={}

local minifacLimit=4 --Number of minifacs a player must be down to before the AI will attack his homebase

local firstWaveDelay = 60*30 --Additional time until the first wave is announced
local waveInterval=180*30 --Delay after last wave before a new one is announced
local waveWarning=90*30 --Delay between announcement and dispatching of a wave
local aggroWaveMult=3 --aiAggression takes this many points off the wave interval
local waveUnitTypes=3 --Number of unit types dispatched per wave
local waveWeights= { --How many "points" each unit costs in a wave, more points = fewer units per wave
	[bit]=.1,
	[bug]=.1,
	[packet]=.07,
	[byte]=1,
	[worm]=1.5,
	[connection]=1.2,
	[pointer]=1,
	[flow]=.3,
	[dos]=.2,
	[signal]=15,
}
local waveUnits = { --Unit types that are valid for waves
	bit, bug, packet, byte, worm, connection, pointer, flow, dos, signal,
}

local aiAggression=1 --How much the invasion AI will attack the players (variable)
local minifacKillAggro= 2 --How much a minifac kill increases the AI agression
local homebaseKillAggro = 10 --How much killing an AI homebase will increase AI aggression
--local superWeaponAggro = 3 --Aggro penalty for using a superweapon
local armyAggro = { --Aggression penalties for building specific units
	[byte] = .2,
	[pointer] = .15,
	[flow] = .05,
	[connection] = .3,
	[worm] = .15,
	[terminal] = 5,
	[firewall] = 6,
	[obelisk] = .5, --The Obelisk isn't map-wide so replacements are necessary
}

local InvasionHomeBase = {
	kernel,hole,carrier,
}

local InvasionMiniFac = {
	socket,window,port,
}

local dispatchTimer={}
dispatchCoolDown = 5 -- in seconds
dispatchRange = 300

local lastFeatureBusting={}

local teamBufferSize=0

local PositionsStatesChanged=true

local KPAI_Debug_Mode=0 -- Must be 0 or 1

local weirdFactions=false
if math.random(47)==9 then
	weirdFactions=true
else
	weirdFactions=false
end

local MaxUnits=Game.maxUnits -- 10000 not matter what the unitlimit
if Spring.GetModOptions and Spring.GetModOptions()["maxunits"] then
	MaxUnits=tonumber(Spring.GetModOptions()["maxunits"])
end

local function ChangeAIDebugVerbosity(cmd,line,words,player)
	local lvl=tonumber(words[1])
	if lvl then
		KPAI_Debug_Mode=lvl
		Spring.Echo("KPAI debug verbosity set to "..KPAI_Debug_Mode)
	else
		if KPAI_Debug_Mode>0 then
			KPAI_Debug_Mode=0
		else
			KPAI_Debug_Mode=1
		end
		Spring.Echo("KPAI debug verbosity toggled to "..KPAI_Debug_Mode)
	end
	return true
end

local function SetupCmdChangeAIDebugVerbosity()
	local cmd,func,help
	cmd  = "invkpai"
	func = ChangeAIDebugVerbosity
	help = " [0|1]: make the KP LUA AI shut up or fill your infolog"
	gadgetHandler:AddChatAction(cmd,func,help)
	Script.AddActionFallback(cmd..' ',help)
end

local function KPAIDebugMessage(t,message)
	if(KPAI_Debug_Mode>0) then
		Spring.Echo("Team["..t.."] "..message)
	end
end

function gadget:Initialize()
	bufferSize = GG.bufferSize -- Network faction special ressource
	SetupCmdChangeAIDebugVerbosity()
end


local function RemoveSelfIfNoTeam()
	local AIcount=0
	for t,td in pairs(teamData) do
		AIcount=AIcount+1
	end
	if(AIcount==0) then -- #teamData is 0 even when there are teams, and teamData=={} is untrue even when teamData={}
		KPAIDebugMessage("none",gadget:GetInfo().name.." removing self")
		gadgetHandler:RemoveGadget()
		return true
	end
	return false
end

function gadget:GameStart()
	KPAIDebugMessage(gadget:GetInfo().name," GameStart!")

	-- In ONS must kill all sockets before attacking kernel
	if Spring.GetModOptions().ons and Spring.GetModOptions().ons ~= "0" then
		minifacLimit=1
	end

	-- Create tables of Geos
	for _,f in ipairs(Spring.GetAllFeatures()) do
		if FeatureDefs[Spring.GetFeatureDefID(f)].name == "geovent" then
			local x,y,z = Spring.GetFeaturePosition(f)
			--Merging algorithm because some KP maps have multiple geos in one spot
			local newSpot=true
			for i,s in pairs(spots) do
				if math.sqrt((x-s.x)*(x-s.x) + (z-s.z)*(z-s.z)) < 64 then
					newSpot = false
					break
				end
			end
			if newSpot then
				table.insert(spots, {x=x, y=y, z=z})
			end
		end
	end

	local aiCount=0
	local aiTeams={}
	local secondaryBasePos = {}
	-- Initialise AI for all team that are set to use it
	for _,t in ipairs(Spring.GetTeamList()) do
		local _,_,_,ai,side = Spring.GetTeamInfo(t)
		Spring.Echo(Spring.GetTeamLuaAI(t))
		if Spring.GetTeamLuaAI(t)==gadget:GetInfo().name then
			local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(t)
			if (not CustomTeamOptions) or (not CustomTeamOptions["aioverride"]) then
				aiCount = aiCount + 1
				aiTeams[aiCount] = t
				KPAIDebugMessage(t," assigned to "..gadget:GetInfo().name)
				local pos={}
				local home_x,home_y,home_z = Spring.GetTeamStartPosition(t)
				pos[0]={x=home_x, y=home_y, z=home_z, dist=0, state=HOMEBASE, spams = 0, underConstruction=false}
				for i,s in pairs(spots) do
					local dist = math.sqrt((home_x-s.x)*(home_x-s.x) + (home_z-s.z)*(home_z-s.z))
					if dist >= 64 then
						table.insert(pos,{x=s.x, y=s.y, z=s.z,dist = dist, state = STATE_EMPTY, spams = 0, underConstruction=false})
					end
				end
				for i,_ in pairs(pos) do
					KPAIDebugMessage(t,"pos["..i.."] @(x="..math.floor(pos[i].x)..",z="..math.floor(pos[i].z)..") dist="..math.floor(pos[i].dist))
				end
				if #pos==0 then
					table.insert(pos,pos[0]) -- just to prevent bug on geoless maps
				end
				local _,_,_,_,_,at = Spring.GetTeamInfo(t)
				teamData[t]= {
					positions=pos,
					missions={},
					constructors={},
					factories={},
					dangers={},
					threatRating=0,
					com={},
					waveTime=firstWaveDelay,
					nextWave=nil,
					lastMove=0,
					forceSize=0,
					allyTeam=at,
					lastNuke=0,
					no_more_enemies_since=0,
					lastAllyDamage=nil,
				}
			end
		end
	end

	-- RemoveSelfIfNoTeam() -- Somehow gadgetHandler:RemoveGadget() remove other gadgets when executed at GameStart stage. Moved to GameFrame
end



--Make this AI occupy all spots right from the start
local function BuildOnAllFreeSpots()

	local function IsFree(testedX,testedZ)
		for _,anyteam in ipairs(Spring.GetTeamList()) do
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(anyteam,AnyBuilding)) do
				local ux,_,uz=Spring.GetUnitPosition(u)
				if math.abs(ux - testedX)<256 and math.abs(uz - testedZ)<256 then
					return false
				end
			end
		end
		return true
	end

	local aiCount=0
	local aiTeams={}
	local secondaryBasePos = {}

	-- Recreate aiCount and aiTeams (yeah they could be stored instead)
	for _,t in ipairs(Spring.GetTeamList()) do
		if teamData[t] then
			aiCount = aiCount + 1
			aiTeams[aiCount] = t
			local secondaryBases = 2
			local failure = 0
			while secondaryBases > 0 and failure < 200 do
				local pickedSpot = math.random(#spots)
				if not secondaryBasePos[pickedSpot] and IsFree(spots[pickedSpot].x,spots[pickedSpot].z) then
					secondaryBasePos[pickedSpot] = t
					secondaryBases = secondaryBases -1
				else
					failure = failure +1
				end
			end
		end
	end

	if aiCount>0 then
		for i, spot in pairs(spots) do
			if IsFree(spot.x,spot.z) then 
				if secondaryBasePos[i] then
					--Place secondary homebase
					local targetTeam = secondaryBasePos[i]
					local facType = math.random(#InvasionHomeBase)
					local nu = Spring.CreateUnit(InvasionHomeBase[facType], spot.x, spot.y, spot.z, 0, targetTeam)
					--Prevent autofire at these units
					Spring.SetUnitNeutral(nu, true)
				else
					--Place minifac
					local targetTeam = aiTeams[math.random(aiCount)]
					local facType = math.random(#InvasionMiniFac)
					local nu = Spring.CreateUnit(InvasionMiniFac[facType], spot.x, spot.y, spot.z, 0, targetTeam)
					--Prevent autofire at these units
					Spring.SetUnitNeutral(nu, true)
				end
			end
		end
	end

end


local function SuicideIfAlone(t)
	if Spring.GetTeamUnitCount(t) and Spring.GetTeamUnitCount(t)>1 then
		local td = teamData[t]
		local living_enemy_teams=0
		for _,ot in ipairs(Spring.GetTeamList()) do	
			if not Spring.AreTeamsAllied(ot,t) then
				local _,_,isDead,isAiTeam,side,_=Spring.GetTeamInfo(ot)
				if not isDead and Spring.GetTeamUnitCount(ot) and Spring.GetTeamUnitCount(ot)>0 then
					KPAIDebugMessage(t,"Other enemy is "..side)
					living_enemy_teams=1+living_enemy_teams
				end
			end
		end
		if living_enemy_teams==0 then
			if (not td.no_more_enemies_since) or (td.no_more_enemies_since==0) then
				td.no_more_enemies_since=Spring.GetGameSeconds()
			else
				if Spring.GetGameSeconds() - td.no_more_enemies_since > 30+(7*t)%16 then
					KPAIDebugMessage(t,"suicide because of loneliness")
					Spring.GiveOrderToUnitArray(Spring.GetTeamUnits(t),CMD.SELFD,{},{})
					td.no_more_enemies_since=7+Spring.GetGameSeconds()
				end
			end
		else
			td.no_more_enemies_since=0
			KPAIDebugMessage(t,"I have enemies!")
		end
	end
end

local function MorphToWeird(t)
	local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(t)
	if CustomTeamOptions and (tonumber(CustomTeamOptions["removeunits"]) or 0)~=0 then
		return
	end
	KPAIDebugMessage(t,"should go 2/3 weird")
	local MorphToWeirdQueue={}
	if math.random(3)~=1 then
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,hole)) do
			table.insert(MorphToWeirdQueue,{unit=u, team=t, target="holeold", LineageRoot=true})
		end
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,window)) do
			table.insert(replaceQueue, {unit=u, team=t, target="windowold" })
		end
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,carrier)) do
			table.insert(MorphToWeirdQueue,{unit=u, team=t, target="thbase", LineageRoot=true})
		end
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,port)) do
			table.insert(replaceQueue, {unit=u, team=t, target="thminifac" })
		end
	end
	for i,u in pairs(MorphToWeirdQueue) do
		local Spring_SetUnitCOBValue = Spring.SetUnitCOBValue or Spring.UnitScript.SetUnitCOBValue
		local x, y, z
		x, y, z = Spring.GetUnitPosition(u.unit)
		nu = Spring.CreateUnit(u.target,x,y,z,0,u.team)
		Spring.SetUnitBlocking(nu, false)
		Spring_SetUnitCOBValue(nu, 82, Spring.GetUnitHeading(u.unit))
		Spring.SetUnitHealth(nu, Spring.GetUnitHealth(u.unit) / UnitDefs[Spring.GetUnitDefID(u.unit)].health * UnitDefs[Spring.GetUnitDefID(nu)].health)
		local c = Spring.GetUnitCommands(u.unit,0xFFFF)
		for i = 1, #n do
			Spring.GiveOrderToUnit(nu, c[i].id, c[i].params, c[i].options.coded)
		end
		if u.LineageRoot then
			Spring.SetUnitLineage(nu,u.team,true)
		end
		Spring.DestroyUnit(u.unit, false, true, u.unit)
		MorphToWeirdQueue[i] = nil
	end
end

local function SelectForceFor(t,pos)
	local spams=5
	local cnstrs=1
	local heavies=1
	local arties=1
	local crowdedarea=0
	local td = teamData[t]
	local p = td.positions[pos]
	if bufferSize and bufferSize[t] then
		teamBufferSize=bufferSize[t]
	else
		teamBufferSize=0
	end
	if p.state == STATE_ENEMY then
		local ts={}
		for _,t in ipairs(Spring.GetTeamList()) do
			local _,_,_,_,_,at = Spring.GetTeamInfo(t)
			if at ~= td.allyTeam then
				table.insert(ts,t)
			end
		end
		local es = #Spring.GetUnitsInCylinder(p.x,p.z,300)--,t)
		cnstrs=0
		spams = 20 + .2 * (td.forceSize+teamBufferSize)
		arties = math.random(2)
		heavies = 1+ math.floor(es / 15)
		if es > 15 then
			crowdedarea=1
		end
	elseif p.state == STATE_LOCKED then
		spams=0
		cnstrs=0
		heavies=0
		arties=0
		crowdedarea=0
	elseif p.state == STATE_EMPTY then
		if p.underConstruction == false then
			cnstrs = 1
		else
			cnstrs = 0
		end
		heavies = 2
		spams = 20 - p.spams
		arties = math.random(1)
	end
	return cnstrs, spams, heavies, arties, crowdedarea
end

local function GetAttackPositionsFor(t,x,z)
	local ps={}
	for i,p in pairs(teamData[t].positions) do
		local d = math.sqrt((x-p.x)*(x-p.x) + (z-p.z)*(z-p.z))
		if p.state == STATE_OWN then
			if p.spams > .003 * d then
				table.insert(ps, i)
			end
		elseif p.state == STATE_EMPTY then
			if p.spams > 10 and d < 1500 then
				table.insert(ps, i)
			end
		elseif p.state == STATE_HOMEBASE then
			table.insert(ps, i)
		end
	end
	return ps
end

local function GetWeightFor(t,pos)
	local td = teamData[t]
	local p = td.positions[pos]
	local w = 1.0
	if p.dist < 64 and p.state ~= STATE_HOMEBASE then
		return 0
	end
	--Must never attack
	if p.state == STATE_ENEMY then
		w = 0 --(1.0 + 1/p.dist) * (1+td.forceSize)
	elseif p.state == STATE_LOCKED then
		w = 0 --(0.3 + 1/p.dist) * (1+td.forceSize)
	elseif p.state == STATE_EMPTY and not p.underConstruction then
		w = 0 --1.0/math.sqrt(p.dist) * (1+td.forceSize)/(10 * p.spams+1)
	else
		w = 1.0
	end
	return w
end

local function IsItOccupiedByAnyHomeBase(testedX,testedZ)
	for _,anyteam in ipairs(Spring.GetTeamList()) do
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(anyteam,HomeBase)) do
			local ux,_,uz=Spring.GetUnitPosition(u)
			if math.abs(ux - testedX)<64 and math.abs(uz - testedZ)<64 then
				return 1
			end
		end
	end
	return nil
end

local function IsItOccupied(testedX,testedZ)
	for _,anyteam in ipairs(Spring.GetTeamList()) do
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(anyteam,AnyBuilding)) do
			local ux,_,uz=Spring.GetUnitPosition(u)
			if math.abs(ux - testedX)<48 and math.abs(uz - testedZ)<48 then
				return 1
			end
		end
	end
	return nil
end

local function GetNiceGeo(t,oriX,oriZ)
	local td = teamData[t]
	local nicest_geo_so_far = nil
	local nicest_geo_dist = 0

	for _=1,math.max(#td.positions/2,2) do
		local p = math.random(#td.positions)
		local pos = td.positions[p]
		if((pos.state==STATE_EMPTY and (not pos.underConstruction) and (not IsItOccupied(pos.x,pos.z))) and ((nicest_geo_so_far==nil) or (pos.dist<=nicest_geo_dist))) then
			nicest_geo_so_far = p
			nicest_geo_dist = math.sqrt((pos.x-oriX)*(pos.x-oriX) + (pos.z-oriZ)*(pos.z-oriZ))
		end
	end

	if not nicest_geo_so_far then
		for _=1,2*#td.positions do
			local p = math.random(#td.positions)
			local pos = td.positions[p]
			if((pos.state~=STATE_OWN and (not pos.underConstruction) and (not IsItOccupied(pos.x,pos.z))) and ((nicest_geo_so_far==nil) or (pos.dist<=nicest_geo_dist))) then
				nicest_geo_so_far = p
				if(pos.state==STATE_EMPTY) then
					nicest_geo_dist = math.sqrt((pos.x-oriX)*(pos.x-oriX) + (pos.z-oriZ)*(pos.z-oriZ))
				else
					nicest_geo_dist = 2*math.sqrt((pos.x-oriX)*(pos.x-oriX) + (pos.z-oriZ)*(pos.z-oriZ))
				end
			end
		end
	end

	return nicest_geo_so_far
end

local function RecalculatePositionsStates(t)
	KPAIDebugMessage(t,"recalculating positions states")
	if Spring.GetModOptions()["ons"]==nil or Spring.GetModOptions()["ons"]=="0" then
		return
	end
	for i,s in pairs(teamData[t].positions) do
		local state = STATE_EMPTY
		for _,team in ipairs(Spring.GetTeamList()) do
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(team,AnyBuilding)) do
				local x,_,z = Spring.GetUnitPosition(u)
				if math.sqrt((x-s.x)*(x-s.x) + (z-s.z)*(z-s.z)) < 64 then
					if t==team or Spring.AreTeamsAllied(team,t) then
						state = STATE_OWN
					else
						state = STATE_ENEMY
						if Spring.GetModOptions()["ons"] and Spring.GetModOptions()["ons"]~="0" then
							if GG.GetUnitONSInfo then
								local UnitExists,Shielded,GreenShield,RedShield,SourceFound,SourceID = GG.GetUnitONSInfo(u)
								if Shielded then
									state = STATE_LOCKED
								end
							end
						end
					end
				end
			end
		end
		teamData[t].positions[i].state=state
	end
end

local function AddSpam(t,u,from)
	KPAIDebugMessage(t,"I got a spam!")

	-- Hook to closest factory if virus or packet or exploit
	if (not Spring.ValidUnitID(from)) or (not isMiniFac[Spring.GetUnitDefID(from)]) then
		KPAIDebugMessage(t,"orphan spam!")
		local closest = nil
		local min_dist = 0
		for _,f in ipairs(Spring.GetTeamUnitsByDefs(t,MiniFac)) do
			if(not closest or Spring.GetUnitSeparation(u,f)<min_dist) then
				closest = f
				min_dist=Spring.GetUnitSeparation(u,f)
			end
		end
		if closest then
			from = closest
			local ud=Spring.GetUnitDefID(u)
			if ud==virus then
				table.insert(orders,{u,CMD.MOVE,{Spring.GetUnitPosition(closest)},{}})
			end
		end
	end

	if from and teamData[t].factories[from] then
		local td = teamData[t]
		local pos = td.factories[from].position
		td.positions[pos].spams = td.positions[pos].spams + 1
		unitPos[u]=pos
	end
end

local function AddMiniFac(t,u)
	local x,_,z = Spring.GetUnitPosition(u)
	for i,s in pairs(teamData[t].positions) do
		if math.sqrt((x-s.x)*(x-s.x) + (z-s.z)*(z-s.z)) < 64 then
			teamData[t].positions[i].state = STATE_OWN
			teamData[t].positions[i].underConstruction = false
			teamData[t].factories[u] = {position = i}
			break
		end
	end
	if Spring.GetUnitDefID(u) ~= port then
		table.insert(orders,{u,CMD.REPEAT,{1},{}})
	end
	if Spring.GetUnitDefID(u) == socket then
		table.insert(orders,{u,-bit,{},{}})
	end
	if Spring.GetUnitDefID(u) == window then
		table.insert(orders,{u,-bug,{},{}})
	end
	if Spring.GetUnitDefID(u) == windowold then
		table.insert(orders,{u,-bugold,{},{}})
	end
	if Spring.GetUnitDefID(u) == thminifac then
		table.insert(orders,{u,-fairy,{},{}})
	end
	if Spring.GetUnitDefID(u) == hand then
		local rps={rock,paper,scissors}
		local dice=math.random(1,6)
		if dice==1 then
			rps={rock,paper,scissors}
		elseif dice==2 then
			rps={rock,scissors,paper}
		elseif dice==3 then
			rps={paper,rock,scissors}
		elseif dice==4 then
			rps={paper,scissors,rock}
		elseif dice==5 then
			rps={scissors,rock,paper}
		elseif dice==6 then
			rps={scissors,paper,rock}
		end
		for i=1,3 do
			for j=1,10 do
				table.insert(orders,{u,-rps[i],{},{}})
			end
		end
	end
end


local function DispatchCon(t,u,p)
	local cux,_,cuz=Spring.GetUnitPosition(u)
	if IsItOccupiedByAnyHomeBase(cux,cuz) then -- Don't start building while the cons is still inside homebase
		KPAIDebugMessage(t,"found idle cons["..u.."] too close to homebase")
		return
	end
	
	-- Blast Feature
	if math.random(1,2)==1 and ((not lastFeatureBusting[u]) or lastFeatureBusting[u]+900<Spring.GetGameFrame()) then
		lastFeatureBusting[u]=Spring.GetGameFrame()
		-- Find closest bustable feature
		local smallest_squared_distance=nil
		local closest_feature=nil
		for _,f in ipairs(Spring.GetAllFeatures()) do
			local fd=FeatureDefs[Spring.GetFeatureDefID(f)]
			if fd.blocking and fd.destructable then
				local x,_,z=Spring.GetFeaturePosition(f)
				local d=(x-cux)*(x-cux)+(z-cuz)*(z-cuz)
				if not smallest_squared_distance or d<smallest_squared_distance then
					closest_feature=f
					smallest_squared_distance=d
				end
			end
		end
		-- Check if a feature was chosen, and if there are no enemy arounds
		if closest_feature and not Spring.GetUnitNearestEnemy(u,math.sqrt(smallest_squared_distance)) then
			-- Find where to build the mineblaster
			local fx,_,fz=Spring.GetFeaturePosition(closest_feature)
			local free_there,mobile_there,feature_there=nil,nil,nil
			for radius=0,400,40 do-- Mineblaster has a range of 512, I wanna try 10 build positions
				local angle=math.random()*2*math.pi
				local x,z=fx+radius*math.cos(angle),fz+radius*math.sin(angle)
				local y=Spring.GetGroundHeight(x,z) or 0
				local facing=math.random(0,3)
				x,y,z=Spring.Pos2BuildPos(mineblaster,x,y,z)
				if x and y and z then
					local blocking,feature=Spring.TestBuildOrder(mineblaster,x,y,z,facing)
					if blocking==1 then -- Mobile unit in the way
						mobile_there=mobile_there or {x,y,z,facing}
					elseif blocking==2 then -- Free to build, maybe reclaimable feature in the way
						if feature then
							feature_there=feature_there or {x,y,z,facing}
						else
							free_there=free_there or {x,y,z,facing}
							break-- Would not find anything better
						end
					end
				end
			end
			local there=free_there or mobile_there or feature_there
			if there then
				KPAIDebugMessage(t,"dispatching idle cons["..u.."] to blast feature at ("..fx..","..fz..")")
				Spring.GiveOrderToUnit(u,-mineblaster,there,{})
				return
			end
			KPAIDebugMessage(t,"idle cons["..u.."] wanted to blast feature at ("..fx..","..fz..") but found no buildspot")
		end
		KPAIDebugMessage(t,"idle cons["..u.."] searched and found no feature to blast"..(closest_feature and " without enemy around" or ""))
	end
	
	-- Build on Datavent
	local geo=GetNiceGeo(t,cux,cuz)
	if geo then
		KPAIDebugMessage(t,"dispatching idle cons["..u.."] to geo["..geo.."]")
		teamData[t].missions[u]=true
		unitPos[u]=geo
		pos=teamData[t].positions[geo]
		local WhatToBuild=nil;
		local ud=Spring.GetUnitDefID(u)
		if ud == assembler then
			WhatToBuild=socket
		end
		if ud == trojan then
			WhatToBuild=window
		end
		if ud == trojanold then
			WhatToBuild=windowold
		end
		if ud == gateway then
			WhatToBuild=port
		end
		if ud == alice then
			WhatToBuild=thminifac
		end
		local ListOfMiniFacs=Spring.GetTeamUnitsByDefs(t,MiniFac)
		if ListOfMiniFacs and #ListOfMiniFacs>= 3 and math.random(3)==1 then
			if ud == assembler then
				WhatToBuild=terminal
			end
			if ud == trojan then
				WhatToBuild=obelisk
			end
			-- I don't feel like letting trojanold build obelisks
			if ud == gateway then
				WhatToBuild=firewall
			end
		end
		if WhatToBuild then
			local dir
			if math.abs(Game.mapSizeX - 2*pos.x) > math.abs(Game.mapSizeZ - 2*pos.z) then
				if (2*pos.x>Game.mapSizeX) then
					dir=3
				else
					dir=1
				end
			else
				if (2*pos.z>Game.mapSizeZ) then
					dir=2
				else
					dir=0
				end
			end
			Spring.GiveOrderToUnit(u,-WhatToBuild,{pos.x,0,pos.z,dir},{})
		end
	else
		KPAIDebugMessage(t,"failed to dispatch con")
	end
end

local function BufferizePacket(t,u)
	local closest = nil
	local min_dist = 0
	for _,f in ipairs(Spring.GetTeamUnitsByDefs(t,port)) do
		if(not closest or Spring.GetUnitSeparation(u,f)<min_dist) then
			closest = f
			mind_dist=Spring.GetUnitSeparation(u,f)
		end
	end
	if closest then
		table.insert(orders,{u,CMD_ENTER,{closest},{"shift"}})
	end
end

local function DispatchSpam(t,u,p)
	local td = teamData[t]
	td.missions[u]=true
	if unitPos[u] then
		td.positions[unitPos[u]].spams = td.positions[unitPos[u]].spams - 1
	end
	unitPos[u] = p
	td.positions[unitPos[u]].spams = td.positions[unitPos[u]].spams + 1
	local phase = math.random(6.3)
	local amp = 40 + math.random(90)
	if Spring.GetUnitDefID(u)==exploit then
		KPAIDebugMessage(t,"Undeploy and dispatch exploit")
		Spring.GiveOrderToUnit(u,CMD_UNDEPLOY,{},{})
		Spring.GiveOrderToUnit(u,CMD.MOVE,{teamData[t].positions[p].x + math.cos(phase)*amp,0,teamData[t].positions[p].z + math.sin(phase)*amp},{"shift"})
	else
		Spring.GiveOrderToUnit(u,CMD.MOVE,{teamData[t].positions[p].x + math.cos(phase)*amp,0,teamData[t].positions[p].z + math.sin(phase)*amp},{})
	end
end

local function DispatchArty(t,u,p,nx)
	local cux,_,cuz=Spring.GetUnitPosition(u)
	if IsItOccupiedByAnyHomeBase(cux,cuz) then -- Don't because too close to homebase, could clog it
		return
	end
	local td = teamData[t]
	td.missions[u]=true
	unitPos[u] = p
	KPAIDebugMessage(t,"dispatching arty "..p)
	if td.positions[p].state == STATE_EMPTY then
		Spring.GiveOrderToUnit(u,CMD.FIGHT,{teamData[t].positions[p].x,0,teamData[t].positions[p].z},{})
	elseif td.positions[p].state == STATE_ENEMY then
		if nx and (Spring.GetUnitDefID(u) == pointer) then
			Spring.GiveOrderToUnit(u,CMD_NX,{teamData[t].positions[p].x - 50 + math.random(100),teamData[t].positions[p].y,teamData[t].positions[p].z - 50 + math.random(100)},{}) --NX flag
		else
			Spring.GiveOrderToUnit(u,CMD.ATTACK,{teamData[t].positions[p].x,teamData[t].positions[p].y,teamData[t].positions[p].z},{})
		end
	end
end

local function DispatchHeavy(t,u,p)
	local td = teamData[t]
	td.missions[u]=true
	unitPos[u] = p
	Spring.GiveOrderToUnit(u,CMD.MOVE,{teamData[t].positions[p].x,0,teamData[t].positions[p].z},{})
end

local function RetreatToGuard(t,u)
	KPAIDebugMessage(t,"Wanna Retreat!")
	local closest = nil
	local min_dist = 0
	for _,f in ipairs(Spring.GetTeamUnitsByDefs(t,AnyBuilding)) do
		if(not closest or Spring.GetUnitSeparation(u,f)<min_dist) then
			closest = f
			mind_dist=Spring.GetUnitSeparation(u,f)
		end
	end
	if closest then
		KPAIDebugMessage(t,"Retreating!")
		table.insert(orders,{u,CMD.GUARD,{closest},{}})
		local x,_,z=Spring.GetUnitPosition(closest)
		for i,s in pairs(teamData[t].positions) do
			if math.sqrt((x-s.x)*(x-s.x) + (z-s.z)*(z-s.z)) < 64 then
				unitPos[u]= i
				break
			end
		end
	end
end


local function GiveTinyMoveOrderTowardCenter(u)
	-- When left to their own device, units produced by factories
	-- Are getting spread by the bugger off, which spread them too far
	-- And in 94.0, units sent to cliff or otherwise impassable terrain
	-- bump repeatdly on it with a speed that's isn't zero
	-- so they are not detected as idle and are not given orders
	-- To fix that, I now give homebase a short move order
	-- hoping it lands on a reachable point.
	local x,y,z=Spring.GetUnitPosition(u)
	local dx,dz=Game.mapSizeX/2-x+math.random(0,8)-4,Game.mapSizeZ/2-z+math.random(0,8)-4
	local function sign(t)
		if t>0 then
			return 1
		else
			return -1
		end
	end
	if math.abs(dx)>math.abs(dz) then
		dx,dz=96*sign(dx),0
	else
		dx,dz=0,96*sign(dz)
	end
	table.insert(orders,{u,CMD.MOVE,{x+dx,Spring.GetGroundHeight(x+dx,z+dz),z+dz},{}})
end

local function OrderHomeBase(u,ud,team)
	if Spring.GetUnitStates(u)["repeat"] then
		table.insert(orders,{u,CMD.REPEAT,{0},{}})
	end
	local cnstr,spam,arty,heavy
	if(ud==kernel) then
		cnstr=assembler
		spam=bit
		arty=pointer
		heavy=byte
	end
	if(ud==hole) then
		cnstr=trojan
		spam=bug
		arty=dos
		heavy=worm
	end
	if(ud==holeold) then
		cnstr=trojanold
		spam=bugold
		arty=dos
		heavy=wormold
	end
	if(ud==carrier) then
		cnstr=gateway
		spam=packet
		arty=flow
		heavy=connection
	end
	if(ud==thbase) then
		cnstr=alice
		spam=fairy
		arty=marisa
		heavy=reimu
	end
	local n = 0
	for _,_ in pairs(teamData[team].constructors) do
		n=n+1
	end
	local r = math.random(1000)
	if r > 1000 - (teamData[team].forceSize+teamBufferSize) * 20 then
		local n = math.random(2)
		if n == 1 then
			table.insert(orders, {
				u,
				-heavy,
				{},
				{},
			})
		else
			table.insert(orders, {
				u,
				-arty,
				{},
				{},
			})
		end
	else
		for i = 1,3 do
			table.insert(orders, {
				u,
				-spam,
				{},
				{},
			})
		end
	end
end

local function BuilderDone(t,u)
	teamData[t].missions[u]=nil
	local ud=Spring.GetUnitDefID(u)
	if isHomeBase[Spring.GetUnitDefID(u)] then
		OrderHomeBase(u,ud,t)
	end
end

local function AddHomeBase(t,u)
	KPAIDebugMessage(t,"I got a com!")
	table.insert(teamData[t].com,u)
	teamData[t].factories[u]={position=0}
	OrderHomeBase(u,Spring.GetUnitDefID(u),t)
end

local function AddConstructor(t,u)
	KPAIDebugMessage(t,"I got a cons!")
	GiveTinyMoveOrderTowardCenter(u)
	teamData[t].constructors[u]={position=0,}
end

local function AttackHomeBase(t,targetTeam)
	KPAIDebugMessage(t,"GO!",t,targetTeam)
	local k = Spring.GetTeamUnitsByDefs(targetTeam,HomeBase)[1]
	local td = teamData[t]
	if k then
		KPAIDebugMessage(t,"GO!GO!GO!")
		for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,spam)) do
			if Spring.GetUnitDefID(u)~=exploit and not td.missions[u] then
				td.missions[u]=true
				if unitPos[u] then
					td.positions[unitPos[u]].spams = td.positions[unitPos[u]].spams - 1
				end
				unitPos[u] = nil
				Spring.GiveOrderToUnit(u,CMD.ATTACK,{k},{})
			end
		end
	end
end

function gadget:UnitCreated(u,ud,team,builder)
	if isAnyBuilding[ud] then
		PositionsStatesChanged=true
	end
	if isSmallBuilding[ud] then
		local pos = nil
		local x,_,z = Spring.GetUnitPosition(u)
		for t,td in pairs(teamData) do
			for i,s in pairs(td.positions) do
				if math.sqrt((x-s.x)*(x-s.x) + (z-s.z)*(z-s.z)) < 64 then
					pos = i
					break
				end
			end
			if pos then
				local at = Spring.GetUnitAllyTeam(u)
				if t ~= team then
					if at ~= td.allyTeam then
						td.positions[pos].state=STATE_ENEMY
					else
						td.positions[pos].state=STATE_OWN
					end
				end
			end
		end
	elseif (isSpam[ud]) and teamData[team] then
		AddSpam(team,u,builder)
	elseif isHomeBase[ud] and teamData[team] then
		--Invasion AI homebases are extremely resilient
		Spring.SetUnitMaxHealth(u, 400000)
		Spring.SetUnitHealth(u, 400000)
	end
end

function gadget:UnitDamaged(u,ud,team,damage,para,weapon,proj,attacker,aud,ateam)
	if damage<0.5 then
		return
	end
	if aud and not ateam then-- Fix to add retrocompatibility with engine older than 95
		attacker, aud, ateam = proj, attacker, aud
	end
	if isHeavy[aud] and teamData[team] and not teamData[team].dangers[attacker] then
		if teamData[team].allyTeam ~= Spring.GetUnitAllyTeam(attacker) then
			local x,_,z = Spring.GetUnitPosition(attacker)
			teamData[team].dangers[attacker]={ud = aud, x = x, z = z}
		end
	end
	if isTeleporter[ud] and teamData[team] then
		if attacker and Spring.ValidUnitID(attacker) and Spring.GetUnitSeparation(u,attacker)<=dispatchRange then
			if bufferSize and bufferSize[team] then
				teamBufferSize=bufferSize[team]
			else
				teamBufferSize=0
			end
			if teamBufferSize>=3 and Spring.GetTeamUnitCount(team)+12<=MaxUnits then
				if (dispatchTimer[u]==nil) or Spring.GetGameSeconds()>dispatchCoolDown+dispatchTimer[u] then
					dispatchTimer[u]=Spring.GetGameSeconds()
					table.insert(orders,{u,CMD_DISPATCH,{Spring.GetUnitPosition(attacker)},{}})
					KPAIDebugMessage(team,"Counter Damage Dispatch!")
					if old_queue and old_queue[1] then -- Looks like I removed the line creating old_queue, making this "if" useless
						table.insert(orders,{u,old_queue[1].params,{"shift"}})
					end
				end
			end
		end
	end
	for t,td in pairs(teamData) do
		if Spring.AreTeamsAllied(team,t) then
			local x,y,z=Spring.GetUnitPosition(u)
			teamData[t].lastAllyDamage={x=x,y=y,z=z,t=Spring.GetGameSeconds()}
			-- KPAIDebugMessage(t,"got damage at {x="..math.floor(x).." ,y="..math.floor(y).." ,z="..math.floor(z).." ,t="..math.floor(teamData[t].lastAllyDamage.t).." }")
		end
	end
end

function gadget:UnitFinished(u, ud, team, builder)
	if isAnyBuilding[ud] then
		PositionsStatesChanged=true
	end
	if teamData[team] then
		teamData[team].forceSize = teamData[team].forceSize + 1
		if isHomeBase[ud] then
			AddHomeBase(team,u)
		elseif isCons[ud] then
			AddConstructor(team,u)
		elseif isMiniFac[ud] then
			AddMiniFac(team,u)
		end
	else
		if armyAggro[ud] then
			aiAggression = aiAggression + armyAggro[ud]
		end
	end
end

function gadget:UnitDestroyed(u,ud,team)
	if isAnyBuilding[ud] then
		PositionsStatesChanged=true
	end
	if teamData[team] then
		local td = teamData[team]
		td.forceSize = td.forceSize - 1
		if isHomeBase[ud] then
			aiAggression = aiAggression + homebaseKillAggro
			for ii,iu in ipairs(td.com) do
				if iu==u then
					td.com[ii]=nil
				end
			end
		elseif isMiniFac[ud] then
			aiAggression = aiAggression + minifacKillAggro
			if td.factories[u] then
				local pos = td.factories[u].position
				td.factories[u]=nil
				if td.positions[pos].spams <= 0 then
					td.positions[pos].state=STATE_ENEMY
				else
					td.positions[pos].state=STATE_EMPTY
				end
			end
		elseif isSpam[ud] then
			if unitPos[u] then
				local pos = unitPos[u]
				unitPos[u]=nil
				td.positions[pos].spams = td.positions[pos].spams - 1
				KPAIDebugMessage(team,"Lost a spam!")
				if td.positions[pos].spams <= 0 and td.positions[pos].state == STATE_EMPTY then
					td.positions[pos].state = STATE_ENEMY
				end
			end
		elseif isCons[ud] then
			if unitPos[u] then
				local pos = unitPos[u]
				td.positions[pos].underConstruction=false
				td.constructors[u]=nil
				unitPos[u]=nil
				if td.positions[pos].spams <= 0 and td.positions[pos].state == STATE_EMPTY then
					td.positions[pos].state = STATE_ENEMY
				end
			end
			if lastFeatureBusting[u] then
				lastFeatureBusting[u]=nil
			end
		end
		td.missions[u]=nil
	end
	for i,o in pairs(orders) do
		if o[1]==u then
			orders[i]=nil
		end
	end
	dispatchTimer[u]=nil
end

function gadget:UnitTaken(u,ud,team,newteam)
	if isAnyBuilding[ud] then
		PositionsStatesChanged=true
	end
end

function gadget:UnitGiven(u,ud,team,oldteam)
	if isAnyBuilding[ud] then
		PositionsStatesChanged=true
	end
end

function gadget:GameFrame(f)

	--Probably better not to interfere like that here
	--[[if f==1 then
		if weirdFactions then
			for t,td in pairs(teamData) do
				MorphToWeird(t)
			end
		end
		-- This is for the starting hand in R.P.S. :
		for t,td in pairs(teamData) do
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,MiniFac)) do
				local fc = Spring.GetFactoryCommands(u,1)
				if fc and #fc < 1 then
					AddMiniFac(t,u)
				end
			end
		end
	end--]]

	for i,o in pairs(orders) do
		if orders[i][5]==2 then -- delete that order in case displaying it causes error
			orders[i]=nil
		elseif orders[i][5]==1 then -- display that order in case executing it causes error
			orders[i][5]=2
			Spring.Echo("Spring.GiveOrderToUnit(",o[1],o[2],o[3],o[4],")")
			local cmd_name=o[2]
			for name,cmd in pairs(CMD) do
				if cmd == o[2] then
					cmd_name = name
				end
			end
 			Spring.Echo(UnitDefs[Spring.GetUnitDefID(o[1])].name.." given invalid "..cmd_name.." order")
		elseif Spring.ValidUnitID(o[1]) and not Spring.GetUnitIsDead(o[1]) then
			orders[i][5]=1
			Spring.GiveOrderToUnit(o[1],o[2],o[3],o[4])
		else
			KPAIDebugMessage("all","attempted to give order to ID="..o[1].." non-existant unit")
		end
		orders[i]=nil
	end
	
	_G.teamData=teamData
	_G.KPAI_Debug_Mode=KPAI_Debug_Mode

	if f==24 then
		BuildOnAllFreeSpots()
	end

	-- AI update
	if f % 128 < .1 then
		if RemoveSelfIfNoTeam() then
			return
		end
		for t,td in pairs(teamData) do
			KPAIDebugMessage(t,gadget:GetInfo().name..": I live!")
			if bufferSize and bufferSize[t] then
				teamBufferSize=bufferSize[t]
			else
				teamBufferSize=0
			end
			td.threatRating = td.threatRating * .95
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,HomeBase)) do
				local known=false
				for ii,iu in ipairs(td.com) do
					if iu==u then
						known=true
					end
				end
				if not known then
					AddHomeBase(t,u);
				end
			end
			for _,com in ipairs(td.com) do
				local fc = Spring.GetFactoryCommands(com,1)
				if fc and #fc < 1 then
					OrderHomeBase(com,Spring.GetUnitDefID(com),t)
				end
			end
			if PositionsStatesChanged then
				RecalculatePositionsStates(t)
			end
			for u,_ in pairs(td.missions) do
				local c = Spring.GetUnitCommands(u,1)
				if isArty[Spring.GetUnitDefID(u)] then
					if td.missions[u] == true and td.missions[u] ~= "busy" then
						KPAIDebugMessage(t,"toot")
						local p = unitPos[u]
						if p and td.positions[p] and td.positions[p].state ~= STATE_ENEMY then
							if td.positions[p].state ~= STATE_LOCKED then
								Spring.GiveOrderToUnit(u,CMD.FIGHT,{teamData[t].positions[p].x,0,teamData[t].positions[p].z},{})
							else
								RetreatToGuard(t,u)
							end
							td.missions[u]=nil
						end
					else
						if c and #c < 1 then
							td.missions[u]=nil
						end
					end
				else
					if c and #c < 1 then
						td.missions[u]=nil
					end
				end
			end
			for d,dd in pairs(td.dangers) do
				for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,arty)) do
					if td.missions[u]~="busy" then
						local x,_,z = Spring.GetUnitPosition(u)
						if math.sqrt((x-dd.x)*(x-dd.x) + (z-dd.z)*(z-dd.z)) < 2000 then
							local cux,_,cuz=Spring.GetUnitPosition(u)
							if not IsItOccupiedByAnyHomeBase(cux,cuz) then -- Don't because too close to homebase, could clog it
								Spring.GiveOrderToUnit(u,CMD.ATTACK,{d},{})
								td.missions[u]="busy"
							end
							break
						end
					end
				end
				td.dangers[d]=nil
			end
			for _,p in pairs(td.positions) do
				if p.state == STATE_ENEMY then
					local enemies = false
					for _,u in ipairs(Spring.GetUnitsInCylinder(p.x,p.z,160)) do
						if Spring.GetUnitAllyTeam(u) ~= td.allyTeam then
							enemies = true
							break
						end
					end
					if not enemies then
						p.state = STATE_EMPTY
					end
				end
			end
			--[[if td.forceSize+teamBufferSize > 50 and math.random(5) == 1 then
				local tl = Spring.GetTeamList()
				local m =math.random(#tl-1)
				local target = tl[m] --not gaia
				KPAIDebugMessage(t,m,target,#tl)
				local _,_,_,_,_,at = Spring.GetTeamInfo(target)
				KPAIDebugMessage(t,"allies",at,td.allyTeam)
				if at ~= td.allyTeam then
					local ListOfSmallBuildings=Spring.GetTeamUnitsByDefs(target,SmallBuilding)
					if ListOfSmallBuildings and #ListOfSmallBuildings<minifacLimit then
						AttackHomeBase(t,target)
					end
				end
			end--]]
			for _=1,1+(td.forceSize+teamBufferSize)*.02 do
				local maxWeight = -10
				local sp = nil
				for i=1,math.max(#td.positions/3,2) do
					local p = math.random(#td.positions)
					-- KPAIDebugMessage(t,"testing spot["..p.."] weight="..GetWeightFor(t,p))
					if GetWeightFor(t,p) > maxWeight then
						maxWeight=GetWeightFor(t,p)
						sp = p
					end
				end
				if sp then
					KPAIDebugMessage(t,"likes spot "..sp)
					local cnstrs, spams, heavies, arties, crowdedarea = SelectForceFor(t,sp)
					--if cnstrs > 0 then
					--	for i,_ in pairs(td.constructors) do
					--		if not td.missions[i] then
					--			-- DispatchCon(t,i,sp)
					--			break
					--		end
					--	end
					--end
					if spams > 0 then
						for _,p in ipairs(GetAttackPositionsFor(t,td.positions[sp].x,td.positions[sp].z)) do
							for _,u in ipairs(Spring.GetUnitsInCylinder(td.positions[p].x, td.positions[p].z, 300, t)) do
								if Spring.GetUnitDefID(u)==port and Spring.GetTeamUnitCount(t)+12<=MaxUnits then
									Spring.GiveOrderToUnit(u,CMD_DISPATCH,{teamData[t].positions[p].x,0,teamData[t].positions[p].z},{})
									spams = spams - math.min(teamBufferSize,12)
									teamBufferSize=math.max(0,teamBufferSize-12)
									if spams <= 0 then
										break
									end
								end
								if isSpam[Spring.GetUnitDefID(u)] and Spring.GetUnitDefID(u)~=exploit and not td.missions[u] then
									DispatchSpam(t,u,sp)
									spams = spams - 1
									if spams <= 0 then
										break
									end
								end
							end
						end
					end
					local spt = td.positions[sp].state
					if arties > 0 then
						for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,arty)) do
							if not td.missions[u] or (td.missions[u]==true and spt==STATE_ENEMY) then
								DispatchArty(t,u,sp,crowdedarea > 0)
								arties=arties-1
								if arties <=0 then
									break
								end
							end
						end
					end
					if heavies > 0 then
						for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,heavy)) do
							if not td.missions[u] then
								DispatchHeavy(t,u,sp)
								heavies=heavies-1
								if heavies <=0 then
									break
								end
							end
						end
					end
					if crowdedarea > 0 and td.lastNuke < f - 15*30 then
						KPAIDebugMessage(t,"wanna nux")
						for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,terminal)) do
							if not GG.rechargeList[u] then
								td.lastNuke=f
								KPAIDebugMessage(t,"Did nux!")
								Spring.GiveOrderToUnit(u, CMD_AIRSTRIKE, {td.positions[sp].x, td.positions[sp].y, td.positions[sp].z}, {})
								break
							end
						end
					end
					for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,obelisk)) do
						if not GG.rechargeList[u] then
							local target=Spring.GetUnitNearestEnemy(u,1500)
							if target then
								KPAIDebugMessage(t,"Did lisk!")
								local x,y,z = Spring.GetUnitPosition(target)
								Spring.GiveOrderToUnit(u, CMD.ATTACK, {x,y,z}, {})
								break
							end
						end
					end
					for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,firewall)) do
						if not GG.rechargeList[u] then
							if td.lastAllyDamage then
								if td.lastAllyDamage.t > Spring.GetGameSeconds()+6 then
									td.lastAllyDamage=nil
								end
							end
							if td.lastAllyDamage then
								local x=td.lastAllyDamage.x
								local y=td.lastAllyDamage.y
								local z=td.lastAllyDamage.z
								local alliedUnitsNear=0
								local enemyUnitsNear=0
								for _,uic in ipairs(Spring.GetUnitsInCylinder(x,z,300)) do
									if Spring.GetUnitAllyTeam(uic) == Spring.GetUnitAllyTeam(u) then
										alliedUnitsNear=alliedUnitsNear+1
										if _G.protected[uic] then
											alliedUnitsNear=0
											break
										end
									end
								end
								for _,uic in ipairs(Spring.GetUnitsInCylinder(x,z,500)) do
									if not Spring.AreTeamsAllied(Spring.GetUnitTeam(uic),Spring.GetUnitTeam(u)) then
										enemyUnitsNear=enemyUnitsNear+1
									end
								end
								KPAIDebugMessage(t,"Wanna wall!")
								if enemyUnitsNear>=3 and alliedUnitsNear>=7 then
									KPAIDebugMessage(t,"Did wall!")
									Spring.GiveOrderToUnit(u, CMD_FIREWALL, {x,y,z}, {})
									td.lastAllyDamage=nil
									break
								end
							end
						end
					end
					td.lastMove=f
				end
			end
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,cons)) do
				--local c = Spring.GetUnitCommands(u,2)
				local vx,_,vz=Spring.GetUnitVelocity(u)
				-- if ((not c) or #c<2) then
				if vx*vx+vz*vz<=0.0001 and not Spring.GetUnitIsBuilding(u) then
					KPAIDebugMessage(t,"found idle cons["..u.."], dispatching it.")
					DispatchCon(t,u,0)
				end
			end
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,packet)) do
				local c = Spring.GetUnitCommands(u,1)
				local vx,_,vz=Spring.GetUnitVelocity(u)
				if vx*vx+vz*vz<=0.0001 and ((not c) or #c<1) then
					if Spring.GetUnitNearestEnemy(u,250)==nil then
						-- KPAIDebugMessage(t,"found idle packet["..u.."], buffering it.")
						-- BufferizePacket(t,u)
					end
				end
			end
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,{worm,wormold})) do
				local firestate=Spring.GetUnitStates(u).firestate
				if(firestate~=2) then
					KPAIDebugMessage(t,"found worm["..u.."] in firestate="..firestate)
					Spring.GiveOrderToUnit(u,CMD.FIRE_STATE,{2},{})
				end
			end
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,exploit)) do
				local target=Spring.GetUnitNearestEnemy(u,1100)
				if (not target) or Spring.GetUnitSeparation(u,target)<500 then
					KPAIDebugMessage(t,"Undeploy")
					Spring.GiveOrderToUnit(u,CMD_UNDEPLOY,{},{})
				end
			end
			for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,bug)) do
				local c = Spring.GetUnitCommands(u,1)
				local x,_,z=Spring.GetUnitPosition(u)
				if ((not c) or #c<1) and not IsItOccupied(x,z) then
					local target=Spring.GetUnitNearestEnemy(u,1000)
					if target and (Spring.GetUnitSeparation(u,target)>600) then
						KPAIDebugMessage(t,"bombard!")
						td.missions[u]=true
						Spring.GiveOrderToUnit(u,CMD_DEPLOY,{},{})
					end
				end
			end
			--Check if we should announce a wave
			if not td.nextWave and td.waveTime + waveInterval < f + aiAggression*aggroWaveMult then
				td.nextWave={}
				for _,target in ipairs(Spring.GetTeamList()) do
					if select(6,Spring.GetTeamInfo(target)) ~= td.allyTeam and target ~= Spring.GetGaiaTeamID() then
						--Announce one for every non-allied player
						local x,y,z
						local targetBuildings = Spring.GetTeamUnitsByDefs(target, MiniFac)
						if #targetBuildings < minifacLimit then
							--Add the homebase to the target list if the enemy is weak enough
							local u = Spring.GetTeamUnitsByDefs(target,HomeBase)[1]
							targetBuildings[#targetBuildings+1]=u
						end
						if #targetBuildings > 0 then
							--Pick a building at random for the wave to attack
							local targetBuilding = targetBuildings[math.random(#targetBuildings)]
							x,y,z = Spring.GetUnitBasePosition(targetBuilding)
							td.nextWave[target] = {x=x,y=y,z=z}
						end
					end
				end
				td.waveTime=f + waveWarning
			--Dispatch waves!
			elseif td.nextWave and td.waveTime <= f then
				for target,wave in pairs(td.nextWave) do
					--Send units
					Spring.Echo("Wave on its way!!!")
					local location = {wave.x,wave.y,wave.z}
					for unitType = 0,waveUnitTypes do
						local waveType = waveUnits[math.random(#waveUnits)]
						local units = Spring.GetTeamUnitsByDefs(t,waveType)
						local toSend = math.floor(aiAggression / waveWeights[waveType])
						local healthBonus = UnitDefs[waveType].health * math.max(1,aiAggression /10) --Health bonus for wave units at high aggression levels
						local failures = 0
						local position
						--Pick a position for spawning
						while failures < 50 do
							position = td.positions[math.random(#td.positions)]
							if position.state == STATE_OWN then
								break
							else
								failures = failures +1
							end
						end
						--Send units we have already
						for _,unit in ipairs(units) do
							Spring.GiveOrderToUnit(unit, CMD.FIGHT, location, {})
							Spring.SetUnitPosition(unit, position.x,position.y,position.z+64)
							td.missions[unit]="wave"
							Spring.SetUnitMaxHealth(unit, healthBonus)
							Spring.SetUnitHealth(unit, healthBonus)
							
							toSend = toSend - 1
							if toSend < 1 then
								break
							end
						end
						--Spawn more if we need to
						while toSend > 0 do
							toSend = toSend -1
							local nu = Spring.CreateUnit(waveType,position.x,position.y,position.z+64,0,t)
							if nu then
								Spring.GiveOrderToUnit(nu, CMD.FIGHT, location, {})
								td.missions[nu]="wave"
								Spring.SetUnitMaxHealth(nu, healthBonus)
								Spring.SetUnitHealth(nu, healthBonus)
							else
								--We hit the unit limit already, don't bother trying to spawn more
								break
							end
						end
					end
				end
				td.nextWave=nil
			end
			--SuicideIfAlone(t)
		end
		PositionsStatesChanged=false
		_G.aiAggression = aiAggression
	end
end

else

--UNSYNCED

--return false

function gadget:DrawWorld()
	if SYNCED.teamData then
		--Draw the wave warnings
		for t,d in spairs(SYNCED.teamData) do
			if d.nextWave then
				for target,wave in spairs(d.nextWave) do
					gl.PushMatrix()
					gl.Translate(wave.x,wave.y + 50, wave.z)
					gl.Billboard()
					gl.Text("Wave here in " .. math.max(0,math.floor((d.waveTime - Spring.GetGameFrame())/30)),0,50,32,"oc")
					gl.PopMatrix()
				end
			end
		end
	end
end

function gadget:DrawScreen(vsx,vsy)
	if SYNCED.aiAggression then
		local lowestWave = nil
		local shortAIA= math.floor(SYNCED.aiAggression)
		gl.Text("Intrusion Alert Level: "..shortAIA,300,vsy - 20,12,"o")
		for _,d in spairs(SYNCED.teamData) do
			--Find the next wave that will arrive
			if d.nextWave and (not lowestWave or d.waveTime < lowestWave) then
				lowestWave=d.waveTime
			end
		end
		if lowestWave then
			lowestWave = math.max(0,math.floor((lowestWave - Spring.GetGameFrame())/30))
			gl.Text("Inbound wave will appear in: "..lowestWave,300,vsy - 40,20,"o")
		end
	end
end

end
