
-- The reason why ipairs doesn't work!
-- quantum: ipairs is for indexes that start from 1
-- quantum: and have no gaps
-- quantum: use pairs() instead
-- quantum: pairs and ipairs are both standard lua functions
-- quantum: spairs is some wierd spring only thing :P


function gadget:GetInfo()
	return {
		name = "Kernel Panic O.N.S.",
		desc = "Manage O.N.S. mode",
		author = "zwzsg",
		date = "2008-28-10",
		license = "Public Domain",
		layer = 60,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

local function isUnitComplete(UnitID)
	local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(UnitID)
	if buildProgress and buildProgress>=1 then
		return true
	else
		return false
	end
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local GeoSpots={}

local LinkPaths={}

local MaxLinkDist=nil

local LinkBeams={}

local UpdateONS=true

local DisabledForTeam={}

local CacheUnitONSInfo={}

local function ONSCmd(Cmd,Line,WordList,Player)
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
	--Spring.Echo("string.len(\""..Line.."\")="..string.len(Line))
	--Spring.Echo("#words="..#words)
	--for wi,we in ipairs(words) do
	--	Spring.Echo("word["..wi.."]=\""..we.."\"")
	--end
	if Spring.GetModOptions()["ons"]==nil or Spring.GetModOptions()["ons"]=="0" then
		Spring.SendMessage("Game was started without ONS.")
		return false
	elseif #words==0 then
		UpdateONS=true
		Spring.SendMessage("Refreshing ONS")
		return true
	elseif #words==1 then
		local PlayerName,PlayerIsActive,PlayerIsSpec,PlayerTeamID,_,_,_,_,_=Spring.GetPlayerInfo(Player)
		if PlayerTeamID and PlayerIsActive and not PlayerIsSpec then
			if tonumber(words[1])==0 then
				if not DisabledForTeam[PlayerTeamID]  then
					DisabledForTeam[PlayerTeamID]=true
					UpdateONS=true
					Spring.SendMessage("<PLAYER"..Player.."> of Team"..PlayerTeamID.." decided to play without ONS shields")
				else
					Spring.SendMessageToPlayer(Player,"Team"..PlayerTeamID.." ONS shields already switched off")
				end
				return true
			elseif tonumber(words[1])==1 then
				if DisabledForTeam[PlayerTeamID] then
					local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(PlayerTeamID)
					if	CustomTeamOptions and
						(tonumber(CustomTeamOptions["noons"] or "0") or 1)>=1 and
						not Spring.IsCheatingEnabled() then
						Spring.SendMessageToPlayer(Player,"Team"..PlayerTeamID.." shields were disabled by start script, Cheat is required to switch them on")
					else
						DisabledForTeam[PlayerTeamID]=nil
						UpdateONS=true
						Spring.SendMessage("<PLAYER"..Player.."> of Team"..PlayerTeamID.." decided to turn ONS shields back on")
					end
				else
					Spring.SendMessageToPlayer(Player,"Team"..PlayerTeamID.." ONS shields already switched on")
				end
				return true
			end
		end
	elseif #words==2 then
		if not Spring.IsCheatingEnabled() then
			Spring.Echo("Cheat must be enabled to switch other teams ONS shields.")
			return false
		else
			local t=tonumber(words[1])
			if t and Spring.GetTeamInfo(t) then
				local names=nil
				for _,pid in ipairs(Spring.GetPlayerList(t,true)) do
					names=(names and names.."," or "").."<PLAYER"..pid..">"
				end
				local MsgBgn="Team"..t.."("..(names and names or "")..") ONS shields"
				if tonumber(words[2])==0 then
					if not DisabledForTeam[t] then
						DisabledForTeam[t]=true
						UpdateONS=true
						Spring.SendMessage(MsgBgn.." turned off")
					else
						Spring.SendMessageToPlayer(Player,MsgBgn.." already off")
					end
					return true
				elseif tonumber(words[2])==1 then
					if DisabledForTeam[t] then
						DisabledForTeam[t]=nil
						UpdateONS=true
						Spring.SendMessage(MsgBgn.." turned on")
					else
						Spring.SendMessageToPlayer(Player,MsgBgn.." already on")
					end
					return true
				end
			end
		end
	end
	Spring.SendMessageToPlayer(Player,"Bad syntax in ons command. Use something like:")
	Spring.SendMessageToPlayer(Player,"/luarules ons         Refresh ONS")
	Spring.SendMessageToPlayer(Player,"/luarules ons 0       Disable your own ONS")
	Spring.SendMessageToPlayer(Player,"/luarules ons 3 0     Disable ONS of team 3 (needs cheat)")
	return false
end

local function SetupONSCmd()
	local cmd,func,help
	cmd  = "ons"
	func = ONSCmd
	help = " [0|1] or [TeamID] [0|1]: Toggle ONS on and off"
	gadgetHandler:AddChatAction("ons",func,help)
	Script.AddActionFallback(cmd..' ',help)
end

function gadget:Initialize()
	-- gadgetHandler:RegisterGlobal("stuff",stuff)
	SetupONSCmd()
end

function gadget:GameStart()

	-- Disable for teams that have noons set
	for _,TeamID in ipairs(Spring.GetTeamList()) do
		local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(TeamID)
		if CustomTeamOptions then
			local NoOnsKey=CustomTeamOptions["noons"]
			if NoOnsKey and tonumber(NoOnsKey) and tonumber(NoOnsKey)>=1 then
				DisabledForTeam[TeamID]=true
			end
		end
	end

	-- Create tables of Geos
	GeoSpots={}
	for _,f in ipairs(Spring.GetAllFeatures()) do
		if FeatureDefs[Spring.GetFeatureDefID(f)].name == "geovent" then
			local x,y,z = Spring.GetFeaturePosition(f)
			--Merging algorithm because some KP maps have multiple geos in one spot
			local newSpot=true
			for _,g in ipairs(GeoSpots) do
				if math.sqrt((x-g.x)*(x-g.x) + (z-g.z)*(z-g.z)) < 64 then
					newSpot = false
					break
				end
			end
			if newSpot then
				table.insert(GeoSpots, {x=x, y=y, z=z, shortest=nil, networked=false})
			end
		end
	end


	-- The algorithm below is flawed, it can results in small networks seperated from each others
	-- Calculate for each geo distance to closest geo
	for _,f in ipairs(GeoSpots) do
		for _,g in ipairs(GeoSpots) do
			local d=math.sqrt((f.x-g.x)*(f.x-g.x)+(f.z-g.z)*(f.z-g.z))
			if (g~=f) and (not f.shortest or d<f.shortest) then
				f.shortest=d
			end
		end
	end
	-- Calculate longest closest distance between geos
	local furthest=nil
	for _,g in ipairs(GeoSpots) do
		if not furthest or g.shortest>furthest then
			furthest=g.shortest
		end
	end


	-- This algorithm may take more CPU, but should work better
	local iterate
	if #GeoSpots>1 then
		GeoSpots[1].networked=true
		iterate=true
	else
		iterate=false
	end
	while iterate do
		-- Calculate for each un-networked each geo "f" distance to closest networked geo "g"
		for _,f in ipairs(GeoSpots) do
			f.shortest=nil
			for _,g in ipairs(GeoSpots) do
				if f.networked==false and g.networked==true then
					local d=math.sqrt((f.x-g.x)*(f.x-g.x)+(f.z-g.z)*(f.z-g.z))
					if not f.shortest or d<f.shortest then
						f.shortest=d
					end
				end
			end
		end
		-- Calculate shortest of all distances between an un-networked geo "f" and a networked one "g"
		local shortest=nil
		for _,f in ipairs(GeoSpots) do
			if f.shortest and (not shortest or f.shortest<shortest) then
				shortest=f.shortest
			end
			f.shortest=nil -- so at the end all "shortest" are nil
		end
		if shortest and shortest>furthest then
			furthest=shortest
		end
		-- Mark as networked the geos that now are
		iterate=false
		for _,f in ipairs(GeoSpots) do
			for _,g in ipairs(GeoSpots) do
				if f.networked==false and g.networked==true then
					local d=math.sqrt((f.x-g.x)*(f.x-g.x)+(f.z-g.z)*(f.z-g.z))
					if d<=furthest then
						f.networked=true
					else
						iterate=true
					end
				end
			end
		end
	end

	-- The start pos must be connecteable too
	for _,team in ipairs(Spring.GetTeamList()) do
		local x,y,z=Spring.GetTeamStartPosition(team)
		if x and z and team~=Spring.GetGaiaTeamID() then
			local closest=nil
			for _,g in ipairs(GeoSpots) do
				local d=math.sqrt((x-g.x)*(x-g.x)+(z-g.z)*(z-g.z))
				if not closest or d<closest then
					closest=d
				end
			end
			if closest and furthest and closest>furthest then
				furthest=closest
			end
		end
	end

	-- Add a tiny amount to furthest, and ensure it's not uninitialized
	if furthest then
		MaxLinkDist=furthest+64
	else
		MaxLinkDist=512
	end

	-- Basic web analyser
	LinkPaths={}
	for i1,g1 in ipairs(GeoSpots) do
		for i2,g2 in ipairs(GeoSpots) do
			if i1<i2 then
				local dist=math.sqrt((g1.x-g2.x)*(g1.x-g2.x)+(g1.z-g2.z)*(g1.z-g2.z))
				if dist<MaxLinkDist then
					table.insert(LinkPaths, {x1=g1.x, y1=g1.y, z1=g1.z, x2=g2.x, y2=g2.y, z2=g2.z, distance=dist})
				end
			end
		end
	end

end


function gadget:GameFrame(f)

	if f%30<0.1 then

		if Spring.GetModOptions()["ons"]==nil or Spring.GetModOptions()["ons"]=="0" then
			gadgetHandler:RemoveGadget()
			return
		end

		if not UpdateONS and f%1485>0.1 then
			return
		else -- Run the code if the flag UpdateONS has been raised, or every 45-50 seconds
			UpdateONS=false
			CacheUnitONSInfo={}
		end

		local FromCenter={}
		local FromExtremity={}
		local isExtremity={}
		local TeamMaxLinks={}
		local iterate
		local maxit=0
		local Updates=0

		-- Increase the "number of updates" counter
		if _G.ONS and _G.ONS.Updates then
			Updates=_G.ONS.Updates+1
		end

		-- Fills HomeBase's "FromCenter"
		for _,team in ipairs(Spring.GetTeamList()) do
			for _,id in ipairs(Spring.GetTeamUnitsByDefs(team,BigBuilding)) do
				if isUnitComplete(id) then
					FromCenter[id]=0
				end
			end
		end

		-- Fills SmallBuilding's "FromCenter"
		iterate=true
		while(iterate) do
			maxit=maxit+1
			if maxit>500 then
				Spring.Echo("Max iteration reached! Emergency exit from (center) code!")
				return false
			end
			iterate=false
			for _,team1 in ipairs(Spring.GetTeamList()) do
				for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,SmallBuilding)) do
					if isUnitComplete(id1) and FromCenter[id1]==nil then
						for _,team2 in ipairs(Spring.GetTeamList()) do
							if Spring.AreTeamsAllied(team1,team2) then
								for _,id2 in ipairs(Spring.GetTeamUnitsByDefs(team2,AnyBuilding)) do
									if isUnitComplete(id2) and id2~=id1 and FromCenter[id2]~=nil then
										if Spring.GetUnitSeparation(id1,id2,true)<MaxLinkDist then
											if FromCenter[id1]==nil or FromCenter[id1]>1+FromCenter[id2] then
												iterate=true
												FromCenter[id1]=1+FromCenter[id2]
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		-- Fills AnyBuilding's "isExtremity" from "FromCenter"
		for _,team1 in ipairs(Spring.GetTeamList()) do
			for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,AnyBuilding)) do
				if isUnitComplete(id1) then
					isExtremity[id1]=true
					for _,team2 in ipairs(Spring.GetTeamList()) do
						if Spring.AreTeamsAllied(team1,team2) then
							for _,id2 in ipairs(Spring.GetTeamUnitsByDefs(team2,AnyBuilding)) do
								if isUnitComplete(id2) and id2~=id1 and FromCenter[id2]~=nil and FromCenter[id1]~=nil then
									if Spring.GetUnitSeparation(id1,id2,true)<MaxLinkDist then
										if FromCenter[id2]>FromCenter[id1] then
											isExtremity[id1]=false
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		-- Inits AnyBuilding's "FromExtremity" from "isExtremity"
		for _,team1 in ipairs(Spring.GetTeamList()) do
			for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,AnyBuilding)) do
				if isUnitComplete(id1) then
					if isExtremity[id1]==true then
						FromExtremity[id1]=0
					else
						FromExtremity[id1]=nil
					end
				end
			end
		end
		

		-- Fills AnyBuilding's "FromExtremity", from "isExtremity" and "FromCenter"
		iterate=true
		while(iterate) do
			maxit=maxit+1
			if maxit>500 then
				Spring.Echo("Max iteration reached! Emergency exit from (extremity) code!")
				return false
			end
			iterate=false
			for _,team1 in ipairs(Spring.GetTeamList()) do
				for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,AnyBuilding)) do
					if isUnitComplete(id1) and isExtremity[id1]==false then
						for _,team2 in ipairs(Spring.GetTeamList()) do
							if Spring.AreTeamsAllied(team2,team1) then
								for _,id2 in ipairs(Spring.GetTeamUnitsByDefs(team2,AnyBuilding)) do
									if isUnitComplete(id2) and id2~=id1 and FromExtremity[id2]~=nil then
										if Spring.GetUnitSeparation(id1,id2,true)<MaxLinkDist then
											if FromCenter[id2]>FromCenter[id1] and (FromExtremity[id1]==nil or FromExtremity[id2]+1>FromExtremity[id1]) then
												FromExtremity[id1]=1+FromExtremity[id2]
												iterate=true
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end


		-- Fills "TeamMaxLinks", from "FromCenter"
		for _,TeamID in ipairs(Spring.GetTeamList()) do
			TeamMaxLinks[TeamID]=0
		end
		for _,TeamID in ipairs(Spring.GetTeamList()) do
			for _,UnitID in ipairs(Spring.GetTeamUnitsByDefs(TeamID,AnyBuilding)) do
				if isUnitComplete(UnitID) and FromCenter[UnitID] and FromCenter[UnitID]>TeamMaxLinks[TeamID] then
					TeamMaxLinks[TeamID]=FromCenter[UnitID]
				end
			end
		end

		-- Update the web analyser
		-- TODO!!

		-- Create/Update the LinkBeam list
		LinkBeams={}
		for _,team1 in ipairs(Spring.GetTeamList()) do
			if Spring.GetModOptions()["ons"]=="1" and not DisabledForTeam[team1] then -- Homebase Only
				for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,BigBuilding)) do
					if isUnitComplete(id1) then
						for _,team2 in ipairs(Spring.GetTeamList()) do
							if Spring.AreTeamsAllied(team1,team2) then
								for _,id2 in ipairs(Spring.GetTeamUnitsByDefs(team2,SmallBuilding)) do
									if isUnitComplete(id2) and id2~=id1 then
										local x,y,z,TeamID
										x,y,z=Spring.GetUnitPosition(id2)
										TeamID=Spring.GetUnitTeam(id2)
										y=y+Spring.GetUnitHeight(id2)
										local Source={x=x,y=y,z=z,TeamID=TeamID,Disabled=DisabledForTeam[team2]}
										x,y,z=Spring.GetUnitPosition(id1)
										TeamID=Spring.GetUnitTeam(id1)
										y=y+Spring.GetUnitHeight(id1)
										local Destination={x=x,y=y,z=z,TeamID=TeamID,Disabled=DisabledForTeam[team1]}
										table.insert(LinkBeams,{Source,Destination})
									end
								end
							end
						end
					end
				end
			elseif not DisabledForTeam[team1] then -- Weak, Strong, and Ultra
				for _,id1 in ipairs(Spring.GetTeamUnitsByDefs(team1,AnyBuilding)) do
					if isUnitComplete(id1) and FromCenter[id1]~=nil then
						for _,team2 in ipairs(Spring.GetTeamList()) do
							if Spring.AreTeamsAllied(team1,team2) then
								for _,id2 in ipairs(Spring.GetTeamUnitsByDefs(team2,AnyBuilding)) do
									if isUnitComplete(id2) and id2~=id1 and FromCenter[id2]~=nil then
										if Spring.GetUnitSeparation(id1,id2,true)<MaxLinkDist then
											if FromCenter[id2]<FromCenter[id1] then
												x,y,z=Spring.GetUnitPosition(id2)
												TeamID=Spring.GetUnitTeam(id2)
												y=y+Spring.GetUnitHeight(id2)
												local Source={x=x,y=y,z=z,TeamID=TeamID,Disabled=DisabledForTeam[team2]}
												local x,y,z,TeamID
												x,y,z=Spring.GetUnitPosition(id1)
												TeamID=Spring.GetUnitTeam(id1)
												y=y+Spring.GetUnitHeight(id1)
												local Destination={x=x,y=y,z=z,TeamID=TeamID,Disabled=DisabledForTeam[team1]}
												table.insert(LinkBeams,{Source,Destination})
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		for _,team in ipairs(Spring.GetTeamList()) do
			Spring.SetTeamRulesParam(team,"ONS_TeamMaxLinks",TeamMaxLinks[team])
			Spring.SetTeamRulesParam(team,"ONS_Mode",DisabledForTeam[team] and 0 or tonumber(Spring.GetModOptions()["ons"]) or 0)
		end

		-- Store the data
		_G.ONS={MaxLinkDist=MaxLinkDist,LinkPaths=LinkPaths,TeamMaxLinks=TeamMaxLinks,LinkBeams=LinkBeams,FromCenter=FromCenter,FromExtremity=FromExtremity,isExtremity=isExtremity,Updates=Updates}

	end
end

local function GetUnitONSInfo(UnitID)

	if CacheUnitONSInfo[UnitID] then
		return unpack(CacheUnitONSInfo[UnitID])
	end

	-- Not ONS mode or bad unit or bad ONS data
	local UnitExists=false
	local Shielded=false
	local GreenShield=false
	local RedShield=false
	local SourceFound=false
	local SourceID=nil

	if Spring.ValidUnitID(UnitID) then
		UnitExists=true
		if Spring.GetModOptions()["ons"]~=nil and Spring.GetModOptions()["ons"]~="0" then
			if isUnitComplete(UnitID) and _G.ONS and _G.ONS.FromCenter[UnitID] then

				-- Find Source
				local d=nil
				for _,TryTeamID in ipairs(Spring.GetTeamList()) do -- for TryID,_ in ipairs(_G.ONS.FromCenter) do
					for _,TryID in ipairs(Spring.GetTeamUnitsByDefs(TryTeamID,AnyBuilding)) do
						if Spring.AreTeamsAllied(Spring.GetUnitTeam(UnitID),Spring.GetUnitTeam(TryID)) then
							if Spring.ValidUnitID(TryID) and isUnitComplete(TryID) and _G.ONS.FromCenter[TryID] and _G.ONS.FromCenter[TryID]<_G.ONS.FromCenter[UnitID] then
								if d==nil or Spring.GetUnitSeparation(UnitID,TryID,true)<d then
									SourceFound=true
									SourceID=TryID
									d=Spring.GetUnitSeparation(UnitID,TryID,true)
								end
							end
						end
					end
				end

				-- ONS default
				if _G.ONS.isExtremity[UnitID]==nil or _G.ONS.isExtremity[UnitID]==true then
					RedShield=true
					GreenShield=false
					Shielded=false
				else
					RedShield=false
					GreenShield=true
					Shielded=true
				end

				-- Homebase only ONS
				if Spring.GetModOptions()["ons"]=="1" then
					local isItHomebase=false
					for _,udid in ipairs(BigBuilding) do
						if udid==Spring.GetUnitDefID(UnitID) then
							isItHomebase=true
						end
					end
					if isItHomebase then
						local isThereSmall = nil
						for _,team in ipairs(Spring.GetTeamList()) do
							if Spring.AreTeamsAllied(Spring.GetUnitTeam(UnitID),team) then
								for _,id in ipairs(Spring.GetTeamUnitsByDefs(team,SmallBuilding)) do
									if isUnitComplete(id) then
										isThereSmall=true
									end
								end
							end
						end
						if isThereSmall then
							RedShield=false
							GreenShield=true
							Shielded=true
						else
							RedShield=true
							GreenShield=false
							Shielded=false
						end
					else
						RedShield=false
						GreenShield=false
						Shielded=false
					end
				end

				-- Weak ONS
				if Spring.GetModOptions()["ons"]=="2" then
					-- Ok, twas default
				end

				-- Strong ONS
				if Spring.GetModOptions()["ons"]=="3" then
					if _G.ONS.FromCenter[UnitID]~=_G.ONS.TeamMaxLinks[Spring.GetUnitTeam(UnitID)] then
						RedShield=false
						GreenShield=true
						Shielded=true
					end
				end
				
				-- Ultra ONS
				if Spring.GetModOptions()["ons"]=="4" then
					local isEnemyNear=false
					for _,TryTeamID in ipairs(Spring.GetTeamList()) do
						for _,TryID in ipairs(Spring.GetTeamUnitsByDefs(TryTeamID,AnyBuilding)) do
							if not Spring.AreTeamsAllied(Spring.GetUnitTeam(UnitID),Spring.GetUnitTeam(TryID)) then
								if Spring.ValidUnitID(TryID) and isUnitComplete(TryID) and _G.ONS.FromCenter[TryID] then
									if Spring.GetUnitSeparation(UnitID,TryID,true)<MaxLinkDist then
										isEnemyNear=true
									end
								end
							end
						end
					end
					if isEnemyNear then
						RedShield=true
						GreenShield=false
						Shielded=false
					else
						RedShield=false
						GreenShield=true
						Shielded=true
					end
				end
			end

			if DisabledForTeam[Spring.GetUnitTeam(UnitID)] then
				Shielded=false
				GreenShield=false
				RedShield=false
			end

			-- ONS_TeamMaxLinks moved to TeamRulesParams
			--if _G.ONS.TeamMaxLinks and _G.ONS.TeamMaxLinks[Spring.GetUnitTeam(UnitID)] then
			--	Spring.SetUnitRulesParam(UnitID,"ONS_TeamMaxLinks",_G.ONS.TeamMaxLinks[Spring.GetUnitTeam(UnitID)])
			--end
			if Shielded then
				Spring.SetUnitRulesParam(UnitID,"ONS_Shielded",1)
			else
				Spring.SetUnitRulesParam(UnitID,"ONS_Shielded",0)
			end
			if _G.ONS and _G.ONS.FromCenter and _G.ONS.FromCenter[UnitID] then
				Spring.SetUnitRulesParam(UnitID,"ONS_FromCenter",_G.ONS.FromCenter[UnitID])
			end
			if SourceFound then
				Spring.SetUnitRulesParam(UnitID,"ONS_SourceID",SourceID)
			end
			if _G.ONS and _G.ONS.FromExtremity and _G.ONS.FromExtremity[UnitID] then
				Spring.SetUnitRulesParam(UnitID,"ONS_FromExtremity",_G.ONS.FromExtremity[UnitID])
			end
			if _G.ONS and _G.ONS.isExtremity and _G.ONS.isExtremity[UnitID]~=nil then
				if _G.ONS.isExtremity[UnitID]==true then
					Spring.SetUnitRulesParam(UnitID,"ONS_isExtremity",1)
				end
				if _G.ONS.isExtremity[UnitID]==false then
					Spring.SetUnitRulesParam(UnitID,"ONS_isExtremity",0)
				end
			end

		end
	end
	CacheUnitONSInfo[UnitID]={UnitExists,Shielded,GreenShield,RedShield,SourceFound,SourceID}
	return unpack(CacheUnitONSInfo[UnitID])
end

GG.GetUnitONSInfo = GetUnitONSInfo

function gadget:UnitDestroyed(u,ud,team)
	if _G.ONS then-- This check for /luarules reload
		if isAnyBuilding[ud] then
			UpdateONS=true
		end
		if _G.ONS.FromCenter[ud] then
			_G.ONS.FromCenter[ud]=nil
		end
		if _G.ONS.FromExtremity[ud] then
			_G.ONS.FromExtremity[ud]=nil
		end
		if _G.ONS.isExtremity[ud] then
			_G.ONS.isExtremity[ud]=nil
		end
	end
end


function gadget:UnitFinished(u,ud,team)
	if isAnyBuilding[ud] then
		UpdateONS=true
	end
end

function gadget:UnitTaken(u,ud,team,newteam)
	if isAnyBuilding[ud] then
		UpdateONS=true
	end
end

function gadget:UnitGiven(u,ud,team,oldteam)
	if isAnyBuilding[ud] then
		UpdateONS=true
	end
end

function gadget:UnitDamaged(u, ud, team, damage)
	if damage>0.0001 and isAnyBuilding[ud] then
		local UnitExists,Shielded,GreenShield,RedShield,SourceFound,SourceID=GetUnitONSInfo(u)
		if Shielded then
			local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(u)
			Spring.SetUnitHealth(u,maxHealth)
		end
	end
end

else

--UNSYNCED

local LinkPathsList = nil
local LinkBeamsList = nil
local usUpdates = nil

local function DrawGroundHuggingStripeVertices(x1,z1,x2,z2,Width,HoverHeight)
	local x,z,d,dx,dz,pdx,pdz,it

	-- Get length of stripe
	d=math.sqrt((x1-x2)*(x1-x2)+(z1-z2)*(z1-z2))

	-- Get normalised orthogonal vector
	pdx=(z2-z1)/d*Width/2
	pdz=(x1-x2)/d*Width/2

	-- Get number of iterations
	it=d/Width

	-- Get step increment
	dx=(x2-x1)/d*Width
	dz=(z2-z1)/d*Width

	-- Init the loop variables
	x=x1
	z=z1
	for i=0,it,1 do
		gl.Vertex(x+pdx,HoverHeight+math.max(Spring.GetGroundHeight(x+pdx-dx,z+pdz-dz),Spring.GetGroundHeight(x+pdx,z+pdz),Spring.GetGroundHeight(x+pdx+dx,z+pdz+dz)),z+pdz)
		gl.Vertex(x-pdx,HoverHeight+math.max(Spring.GetGroundHeight(x-pdx-dx,z-pdz-dz),Spring.GetGroundHeight(x-pdx,z-pdz),Spring.GetGroundHeight(x-pdx+dx,z-pdz+dz)),z-pdz)
		x=x+dx
		z=z+dz
	end
end

local function DrawGroundHuggingStripe(red,green,blue,alpha,x1,z1,x2,z2,Width,HoverHeight)
	gl.Blending(GL.ONE,GL.ONE) -- KDR_11k: Multiply the source (=being drawn) with ONE and add it to the destination (=image before) multiplied by ONE
	gl.Color(red,green,blue,alpha)
	gl.DepthTest(GL.LEQUAL)
	gl.BeginEnd(GL.QUAD_STRIP,DrawGroundHuggingStripeVertices,x1,z1,x2,z2,Width,HoverHeight)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

local function DrawGroundHuggingSquareVertices(x,z,Width,HoverHeight)
	local y=HoverHeight+Spring.GetGroundHeight(x,z)
	gl.Vertex(x-Width,y,z-Width)
	gl.Vertex(x-Width,y,z+Width)
	gl.Vertex(x+Width,y,z+Width)
	gl.Vertex(x+Width,y,z-Width)
end

local function DrawGroundHuggingSquare(red,green,blue,alpha,x,z,Width,HoverHeight)
	gl.Blending(GL.ONE,GL.ONE) -- KDR_11k: Multiply the source (=being drawn) with ONE and add it to the destination (=image before) multiplied by ONE
	gl.Color(red,green,blue,alpha)
	gl.DepthTest(GL.LEQUAL)
	gl.BeginEnd(GL.QUADS,DrawGroundHuggingSquareVertices,x,z,Width,HoverHeight)
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

-- Draw Geo Webs
local function DrawLinkPaths()
	if SYNCED.ONS and SYNCED.ONS.LinkPaths then
		for _,WebThread in sipairs(SYNCED.ONS.LinkPaths) do
			DrawGroundHuggingStripe(1,0,1,1,WebThread.x1,WebThread.z1,WebThread.x2,WebThread.z2,32,8)
			DrawGroundHuggingSquare(1,0,1,1,WebThread.x1,WebThread.z1,64,8)
			DrawGroundHuggingSquare(1,0,1,1,WebThread.x2,WebThread.z2,64,8)
		end
	end
end

local function ProduitVectoriel(x1,y1,z1,x2,y2,z2,norm) -- Dunno the english name
-- I'm not even sure that's really the scalar product formula
	local x,y,z=y1*z2-z1*y2,z1*x2-x1*z2,x1*y2-x2*y1
	local d=math.sqrt(x*x+y*y+z*z)
	if not norm then
		return x,y,z
	else
		return norm*x/d,norm*y/d,norm*z/d
	end
end

local function DrawSingleLinkBeamQuadVertices(EndPoints,Width)
	local Colors={}
	if EndPoints[1].TeamID~=EndPoints[2].TeamID then
		for k=1,2 do
			if EndPoints[k] and EndPoints[k].TeamID and Spring.GetTeamColor(EndPoints[k].TeamID) then
				Colors[k]={Spring.GetTeamColor(EndPoints[k].TeamID)}
				Colors[k]={Colors[k][1],Colors[k][2],Colors[k][3],1}
			else
				Colors[k]={1,1,1,1}
			end
			if EndPoints[k].Disabled then
				Colors[k]={0,0,0,1}
			end
		end
	end
	local myPi=3.141592653589793
	local x1,y1,z1=EndPoints[1].x,EndPoints[1].y,EndPoints[1].z -- Start point
	local x2,y2,z2=EndPoints[2].x,EndPoints[2].y,EndPoints[2].z -- End point
	local xb,yb,zb=x2-x1,y2-y1,z2-z1 -- Vector from start to end
	local d=math.sqrt(xb*xb+yb*yb+zb*zb) -- Distance from start to end
	local xd,yd,zd=ProduitVectoriel(xb,yb,zb,0-zb,0,xb,d/2) -- Vector from middle to center, going down
	local xc,yc,zc=(x1+x2)/2+xd,(y1+y2)/2+yd,(z1+z2)/2+zd -- Center of the beam arc
	local FlatDistance=math.sqrt(xb*xb+zb*zb)
	local ArcRadius=d*math.sqrt(2)/2
	local ArcLength=ArcRadius/2*myPi
	local NbrIterations=64--math.floor(ArcLength/Width)
	local AngleInc=myPi/(2*NbrIterations)
	local x,y,z,p
	local xc1=xc+(zb*Width/2)/FlatDistance-- like xc, but shifted left by Width/2
	local zc1=zc-(xb*Width/2)/FlatDistance-- like zc, but shifted left by Width/2
	local xc2=xc-(zb*Width/2)/FlatDistance-- like xc, but shifted right by Width/2
	local zc2=zc+(xb*Width/2)/FlatDistance-- like zc, but shifted right by Width/2
	local a=nil
	for i=1,NbrIterations,1 do
		if true or Spring.GetPositionLosState(x,z,y) then

			if EndPoints[1].TeamID~=EndPoints[2].TeamID then
				gl.Color(
					(Colors[1][1]*i+Colors[2][1]*(NbrIterations-i))/NbrIterations,
					(Colors[1][2]*i+Colors[2][2]*(NbrIterations-i))/NbrIterations,
					(Colors[1][3]*i+Colors[2][3]*(NbrIterations-i))/NbrIterations,
					(Colors[1][4]*i+Colors[2][4]*(NbrIterations-i))/NbrIterations)
			end

			-- Use below to optimise
			local cos1=math.cos(myPi/4+math.asin((y2-y1)/d)+(i-1)*myPi/(2*NbrIterations))
			local sin1=math.sin(myPi/4+math.asin((y2-y1)/d)+(i-1)*myPi/(2*NbrIterations))
			local cos2=math.cos(myPi/4+math.asin((y2-y1)/d)+i*myPi/(2*NbrIterations))
			local sin2=math.sin(myPi/4+math.asin((y2-y1)/d)+i*myPi/(2*NbrIterations))

			-- radial quad
			gl.TexCoord(0,0)
			gl.Vertex(	xc+(ArcRadius-Width/2)*cos1*xb/FlatDistance,
						yc+(ArcRadius-Width/2)*sin1,
						zc+(ArcRadius-Width/2)*cos1*zb/FlatDistance)
			gl.TexCoord(0,1)
			gl.Vertex(	xc+(ArcRadius+Width/2)*cos1*xb/FlatDistance,
						yc+(ArcRadius+Width/2)*sin1,
						zc+(ArcRadius+Width/2)*cos1*zb/FlatDistance)
			gl.TexCoord(1,1)
			gl.Vertex(	xc+(ArcRadius+Width/2)*cos2*xb/FlatDistance,
						yc+(ArcRadius+Width/2)*sin2,
						zc+(ArcRadius+Width/2)*cos2*zb/FlatDistance)
			gl.TexCoord(1,0)
			gl.Vertex(	xc+(ArcRadius-Width/2)*cos2*xb/FlatDistance,
						yc+(ArcRadius-Width/2)*sin2,
						zc+(ArcRadius-Width/2)*cos2*zb/FlatDistance)

			-- perimetral quad
			gl.TexCoord(0,0)
			gl.Vertex(	xc1+(ArcRadius)*cos1*xb/FlatDistance,
						yc+(ArcRadius)*sin1,
						zc1+(ArcRadius)*cos1*zb/FlatDistance)
			gl.TexCoord(0,1)
			gl.Vertex(	xc2+(ArcRadius)*cos1*xb/FlatDistance,
						yc+(ArcRadius)*sin1,
						zc2+(ArcRadius)*cos1*zb/FlatDistance)
			gl.TexCoord(1,1)
			gl.Vertex(	xc2+(ArcRadius)*cos2*xb/FlatDistance,
						yc+(ArcRadius)*sin2,
						zc2+(ArcRadius)*cos2*zb/FlatDistance)
			gl.TexCoord(1,0)
			gl.Vertex(	xc1+(ArcRadius)*cos2*xb/FlatDistance,
						yc+(ArcRadius)*sin2,
						zc1+(ArcRadius)*cos2*zb/FlatDistance)
			gl.TexCoord(0,0)

		end
	end
end


local function DrawSingleLinkBeamVertices(EndPoints,Width)
	local Colors={}
	if EndPoints[1].TeamID~=EndPoints[2].TeamID then
		for k=1,2 do
			if EndPoints[k] and EndPoints[k].TeamID and Spring.GetTeamColor(EndPoints[k].TeamID) then
				Colors[k]={Spring.GetTeamColor(EndPoints[k].TeamID)}
				Colors[k]={Colors[k][1],Colors[k][2],Colors[k][3],1}
			else
				Colors[k]={1,1,1,1}
			end
			if EndPoints[k].Disabled then
				Colors[k]={0,0,0,1}
			end
		end
	end
	local myPi=3.141592653589793
	local x1,y1,z1=EndPoints[1].x,EndPoints[1].y,EndPoints[1].z -- Start point
	local x2,y2,z2=EndPoints[2].x,EndPoints[2].y,EndPoints[2].z -- End point
	local xb,yb,zb=x2-x1,y2-y1,z2-z1 -- Vector from start to end
	local d=math.sqrt(xb*xb+yb*yb+zb*zb) -- Distance from start to end
	local xd,yd,zd=ProduitVectoriel(xb,yb,zb,0-zb,0,xb,d/2) -- Vector from middle to center, going down
	local xc,yc,zc=(x1+x2)/2+xd,(y1+y2)/2+yd,(z1+z2)/2+zd -- Center of the beam arc
	local FlatDistance=math.sqrt(xb*xb+zb*zb)
	local ArcRadius=d*math.sqrt(2)/2
	local ArcLength=ArcRadius/2*myPi
	local NbrIterations=math.floor(ArcLength/Width)
	local AngleInc=myPi/(2*NbrIterations)
	local x,y,z,p
	local a=myPi/4+math.asin((y2-y1)/d)
	for i=0,NbrIterations,1 do
		if EndPoints[1].TeamID~=EndPoints[2].TeamID then
			gl.Color(
				(Colors[1][1]*i+Colors[2][1]*(NbrIterations-i))/NbrIterations,
				(Colors[1][2]*i+Colors[2][2]*(NbrIterations-i))/NbrIterations,
				(Colors[1][3]*i+Colors[2][3]*(NbrIterations-i))/NbrIterations,
				(Colors[1][4]*i+Colors[2][4]*(NbrIterations-i))/NbrIterations)
		end
		x=xc+ArcRadius*math.cos(a)*xb/FlatDistance
		y=yc+ArcRadius*math.sin(a)
		z=zc+ArcRadius*math.cos(a)*zb/FlatDistance
		if true or Spring.GetPositionLosState(x,z,y) then
			-- Spring.Echo("x="..math.floor(x)..", y="..math.floor(y)..", z="..math.floor(z).."")
			gl.Vertex(x,y,z)
		end
		a=a+AngleInc
	end
end

local function DrawSingleLinkBeamVerticesOld(EndPoints,Width)
	local myPi=3.141592653589793
	-- local xc=(EndPoints[1].x+EndPoints[2].x)/2
	-- local yc=(EndPoints[1].y+EndPoints[2].y)/2
	-- local zc=(EndPoints[1].z+EndPoints[2].z)/2
	local FlatDistance=math.sqrt((EndPoints[1].x-EndPoints[2].x)*(EndPoints[1].x-EndPoints[2].x)+(EndPoints[1].z-EndPoints[2].z)*(EndPoints[1].z-EndPoints[2].z))
	local Distance=math.sqrt(FlatDistance*FlatDistance+(EndPoints[1].y-EndPoints[2].y)*(EndPoints[1].y-EndPoints[2].y))
	local ArcRadius=Distance/2
	local ArcLength=ArcRadius/2*myPi
	local NbrIterations=math.floor(ArcLength/Width)
	local AngleInc=myPi/NbrIterations
	local a=math.asin(EndPoints[2].y-EndPoints[1].y/Distance)
	-- Spring.Echo("EndPoints = {x1="..EndPoints[1].x..",y1="..EndPoints[1].y..",z1="..EndPoints[1].z.."} {x2="..EndPoints[2].x..",y2="..EndPoints[2].y..",z2="..EndPoints[2].z.."}}")
	-- Spring.Echo("EndPoints[2].y-EndPoints[1].y="..EndPoints[2].y-EndPoints[1].y)
	-- Spring.Echo("FlatDistance="..math.floor(FlatDistance).." Distance="..math.floor(Distance).." a="..a)
	local x,y,z,p
	a=0
	for i=0,NbrIterations,1 do
		p=(math.cos(a)+1)/2
		x=p*EndPoints[1].x+(1-p)*EndPoints[2].x
		z=p*EndPoints[1].z+(1-p)*EndPoints[2].z
		y=p*EndPoints[1].y+(1-p)*EndPoints[2].y+math.sin(a)*ArcRadius/2
		if true or Spring.GetPositionLosState(x,z,y) then
			-- Spring.Echo("x="..math.floor(x)..", y="..math.floor(y)..", z="..math.floor(z).."")
			gl.Vertex(x,y,z)
		end
		a=a+AngleInc
	end
end

local function DrawSingleLinkBeam(Beam)
	local EndPoints,Color
	gl.Blending(GL.ONE,GL.ONE) -- KDR_11k: Multiply the source (=being drawn) with ONE and add it to the destination (=image before) multiplied by ONE
	gl.DepthTest(GL.LEQUAL)
	EndPoints=Beam -- EndPoints is like Beam but without color. No point in wasting time removing them though.
	Color={1,1,1,1}
	if Beam[2].TeamID and Spring.GetTeamColor(Beam[2].TeamID) then
		Color={Spring.GetTeamColor(Beam[2].TeamID)}
	end
	-- Color={0.4+0.6*Color[1],0.4+0.6*Color[2],0.4+0.6*Color[3],1}
	Color={Color[1],Color[2],Color[3],1}
	Color[4]=1
	gl.Color(unpack(Color))
	gl.Texture(":a:bitmaps/kpsfx/linkbeam.tga")
	gl.BeginEnd(GL.QUADS,DrawSingleLinkBeamQuadVertices,EndPoints,10)
	gl.Texture(false)
	--gl.BeginEnd(GL.LINE_STRIP,DrawSingleLinkBeamVertices,EndPoints,10) -- Single Line
	gl.DepthTest(false)
	gl.Color(1,1,1,1)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end

-- Draw Link Beams
local function DrawLinkBeams()
	if SYNCED.ONS and SYNCED.ONS.LinkBeams then
		for _,Beam in sipairs(SYNCED.ONS.LinkBeams) do
			DrawSingleLinkBeam(Beam)
		end
	end
end

function gadget:DrawWorld()

	local ok=false
	if Spring.GetMapDrawMode()=="metal" then
		ok=true
	end
	local _,cmd=Spring.GetActiveCommand()
	if cmd and cmd<0 then
		for _,udid in ipairs(SmallBuilding) do
			if udid==-cmd then
				ok=true
			end
		end
	end
	if Spring.GetModOptions()["ons"] and Spring.GetModOptions()["ons"]=="1" then
		ok=false
	end
	if ok then -- When metal view or when placing a "SmallBuilding"
		if LinkPathsList==nil then
			LinkPathsList=gl.CreateList(DrawLinkPaths)
		end
		gl.CallList(LinkPathsList)
	else
		if LinkPathsList~=nil then
			gl.DeleteList(LinkPathsList)
			LinkPathsList=nil
		end
	end

	if SYNCED.ONS and (LinkBeamsList==nil or usUpdates ~=SYNCED.ONS.Updates) then
		if LinkBeamsList~=nil then
			gl.DeleteList(LinkBeamsList)
			LinkBeamsList=nil
		end
		LinkBeamsList=gl.CreateList(DrawLinkBeams)
		usUpdates = SYNCED.ONS.Updates
	end
	if LinkBeamsList~=nil then
		gl.CallList(LinkBeamsList)
	end

end

function gadget:Shutdown()
	if LinkBeamsList~=nil then
		gl.DeleteList(LinkBeamsList)
		LinkBeamsList=nil
	end
	if LinkPathsList~=nil then
		gl.DeleteList(LinkPathsList)
		LinkPathsList=nil
	end
end

function gadget:DrawScreenEffects()
	if false and SYNCED.ONS and Spring.IsCheatingEnabled() then -- Now included in custom tooltip
		-- Draw text displaying buildings link status
		for _,team in ipairs(Spring.GetTeamList()) do
			for _,id in ipairs(Spring.GetTeamUnitsByDefs(team,AnyBuilding)) do
				if isUnitComplete(id) then
					gl.Color(1,1,1,1)
					local tml="?"
					local FontSize=16
					local txtopt='o'
					local x,y=Spring.WorldToScreenCoords(Spring.GetUnitPosition(id))
					gl.Text("ID:"..id,x,y,FontSize,txtopt)
					y=y-FontSize
					if SYNCED.ONS.TeamMaxLinks and SYNCED.ONS.TeamMaxLinks[team] then
						tml=SYNCED.ONS.TeamMaxLinks[team]
					end
					if SYNCED.ONS.FromCenter and SYNCED.ONS.FromCenter[id] then
						gl.Text(SYNCED.ONS.FromCenter[id].."/"..tml.." links from center",x,y,FontSize,txtopt)
						y=y-FontSize
					end
					if SYNCED.ONS.FromExtremity and SYNCED.ONS.FromExtremity[id] then
						gl.Text(SYNCED.ONS.FromExtremity[id].."/"..tml.." links from extremity",x,y,FontSize,txtopt)
						y=y-FontSize
					end
					if SYNCED.ONS.isExtremity and SYNCED.ONS.isExtremity[id]~=nil then
						if SYNCED.ONS.isExtremity[id]==true then
							gl.Text("Is Extremity",x,y,FontSize,txtopt)
							y=y-FontSize
						end
						if SYNCED.ONS.isExtremity[id]==false then
							gl.Text("Is NOT Extremity",x,y,FontSize,txtopt)
							y=y-FontSize
						end
					end
				end
			end
		end
	end
end


end
