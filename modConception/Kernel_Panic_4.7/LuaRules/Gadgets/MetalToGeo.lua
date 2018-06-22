function gadget:GetInfo()
	return {
		name = "Metal To Geo converter",
		desc = "Offer the possibility to turn metal spots into geo",
		author = "zwzsg, inspiration from KDR_11k (David Becker)",
		date = "March, 7th, 2009",
		license = "Public Domain",
		layer = 10,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

function gadget:Initialize()

	local GeoSpots = {}
	local geovent = FeatureDefNames.geovent.id
	local mingeomexdist = math.max(Game.extractorRadius,112)
	local mode = "auto"
	if Spring.GetModOptions() and Spring.GetModOptions()["metaltogeo"] then
		mode = Spring.GetModOptions()["metaltogeo"]
		if mode~="auto" and mode~="metal" and mode~="geo" and mode~="both" then
			mode = "auto"
		end
	end

	if mode=="auto" or mode=="both" then
		-- Create tables of Geos
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
					table.insert(GeoSpots, {x=x, y=y, z=z,})
				end
			end
		end
		if mode=="auto" then
			if #GeoSpots<4 or #GeoSpots<#Spring.GetTeamList()-1 then
				mode = "both"
			else
				mode = "geo"
			end
		end
	end

	if mode=="metal" then
		for _,f in ipairs(Spring.GetAllFeatures()) do
			if FeatureDefs[Spring.GetFeatureDefID(f)].name == "geovent" then
				getfenv(0).AllowUnsafeChanges("USE AT YOUR OWN PERIL")
				Spring.DestroyFeature(f)
				getfenv(0).AllowUnsafeChanges("Apparently you turn it off that way")
			end
		end
		GeoSpots = {}
	end

	if mode=="metal" or mode=="both" then
		getfenv(0).AllowUnsafeChanges("USE AT YOUR OWN PERIL")
		local minmetal, maxmetal = nil, nil
		for x = 16,Game.mapSizeX,32 do
			for z = 16,Game.mapSizeZ,32 do
				local _,m = Spring.GetGroundInfo(x,z)
				if not minmetal or m<minmetal then
					minmetal = m
				end
				if not maxmetal or m>maxmetal then
					maxmetal = m
				end
			end
		end
		local mediummetal = (maxmetal - minmetal)/2
		Spring.Echo("Metal: ["..maxmetal.."-"..minmetal.."]")
		if maxmetal == minmetal then
			local mingeomexdist = math.sqrt(Game.mapSizeX*Game.mapSizeZ/(4*#Spring.GetTeamList()))
			for x = mingeomexdist/2,Game.mapSizeX,mingeomexdist do
				for z = mingeomexdist/2,Game.mapSizeZ,mingeomexdist do
					table.insert(GeoSpots, {x=x, y=Spring.GetGroundHeight(x,z), z=z})
				end
			end
		else
			for x = 16,Game.mapSizeX,32 do
				for z = 16,Game.mapSizeZ,32 do
					local _,m = Spring.GetGroundInfo(x,z)
					if m >= mediummetal then
						local newSpot=true
						for _,g in ipairs(GeoSpots) do
							if math.sqrt((x-g.x)*(x-g.x) + (z-g.z)*(z-g.z)) < mingeomexdist then
								newSpot = false
								break
							end
						end
						if newSpot then
							table.insert(GeoSpots, {x=x, y=Spring.GetGroundHeight(x,z), z=z})
						end
					end
				end
			end
		end
		for _,g in ipairs(GeoSpots) do
			getfenv(0).AllowUnsafeChanges("USE AT YOUR OWN PERIL")
			Spring.CreateFeature("geovent", g.x, g.y, g.z)
			getfenv(0).AllowUnsafeChanges("Apparently you turn it off that way")
		end
	end

	gadgetHandler:RemoveGadget()

end

else

--UNSYNCED
return false

end
