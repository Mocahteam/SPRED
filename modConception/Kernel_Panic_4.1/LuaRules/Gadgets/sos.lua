
--[[
Gadget to manage "Save Our Souls" gamemode:

It works like that:
- Whenever a unit dies, it leaves a soul on the place it dies
- The soul lingers until it receives salvation
- The only way to salve a soul is to have a unit from same team touch it
- Every team start with a given amount of faith
- Every soul make the faith of the team decrease every second
- When a team has no more faith, it loses the game

More precision:
- The souls spawn as immature
- Souls aged 5 seconds turn mature
- Only mature souls can be salved
- Only mature souls decrease faith
- Larger units drop bigger souls
- Souls that are close fuse into a bigger soul
- Flying units can't catch souls as it would be too easy
- Flying units don't leave souls as they could drop on unreachable places

Update:
- Faith is divided in sectors
- Each finished building gives a (filled) sector
- Each destroyed building removes a (filled) sector
- Negative faith does not kill all units of the player, but instead kill all mobiles and set all building health to one

To differentiate units that really die,
from units that were removed by Lua gadgets,
such as morphing bugs or bufferizing packets,
I use in them Spring.DestroyUnit(u, false, true, u)
That is, I mark unit destructions that "do not count"
by having the attacker ID set to the destroyed ID.

Thanksfully self'D ing unit have the attacker set to nil,
not to self, so they still leave souls.

]]--

function gadget:GetInfo()
	return {
		name = "Kernel Panic S.O.S.",
		desc = "Manage S.O.S. mode",
		author = "zwzsg",
		date = "11 may 2009",
		license = "Public Domain",
		layer = 0,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

local MaxBaseFaith = 1024 -- That value is diiscarded, either replaced by the ModOption value of the TeamInfo value
local SoulSalvationRadius = 40
local SoulFusionRadius = 6

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)
-- Allows me to use isSpam[ud],isArty[ud],isHeavy[ud],isCons[ud],isAnyBuilding[ud]
-- So that the soul power depends on the kind of unit that died

local Souls = {}
local DFDT = {}
local Faith = {}
local Sectors = {}
local BaseFaith = {}
local InstaDeath = {}

local function isUnitComplete(UnitID)
	local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(UnitID)
	if buildProgress and buildProgress>=1 then
		return true
	else
		return false
	end
end

local function RedoTeamFaith(team,NewBaseFaith)
	if NewBaseFaith==0 then
		DFDT[team]=nil
		Faith[team]=nil
		Sectors[team]=nil
		BaseFaith[team]=nil
		InstaDeath[team]=nil
		for i=#Souls,1,-1 do
			if Souls[i].t==team then
				table.remove(Souls,i)
			end
		end
	else
		local LostFaith=Faith[team] and (BaseFaith[team]*Sectors[team]-Faith[team]) or 0
		Sectors[team]=#(Spring.GetTeamUnitsByDefs(team,AnyBuilding) or {})
		BaseFaith[team]=math.abs(NewBaseFaith)
		Faith[team]=Sectors[team]*BaseFaith[team]-LostFaith
		if NewBaseFaith<0 then
			InstaDeath[team]=true
		end
	end
end

local function SoSCmd(Cmd,Line,WordList,Player)
	local words={}
	local str=Line
	local spacers={" ","\t",":",",","'","\"","/","\\"}
	local function isSpacer(s)
		for _,spacer in ipairs(spacers) do
			if spacer==s then
				return true
			end
		end
		return false
	end
	while string.len(str)>0 do
		local cursor1=1
		while isSpacer(string.sub(str,cursor1,cursor1)) and cursor1<=string.len(str) do
			cursor1=cursor1+1
		end
		local cursor2=cursor1
		while cursor2<=string.len(str) and not isSpacer(string.sub(str,cursor2,cursor2)) do
			cursor2=cursor2+1
		end
		if cursor1<cursor2 then
			table.insert(words,string.sub(str,cursor1,cursor2-1))
		end
		str=string.sub(str,cursor2,-1)
	end

	if #words==1 then
		local PlayerName,PlayerIsActive,PlayerIsSpec,PlayerTeamID,_,_,_,_,_=Spring.GetPlayerInfo(Player)
		local NewBaseFaith=tonumber(words[1])
		if NewBaseFaith and PlayerTeamID and PlayerIsActive and not PlayerIsSpec then
			if Faith[PlayerTeamID] and BaseFaith[PlayerTeamID]<math.abs(NewBaseFaith) and not Spring.IsCheatingEnabled() then
				Spring.SendMessageToPlayer(Player,"Increasing your sector size requires cheat")
				return false
			else
				if NewBaseFaith==0 and not Spring.IsCheatingEnabled() then
					Spring.SendMessageToPlayer(Player,"Cheat required!")
					return false
				else
					RedoTeamFaith(PlayerTeamID,NewBaseFaith)
					Spring.SendMessage("<PLAYER"..Player.."> set own sector size to "..NewBaseFaith)
					return true
				end
			end
		end
	elseif #words==2 then
		local TeamID=tonumber(words[1])
		local NewBaseFaith=tonumber(words[2])
		if not Spring.IsCheatingEnabled() then
			Spring.SendMessageToPlayer(Player,"Cheat required!")
			return false
		elseif NewBaseFaith then
			if words[1]=="*" then
				for _,team in ipairs(Spring.GetTeamList()) do
					RedoTeamFaith(team,NewBaseFaith)
				end
				Spring.SendMessage("<PLAYER"..Player.."> set everybody's sector size to "..NewBaseFaith)
				return true
			elseif TeamID and Spring.GetTeamInfo(TeamID) then
				RedoTeamFaith(TeamID,NewBaseFaith)
				local names=nil
				for _,pid in ipairs(Spring.GetPlayerList(TeamID,true)) do
					names=(names and names.."," or "").."<PLAYER"..pid..">"
				end
				Spring.SendMessage("<PLAYER"..Player.."> set Team"..TeamID.."("..(names or "")..") sector size to "..NewBaseFaith)
				return true
			end
		end
	end

	Spring.SendMessageToPlayer(Player,"Bad syntax in sos command. Use something like:")
	Spring.SendMessageToPlayer(Player,"/luarules sos 512     set your sos")
	Spring.SendMessageToPlayer(Player,"/luarules sos * 512   set everybody sos")
	Spring.SendMessageToPlayer(Player,"/luarules sos 3 512   set team 3 sos")
	return false
end

local function SetupSoSCmd()
	local cmd,func,help
	cmd  = "sos"
	func = SoSCmd
	help = " [BaseFaith] or [TeamID] [BaseFaith] or [*] [BaseFaith]: Edit SoS on the fly"
	gadgetHandler:AddChatAction("sos",func,help)
	Script.AddActionFallback(cmd..' ',help)
end


function gadget:Initialize()

	-- There can be:
	--		- Full scope ModOptions "sos"
	--		- Team scope option "sos"
	--		- Team scope option "som"
	-- If the full scope ModOptions and one Team scope option is used, it takes the worst of the two
	-- If the two Team scope options are used, it takes the worst of the two for InstaDeath, but it takes only "som" and ignore "sos" (team scope "sos", not full scope one) for Absolute BaseFaith

	local ModOptionValue=nil
	local isThereAnySoS=false
	if Spring.GetModOptions and Spring.GetModOptions()["sos"] and tonumber(Spring.GetModOptions()["sos"]) and tonumber(Spring.GetModOptions()["sos"])~=0 then
		ModOptionValue=tonumber(Spring.GetModOptions()["sos"])
		MaxBaseFaith=math.abs(ModOptionValue)
	end

	for _,team in ipairs(Spring.GetTeamList()) do
		if ModOptionValue then
			Faith[team]=0
			Sectors[team]=0
			BaseFaith[team]=math.abs(MaxBaseFaith)
			if ModOptionValue<0 then
				InstaDeath[team]=true
			end
			isThereAnySoS=true
		end
		local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(team)
		if CustomTeamOptions then
			for _,SoSKey in ipairs({CustomTeamOptions["sos"],CustomTeamOptions["som"]}) do
				if SoSKey and tonumber(SoSKey) and tonumber(SoSKey)~=0 then
					Faith[team]=0
					Sectors[team]=0
					BaseFaith[team]=ModOptionValue and math.min(math.abs(tonumber(SoSKey)),math.abs(MaxBaseFaith)) or math.abs(tonumber(SoSKey))
					InstaDeath[team]=InstaDeath[team] or tonumber(SoSKey)<0
					isThereAnySoS=true
				end
			end
		end
	end

	--if not isThereAnySoS then
	--	gadgetHandler:RemoveGadget()
	--end

	SetupSoSCmd()

end

function gadget:GameStart()
end

-- Kills mobile units, set buildings health to low, empty buffer
local function Cripple(team)
	GG.bufferSize[team]=0
	Spring.SetTeamRulesParam(team,"bufferSize",GG.bufferSize[team])
	for _,u in ipairs(Spring.GetTeamUnits(team)) do
		if not Spring.GetUnitIsDead(u) then
			local ud=Spring.GetUnitDefID(u)
			local udd=UnitDefs[ud]
			if udd.canMove==false and udd.xsize>=5 and udd.zsize>=5 then
				local health,maxHealth,_,_,_=Spring.GetUnitHealth(u)
				local PercentLeft=10
				if isBigBuilding[ud] then
					PercentLeft=25
				elseif isSmallBuilding[ud] then
					PercentLeft=5
				end
				Spring.SetUnitHealth(u,math.min(health,maxHealth*PercentLeft/100))
			else
				Spring.DestroyUnit(u,true,false,u)
			end
		end
	end
end

-- Manage and update souls and faiths
function gadget:GameFrame(f)
	if f%30==5 then

		DFDT={}

		-- Age souls, and for mature souls, remove those salved by units, and decrease team faith
		for i,s in ipairs(Souls) do
			if s.a>5 then
				for _,u in ipairs(Spring.GetUnitsInCylinder(s.x,s.z,SoulSalvationRadius)) do
					if Spring.AreTeamsAllied(s.t,Spring.GetUnitTeam(u)) then -- By luck, this is the correct arguments order to handle assymetrical alliance
						if not UnitDefs[Spring.GetUnitDefID(u)].canFly  then
							Souls[i].s=0
						end
					end
				end
				DFDT[s.t]=(DFDT[s.t] or 0)-Souls[i].s
				Faith[s.t]=Faith[s.t]-Souls[i].s
			end
			Souls[i].a=math.min(s.a+1,10)
		end

		-- Fuse close souls
		for i1,s1 in ipairs(Souls) do
			for i2,s2 in ipairs(Souls) do
				if s1.t==s2.t and i1~=i2 and s1.s>0 and s2.s>0 then
					if((s1.x-s2.x)^2+(s1.z-s2.z)^2<=SoulFusionRadius^2) then
						Souls[i2].x=(s1.x*s1.s+s2.x*s2.s)/(s1.s+s2.s)
						Souls[i2].z=(s1.z*s1.s+s2.z*s2.s)/(s1.s+s2.s)
						Souls[i2].y=Spring.GetGroundHeight(Souls[i2].x,Souls[i2].z)
						Souls[i2].a=math.max(s1.a,s2.a)
						Souls[i2].s=s1.s+s2.s
						Souls[i1].s=0
					end
				end
			end
		end

		-- Remove faithless teams
		for _,team in ipairs(Spring.GetTeamList()) do
			if(Faith[team] and Faith[team]<0) then
				local names=nil
				for _,pid in ipairs(Spring.GetPlayerList(team,true)) do
					names=(names and names.."," or "").."<PLAYER"..pid..">"
				end
				Spring.SendMessage("Team"..team.."("..(names and names or "")..") ran out of memory!")
				if InstaDeath[team] then
					for _,u in ipairs(Spring.GetTeamUnits(team)) do
						Spring.DestroyUnit(u,true,false,u)
					end
					Faith[team]=0
				else
					Cripple(team)
					Faith[team]=BaseFaith[team]*Sectors[team]
				end
				for i,s in ipairs(Souls) do
					if s.t==team then
						Souls[i].s=0
					end
				end
			end
		end

		-- Remove empty souls
		for i,s in ipairs(Souls) do
			if s.s==0 then
				table.remove(Souls,i)
			end
		end

		-- Make available for unsynced
		_G.SaveOurSouls = {Souls=Souls,Faith=Faith,DFDT=DFDT,BaseFaith=BaseFaith,Sectors=Sectors}

	end
end

function gadget:UnitDestroyed(u,ud,ut,a,ad,at)
	-- If not a nanoframe, and if attacker isn't itself, which was how I marked unit destruction that should not count, such as bufferising packets or morphing
	if isUnitComplete(u) and a~=u and Faith[ut] then
		-- If a building, update sectors
		if isAnyBuilding[ud] then
			Faith[ut]=Faith[ut]-BaseFaith[ut]
			Sectors[ut]=Sectors[ut]-1
		end
		-- Create souls on units destruction
		local x,y,z=Spring.GetUnitPosition(u)
		-- Using kpunittypes.lua so that mines and signals leave no soul, and so that spams leave smaller souls
		local s=nil
		if isSpam[ud] then
			s=1
		elseif isArty[ud] or isHeavy[ud] or isCons[ud] then
			s=3
		elseif isAnyBuilding[ud] then
			s=10
		end
		if s and not UnitDefs[ud].canFly then
			table.insert(Souls,{x=x,y=y,z=z,t=ut,s=s,a=0})
		end
	end
end

function gadget:UnitFinished(u,ud,team)
	if isAnyBuilding[ud] and Faith[team] then
		Faith[team]=Faith[team]+BaseFaith[team]
		Sectors[team]=Sectors[team]+1
	end
end

function gadget:UnitTaken(u,ud,team,newteam)
	if isAnyBuilding[ud] and Faith[newteam] then
		Faith[newteam]=Faith[newteam]+BaseFaith[newteam]
		Sectors[newteam]=Sectors[newteam]+1
	end
end

function gadget:UnitGiven(u,ud,team,oldteam)
	if isAnyBuilding[ud] and Faith[oldteam] then
		Faith[oldteam]=Faith[oldteam]-BaseFaith[oldteam]
		Sectors[oldteam]=Sectors[oldteam]-1
	end
end

else
--UNSYNCED

local xPosSosBar = nil
local yPosSosBar = nil
local xSizeSosBar = nil
local ySizeSosBar = nil

local MouseMoveSizeSosBar = nil
local ShowSosBar = nil

local DrawFrame = 0

-- Draw the lost souls
function gadget:DrawWorldPreUnit()
	if SYNCED.SaveOurSouls then
		for _,s in sipairs(SYNCED.SaveOurSouls.Souls) do
			local tc={Spring.GetTeamColor(s.t)}
			gl.Color(tc[1],tc[2],tc[3],s.t==Spring.GetLocalTeamID() and 1 or 0.2)
			if s.a<=5 then -- Young souls
				local qs=5*math.sqrt(s.s)
				gl.DrawGroundQuad(s.x-qs,s.z-qs,s.x+qs,s.z+qs)
			else -- Old souls
				gl.DrawGroundCircle(s.x,Spring.GetGroundHeight(s.x,s.z),s.z,8*math.sqrt(s.s),12)
			end
		end
		gl.Color(1,1,1,1)
		DrawFrame=DrawFrame+1
	end
end

-- Draw the faith bar
function gadget:DrawScreen(vsx, vsy)
	local team = Spring.GetLocalTeamID()
	if SYNCED.SaveOurSouls and SYNCED.SaveOurSouls.Faith[team] and not Spring.IsGUIHidden() then
		ShowSosBar=true
		local basefaith=SYNCED.SaveOurSouls.BaseFaith[team]
		local dfdt=SYNCED.SaveOurSouls.DFDT[team]
		local faith=SYNCED.SaveOurSouls.Faith[team]
		local sectors=SYNCED.SaveOurSouls.Sectors[team]
		local maxfaith=sectors*basefaith
		local SosBarTxt1=faith..(dfdt and ((dfdt>=0 and " +" or " -")..math.abs(dfdt)) or "")
		local SosBarTxt2=basefaith.."x"..sectors
		xPosSosBar = xPosSosBar or vsx*0.63
		yPosSosBar = yPosSosBar or vsy*0.85
		xSizeSosBar = xSizeSosBar or vsx*0.3
		ySizeSosBar = ySizeSosBar or vsy*0.03
		-- Calculating the faith color:
		-- The bar color should go from green to yellow to red
		-- (r,g,b,a)
		-- (0,1,0,1) -- green
		-- (1,1,0,1) -- yellow
		-- (1,0,0,1) -- red
		local r = faith>maxfaith/2 and 2-2*faith/maxfaith or 1 -- red
		local g = faith>maxfaith/2 and 1 or 2*faith/maxfaith -- green
		local b = 0 -- blue
		-- Draw the black frame:
		gl.Color(r/4,g/4,b/4,1)
		gl.Rect(xPosSosBar,yPosSosBar,xPosSosBar+xSizeSosBar,yPosSosBar+ySizeSosBar)
		-- Draw the grey of empty faith:
		gl.Color(r/2,g/2,b/2,1)
		gl.Rect(xPosSosBar+2,yPosSosBar+2,xPosSosBar+2+(xSizeSosBar-4),yPosSosBar+ySizeSosBar-2)
		gl.Color(r,g,b,1)
		if xSizeSosBar>ySizeSosBar then
			-- Draw the colored filled faith:
			gl.Rect(xPosSosBar+2,yPosSosBar+2,xPosSosBar+2+(xSizeSosBar-4)*(faith/maxfaith),yPosSosBar+ySizeSosBar-2)
			-- Draw the sector separators:
			if sectors>=2 then
				gl.LineWidth(2)
				gl.Color(r/4,g/4,b/4,1)
				for n=1,sectors-1 do
					local x=xPosSosBar+2+(xSizeSosBar-4)*n/sectors
					gl.Shape(GL.LINES,{{v={x,yPosSosBar+1}},{v={x,yPosSosBar+ySizeSosBar-1}}})
				end
			end
		else
			-- Draw the colored filled faith:
			gl.Rect(xPosSosBar+2,yPosSosBar+2,xPosSosBar+xSizeSosBar-2,yPosSosBar+2+(ySizeSosBar-4)*(faith/maxfaith))
			-- Draw the sector separators:
			if sectors>=2 then
				gl.LineWidth(2)
				gl.Color(r/4,g/4,b/4,1)
				for n=1,sectors-1 do
					local y=yPosSosBar+2+(ySizeSosBar-4)*n/sectors
					gl.Shape(GL.LINES,{{v={xPosSosBar+1,y}},{v={xPosSosBar+xSizeSosBar-1,y}}})
				end
			end
		end
		local minDim=math.min(xSizeSosBar,ySizeSosBar)
		gl.Text(SosBarTxt1,xPosSosBar+0.2*minDim,yPosSosBar,0.8*minDim,"o")
		gl.Text(SosBarTxt2,xPosSosBar+xSizeSosBar-0.2*minDim,yPosSosBar+ySizeSosBar-minDim,0.8*minDim,"ro")
		gl.Color(1,1,1,1)
		gl.LineWidth(1)
	else
		ShowSosBar=false
	end
end

function gadget:MouseMove(x,y,dx,dy,button)
	if ShowSosBar and MouseMoveSizeSosBar then
		if MouseMoveSizeSosBar>=2 then -- resize bar
			if MouseMoveSizeSosBar%2==1 then
				xPosSosBar=xPosSosBar+dx
				xSizeSosBar=math.max(6,xSizeSosBar-dx)
			else
				xSizeSosBar=math.max(6,xSizeSosBar+dx)
			end
			if math.floor(MouseMoveSizeSosBar/2)%2==0 then
				yPosSosBar=yPosSosBar+dy
				ySizeSosBar=math.max(6,ySizeSosBar-dy)
			else
				ySizeSosBar=math.max(6,ySizeSosBar+dy)
			end
		else -- move bar
			xPosSosBar=xPosSosBar+dx
			yPosSosBar=yPosSosBar+dy
		end
	end
end

function gadget:MousePress(x,y,button)
	if ShowSosBar and x>xPosSosBar and y>yPosSosBar and x<xPosSosBar+xSizeSosBar and y<yPosSosBar+ySizeSosBar then
		MouseMoveSizeSosBar=true
		if (x<xPosSosBar+3 or x>xPosSosBar+xSizeSosBar-3) and (y<yPosSosBar+3 or y>yPosSosBar+ySizeSosBar-3) then
			MouseMoveSizeSosBar=2 -- resize bar
			if x<xPosSosBar+2 then
				MouseMoveSizeSosBar=MouseMoveSizeSosBar+1
			end
			if y<yPosSosBar+2 then
				MouseMoveSizeSosBar=MouseMoveSizeSosBar+2
			end
		else
			MouseMoveSizeSosBar=1 -- move bar
		end
		return true
	else
		return false
	end
end
 
function gadget:MouseRelease(x,y,button)
	if ShowSosBar and MouseMoveSizeSosBar then
		MouseMoveSizeSosBar=false
		return true
	else
		return false
	end
end

function gadget:IsAbove(x,y)
	if ShowSosBar and x>xPosSosBar and y>yPosSosBar and x<xPosSosBar+xSizeSosBar and y<yPosSosBar+ySizeSosBar then
		return true
	else
		return false
	end
end

function gadget:GetTooltip(x,y)
	local team = Spring.GetLocalTeamID()
	if SYNCED.SaveOurSouls and SYNCED.SaveOurSouls.Faith[team] then
		return	"\255\128\255\128Save our Memory!\n"..
				"\255\128\255\255Free the Memory Leaks left by the death of your own units to avoid running out of memory.\n"..
				"\255\128\255\255Each building built or lost gives or removes a \255\255\255\255filled\255\128\255\255 Memory Sector.\n"..
				" \n"..
				"\255\134\255\121"..SYNCED.SaveOurSouls.Faith[team]..":\255\193\255\187 amount of available memory left. \255\128\255\255Don't let this run out!\n"..
				"\255\255\170\170"..(SYNCED.SaveOurSouls.DFDT[team] or 0)..":\255\255\213\213 amount of memory lost each second. \255\128\255\255Touch the teamcolored circles to reduce this!\n"..
				"\255\170\170\255"..SYNCED.SaveOurSouls.Sectors[team]..":\255\213\213\255 number of memory sectors owned. \255\128\255\255Claim (and keep) more datavents to get more!\n"..
				"\255\255\178\057"..SYNCED.SaveOurSouls.BaseFaith[team]..":\255\255\205\125 memory size of each sectors. \255\128\255\255Fixed at game start by the mod option value."..
				"\255\255\255\255"
	end
end

end
