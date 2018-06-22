
function gadget:GetInfo()
	return {
		name = "Pre-placed Minifacs",
		desc = "Cover datavents with minifacs at start of game",
		author = "zwzsg",
		date = "13th Nov, 2009",
		license = "Public Domain",
		layer = 0,
		enabled = true,
	}
end


if (gadgetHandler:IsSyncedCode()) then
--SYNCED

	VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

	local nospecials = Spring.GetModOptions()["nospecials"]
	nospecials = nospecials and (nospecials==true or nospecials==1 or nospecials=="1")


	function gadget:GameFrame(frame)
		if frame>2 then
			gadgetHandler:RemoveGadget()
		elseif frame==2 then

			-- Determine which teams will use preplaced
			local IsTeamPreplaced={}
			local PreplacedTeamCount=0
			for _,t in ipairs(Spring.GetTeamList()) do
				local _,_,_,_,_,_,CustomTeamOptions=Spring.GetTeamInfo(t)
				local preplaced=0
				if CustomTeamOptions and CustomTeamOptions["preplaced"] then
					preplaced=tonumber(CustomTeamOptions["preplaced"]) or 1
				else
					preplaced=tonumber(Spring.GetModOptions().preplaced) or 0
				end
				if preplaced~=0 then
					IsTeamPreplaced[t]=true
					PreplacedTeamCount=PreplacedTeamCount+1
				end
			end

			if PreplacedTeamCount>0 then
				-- Determine the minifac and special that will be placed for each team
				local LiveTeams={}
				local NbrClaimedByTeam={}
				local TeamMinifacType={}
				local TeamSpecialType={}
				local TeamSpecialOnFront={}
				for _,t in ipairs(Spring.GetTeamList()) do
					local HomeBaseKindCount={}
					local MostNumerous=nil
					for _,ud in ipairs(HomeBase) do
						local count=Spring.GetTeamUnitDefCount(t,ud)
						HomeBaseKindCount[ud]=(HomeBaseKindCount[ud] or 0)+count
						if count>0 and (not MostNumerous or HomeBaseKindCount[ud]>HomeBaseKindCount[MostNumerous]) then
							MostNumerous=ud
						end
					end
					if (not MostNumerous) and Spring.GetTeamUnitDefCount(t,hand)>0 then -- For RPS
						MostNumerous=hand
					end
					TeamSpecialOnFront[t]=false
					TeamMinifacType[t]=windowold
					TeamSpecialType[t]=windowold
					if MostNumerous then
						table.insert(LiveTeams,t)
						NbrClaimedByTeam[t]=0 -- 0 is true btw
						if MostNumerous==kernel then
							TeamMinifacType[t]=socket
							TeamSpecialType[t]=terminal
						elseif MostNumerous==hole then
							TeamMinifacType[t]=window
							TeamSpecialType[t]=obelisk
							TeamSpecialOnFront[t]=true
						elseif MostNumerous==holeold then
							TeamMinifacType[t]=windowold
							TeamSpecialType[t]=obelisk
							TeamSpecialOnFront[t]=true
						elseif MostNumerous==carrier then
							TeamMinifacType[t]=port
							TeamSpecialType[t]=firewall
						elseif MostNumerous==thbase then
							TeamMinifacType[t]=thminifac
							TeamSpecialType[t]=thminifac
						elseif MostNumerous==hand then
							TeamMinifacType[t]=hand
							TeamSpecialType[t]=firewall
						end
					end
				end

				-- Create tables of Free Spots
				local FreeSpots={}
				for _,f in ipairs(Spring.GetAllFeatures()) do
					if FeatureDefs[Spring.GetFeatureDefID(f)].name == "geovent" then
						local x,_,z = Spring.GetFeaturePosition(f)
						--Merging algorithm because some KP maps have multiple geos in one spot
						local NewSpot=true
						for _,g in ipairs(FreeSpots) do
							if math.sqrt((x-g.x)*(x-g.x) + (z-g.z)*(z-g.z)) < 64 then
								NewSpot = false
								break
							end
						end
						for _,u in ipairs(Spring.GetAllUnits()) do
							local ux,_,uz=Spring.GetUnitPosition(u)
							if math.sqrt((x-ux)*(x-ux) + (z-uz)*(z-uz)) < 64 then
								NewSpot = false
								break
							end
						end
						if NewSpot then
							x=x+math.random(1,33)-17
							z=z+math.random(1,33)-17
							table.insert(FreeSpots,{x=x,z=z,fid=f,dtts={}})
						end
					end
				end

				for _,g in ipairs(FreeSpots) do
					for _,t in ipairs(LiveTeams) do
						for _,u in ipairs(Spring.GetTeamUnitsByDefs(t,HomeBase)) do
							local x,_,z=Spring.GetUnitPosition(u)
							local d=math.sqrt((x-g.x)*(x-g.x)+(z-g.z)*(z-g.z))
							if not g.dtts[t] or d<g.dtts[t] then
								g.dtts[t]=d -- Distance to closest homebase of team
							end
						end
						if not g.dtts[t] then -- If no homebase then distance to team start pos
							local x,_,z=Spring.GetTeamStartPosition(t)
							g.dtts[t]=math.sqrt((x-g.x)*(x-g.x)+(z-g.z)*(z-g.z))
						end
					end
				end

				local SpotsPerTeam=math.floor(#FreeSpots/#LiveTeams)

				local SpotsByTeams={}
				for _,t in ipairs(LiveTeams) do
					SpotsByTeams[t]={}
				end

				if SpotsPerTeam>0 then

					for k=#FreeSpots,1,-1 do

						-- Find furthest and closest team to any spot
						for _,g in ipairs(FreeSpots) do
							g.ct=nil
							g.ft=nil
							for _,t in ipairs(LiveTeams) do
								if NbrClaimedByTeam[t] and (not g.ct or g.dtts[t]<g.dtts[g.ct]) then
									g.ct=t -- Team which still needs a spot and is the closest to this spot
								end
								if NbrClaimedByTeam[t] and (not g.ft or g.dtts[t]>g.dtts[g.ft]) then
									g.ft=t -- Team which still needs a spot and is the furthest of this spot
								end
							end
						end

						-- Remove the spot which is the least close to anything
						if k>SpotsPerTeam*#LiveTeams then
							table.sort(
								FreeSpots,
								function(a,b)
									return a.dtts[a.ct]<b.dtts[b.ct]
								end
							)
							table.remove(FreeSpots)

						-- Assign the spot which is the most far of something
						else
							table.sort(
								FreeSpots,
								function(a,b)
									return a.dtts[a.ft]<b.dtts[b.ft]
								end
							)
							local g=table.remove(FreeSpots)
							table.insert(SpotsByTeams[g.ct],g)

							NbrClaimedByTeam[g.ct]=NbrClaimedByTeam[g.ct]+1
							if NbrClaimedByTeam[g.ct]>=SpotsPerTeam then
								NbrClaimedByTeam[g.ct]=false
							end
						end
					end

					for _,t in ipairs(LiveTeams) do
						if IsTeamPreplaced[t] then
							TeamSpots=SpotsByTeams[t]
							table.sort(
								TeamSpots,
								function(a,b)
									return a.dtts[t]<b.dtts[t]
								end
							)
							for k,g in pairs(TeamSpots) do
								local dx = Game.mapSizeX/2 - g.x
								local dz = Game.mapSizeZ/2 - g.z
								local facing=0
								if math.abs(dz)>math.abs(dx) then
									if dz>0 then
										facing=0
									else
										facing=2
									end
								else
									if dx>0 then
										facing=1
									else
										facing=3
									end
								end
								local ud=TeamMinifacType[t]
								if SpotsPerTeam>=4 and not nospecials then
									-- If Front: furthest spot
									if (TeamSpecialOnFront[t] and k==SpotsPerTeam)
									-- if Rear: second closest spot
									or (k==2 and not TeamSpecialOnFront[t]) then
										ud=TeamSpecialType[t]
									end
								end
								local x,_,z = Spring.GetFeaturePosition(g.fid)
								Spring.CreateUnit(ud,16*math.floor((x+8)/16),Spring.GetGroundHeight(x,z),16*math.floor((z+8)/16),facing,t)
							end
						end
					end
				end
			end
		end
	end

end
