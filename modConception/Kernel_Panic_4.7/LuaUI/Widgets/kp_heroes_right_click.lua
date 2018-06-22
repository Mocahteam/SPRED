
function widget:GetInfo()
	return {
		name      = "Heroes Right Click",
		desc      = "Control the rest of your army while in Hero mode",
		author    = "zwzsg",
		date      = "November 11th, 2009",
		license   = "Free",
		layer     = 200,
		enabled   = true
	}
end

-- Right click on ground: move spam, heavy, arty, and cons that are neither building nor moving
-- Right click on ally: guard with spam, heavy, (not arty) and cons that are neither building nor moving
-- Right click on enemy: attack with spam, heavy, arty
-- Right click on datavent: build there

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

function widget:Initialize()
	if Spring.GetModOptions()["homf"] and Spring.GetModOptions()["homf"]~="0" then
		if (Spring.GetModOptions()["homf_rightclick"] or "1")=="0" then
			Spring.ReplaceMouseCursor("cursornormal","cursorshootnrunleft",false)
			widgetHandler:RemoveWidget()
		else
			Spring.ReplaceMouseCursor("cursornormal","cursorshootnrunright",false)
			WG.HeroRightClick=1
		end
	else
		widgetHandler:RemoveWidget()
	end
end

function widget:Shutdown()
	WG.HeroRightClick=nil
end

local marker_x,marker_z,marker_u,marker_time,marker_text = nil,nil,nil,nil,nil

local function Mark(label,x_or_u,z)
	if z then
		marker_x,marker_z=x_or_u,z
		marker_u=nil
	else
		marker_u=x_or_u
		marker_x,marker_z=nil,nil
	end
	marker_time=Spring.GetTimer()
	marker_text=label
end

function widget:MousePress(mx,my,button)
	if button==3 and not Spring.GetSpectatingState() then
		if mx and my then
			local kind,var = Spring.TraceScreenRay(mx,my,false,true)
			if kind=="ground" then
				local x,y,z=unpack(var)
				for _,f in ipairs(Spring.GetFeaturesInRectangle(x-32,z-32,x+32,z+32)) do
					if FeatureDefs[Spring.GetFeatureDefID(f)].name=="geovent" then
						var=f
						kind="feature"
					end
				end
			end
			if kind=="ground" then
				local x,y,z=unpack(var)
				local selection=Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),{unpack(spam),unpack(heavy),unpack(arty)})
				for _,u in ipairs(Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),cons)) do
					if not Spring.GetUnitIsBuilding(u) then
						local vx,_,vz=Spring.GetUnitVelocity(u)
						if vx*vx+vz*vz<=0.0001 then
							table.insert(selection,u)
						end
					end
				end
				Spring.GiveOrderToUnitArray(selection,CMD.MOVE,{x,y,z},{})
				Mark("\255\32\255\32Move",x,z)
				return true
			end
			if kind=="unit" then
				local x,y,z=Spring.GetUnitPosition(var)
				if Spring.AreTeamsAllied(Spring.GetUnitTeam(var),Spring.GetMyTeamID()) then
					local selection=Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),{unpack(spam),unpack(heavy)})
					for _,u in ipairs(Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),cons)) do
						if not Spring.GetUnitIsBuilding(u) then
							local vx,_,vz=Spring.GetUnitVelocity(u)
							if vx*vx+vz*vz<=0.0001 then
								table.insert(selection,u)
							end
						end
					end
					Spring.GiveOrderToUnitArray(selection,CMD.GUARD,{var},{})
					Mark("\255\32\128\255Guard",var)
					return true
				else
					local selection=Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),{unpack(spam),unpack(heavy),unpack(arty)})
					Spring.GiveOrderToUnitArray(selection,CMD.ATTACK,{var},{})
					Mark("\255\255\32\32Attack",var)
					return true
				end
			end
			if kind=="feature" and FeatureDefs[Spring.GetFeatureDefID(var)].name=="geovent" then
				local selection=Spring.GetTeamUnitsByDefs(Spring.GetMyTeamID(),cons)
				for k=#selection,1,-1 do
					if Spring.GetUnitIsBuilding(selection[k]) then
						table.remove(selection,k)
					end
				end
				if #selection>1 then
					local u=selection[math.random(1,#selection)]
					local ud=Spring.GetUnitDefID(u)
					local WhatToBuild=nil
					if ud==assembler then
						WhatToBuild=socket
					elseif ud==trojan then
						WhatToBuild=window
					elseif ud==trojanold then
						WhatToBuild=windowold
					elseif ud==gateway then
						WhatToBuild=port
					elseif ud==alice then
						WhatToBuild=thminifac
					end
					if WhatToBuild then
						local x,_,z=Spring.GetFeaturePosition(var)
						local y=Spring.GetGroundHeight(x,z)
						local facing
						if math.abs(Game.mapSizeX - 2*x)>math.abs(Game.mapSizeZ - 2*z) then
							if (2*x>Game.mapSizeX) then
								facing=3
							else
								facing=1
							end
						else
							if (2*z>Game.mapSizeZ) then
								facing=2
							else
								facing=0
							end
						end
						Spring.GiveOrderToUnit(u,-WhatToBuild,{x,y,z,facing},{})
						Mark("\255\128\255\196Build",x,z)
						return true
					end
				else
					local x,_,z=Spring.GetFeaturePosition(var)
					Mark("\255\196\128\255No builder\n\255\196\128\255available!",x,z)
					return true
				end
			end
		end
	end
	return false
end

function widget:DrawScreen()
	if not Spring.IsGUIHidden() then
		if marker_time then
			if Spring.DiffTimers(Spring.GetTimer(),marker_time)>5 or (marker_u and not Spring.ValidUnitID(marker_u)) then
				marker_x,marker_z,marker_u,marker_time,marker_text = nil,nil,nil,nil,nil
			else
				local x,y,z=0,0,0
				if marker_u then
					x,y,z=Spring.GetUnitPosition(marker_u)
					y=y+Spring.GetUnitHeight(marker_u)
				else
					x,z=marker_x,marker_z
					y=Spring.GetGroundHeight(x,z)
				end
				local sx,sy=Spring.WorldToScreenCoords(x,y,z)
				gl.Text(marker_text.."\255\255\255\255",sx,sy,32,"ocv")
			end
		end
	end
end
























