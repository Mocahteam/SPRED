
function gadget:GetInfo()
	return {
		name = "Hand autobuild",
		desc = "Spawn hands on claimed datavents",
		author = "zwzsg",
		date = "April 2010",
		license = "Public Domain",
		layer = 0,
		enabled = true
	}
end

local AutoBuildEnableManhattanHalfDistance=64
local AutoBuildInhibitRadius=256
local HandBuildTime=60 -- in seconds

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
local hand = UnitDefNames.hand.id
local rock = UnitDefNames.rock.id
local paper = UnitDefNames.paper.id
local scissors = UnitDefNames.scissors.id
local RPS = {rock,paper,scissors}
local isRPS = {
	[rock]=true,
	[paper]=true,
	[scissors]=true,
}

local HandConstructionList={}

if (gadgetHandler:IsSyncedCode()) then

	local DataVents={}

	local function GetFacing(x,z)
		return math.abs(Game.mapSizeX - 2*x) > math.abs(Game.mapSizeZ - 2*z)
			and ((2*x>Game.mapSizeX) and "west" or "east")
			or ((2*z>Game.mapSizeZ) and "north" or "south")
	end

	function gadget:GameStart()
		DataVents={}
		for _,f in ipairs(Spring.GetAllFeatures()) do
			if FeatureDefs[Spring.GetFeatureDefID(f)].name == "geovent" then
				local x,y,z = Spring.GetFeaturePosition(f)
				local newSpot=true
				for _,g in ipairs(DataVents) do
					if math.sqrt((x-g.x)*(x-g.x) + (z-g.z)*(z-g.z)) < 64 then
						newSpot = false
						break
					end
				end
				if newSpot then
					table.insert(DataVents, {x=x, y=y, z=z, unit=nil, team=nil})
				end
			end
		end
	end

	function gadget:GameFrame(f)
		for UnitID,Info in pairs(HandConstructionList) do
			if not Info.BirthFrame then-- for savegames
				local _,_,_,_,b=Spring.GetUnitHealth(UnitID)
				Info.BirthFrame=Spring.GetGameFrame()-b*HandBuildTime*30
			end
			if Info.New then
				Spring.GiveOrderToUnit(UnitID, -Info.ParentType, {}, {})
				Info.New=nil
			end
			local b=math.min(1,(f-Info.BirthFrame)/(30*HandBuildTime))
			local h,mh=Spring.GetUnitHealth(UnitID)
			Spring.SetUnitHealth(UnitID,{["build"]=b,["health"]=h+mh/(30*HandBuildTime)})
			if b>=1 then
				HandConstructionList[UnitID]=nil
			end
		end
		if f%13==11 then
			local s=AutoBuildEnableManhattanHalfDistance
			local r=AutoBuildInhibitRadius
			if f==11 then
				for _,dv in ipairs(DataVents) do
					for _,u in ipairs(Spring.GetUnitsInRectangle(dv.x-s,dv.z-s,dv.x+s,dv.z+s)) do
						dv.unit=u
						dv.team=Spring.GetUnitTeam(u)
					end
				end
			end
			for _,dv in ipairs(DataVents) do
				if not dv.unit then
					local x,z=dv.x,dv.z
					local closest_unit=nil
					local closest_squared_distance=nil
					for _,u in ipairs(Spring.GetUnitsInRectangle(x-s,z-s,x+s,z+s)) do
						local ux,_,uz=Spring.GetUnitPosition(u)
						if isRPS[Spring.GetUnitDefID(u)]
							and ((not closest_unit) or (ux-x)^2+(uz-z)^2<closest_squared_distance)
							and not (select(5,Spring.GetUnitHealth(u))<1) then
							closest_unit=u
							closest_squared_distance=(ux-x)^2+(uz-z)^2
						end
					end
					if closest_unit then
						if not Spring.GetUnitNearestEnemy(closest_unit,r,false) then
							local y=Spring.GetGroundHeight(x,z)
							local facing=GetFacing(x,z)
							local team=Spring.GetUnitTeam(closest_unit)
							local hand=Spring.CreateUnit(hand,x,y,z,facing,team,true)
							if hand then
								HandConstructionList[hand]={BirthFrame=f,ParentType=Spring.GetUnitDefID(closest_unit),New=true}
								Spring.DestroyUnit(closest_unit, false, true, closest_unit)
								local d=math.sqrt(closest_squared_distance)
								local cegname=UnitDefs[Spring.GetUnitDefID(closest_unit)].name.."_fountain"
								local px,py,pz=Spring.GetUnitPosition(closest_unit)
								local dx,dy,dz=(x-px)/d,2,(z-pz)/d
								local r,dmg=0,0
								Spring.SpawnCEG(cegname,px,py,pz,dx,dy,dz,r,dmg)
							end
						end
					end
				end
			end
		end
	end

	function gadget:UnitCreated(u,ud,team)
		if ud==hand or ud==rock or ud==paper or ud==scissors then
			Spring.SetUnitAlwaysVisible(u,true)
		end
		if isAnyBuilding[ud] then
			local ux,_,uz=Spring.GetUnitPosition(u)
			for _,g in ipairs(DataVents) do
				if not g.unit then
					if (ux-g.x)*(ux-g.x)+(uz-g.z)*(uz-g.z) < 64*64 then
						g.unit=u
						g.team=team
					end
				end
			end
			if ud==hand and not HandConstructionList[u] then-- for savegames
				HandConstructionList[u]={}
			end
		end
	end

	function gadget:UnitDestroyed(u,ud,team)
		if HandConstructionList[u] then
			HandConstructionList[u]=nil
		end
		if isAnyBuilding[ud] then
			for _,g in ipairs(DataVents) do
				if g.unit==u then
					g.unit=nil
					g.team=nil
				end
			end
		end
	end

	function gadget:UnitTaken(u,ud,team,newteam)
		if isAnyBuilding[ud] then
			for _,g in ipairs(DataVents) do
				if g.unit==u then
					g.team=newteam
				end
			end
		end
	end

end
