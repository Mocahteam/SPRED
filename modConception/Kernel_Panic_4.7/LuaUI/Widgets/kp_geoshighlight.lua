

function widget:GetInfo()
	return {
		name = "Kernel Panic Geos Highlight",
		desc = "Highlight the Geovents when placing Buildings, or when in metal view",
		author = "zwzsg",
		date = "January 5th, 2009",
		license = "Public Domain",
		layer = 5,
		enabled = true
	}
end

VFS.Include("LuaRules/Gadgets/kpunittypes.lua",nil)

local GeoSpots={} -- List of coordinates of geos
local GeoDrawList = nil -- OpenGL Draw List
local GeoMiniMapDrawList = nil -- OpenGL Draw List
local TimeOfFirstDrawn = 0


function widget:Initialize()

	-- A variant of this widget is already included in the unsynched part of "ONS" mode option
	-- So we remove this widget if ONS is activated
	if Spring.GetModOptions()["ons"] and Spring.GetModOptions()["ons"]~="0" then
		--widgetHandler:RemoveWidget()
		--return
	end
	-- Bah, no, I let both widgets highlights the geos, each in its way

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
				table.insert(GeoSpots, {x=x, y=y, z=z})
			end
		end
	end

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
	gl.Blending(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA)
end

-- Draw Geos Highlight
local function DrawGeosEmplacement()
	for _,geo in ipairs(GeoSpots) do
		DrawGroundHuggingSquare(0.3,1,0.4,1,geo.x,geo.z,32,2)
	end
end

function widget:DrawWorld()
	local isPlayerPlacingBuilding=false
	local _,cmd=Spring.GetActiveCommand()
	if cmd and cmd<0 then
		for _,udid in ipairs(SmallBuilding) do
			if udid==-cmd then
				isPlayerPlacingBuilding=true
			end
		end
	end
	if isPlayerPlacingBuilding or Spring.GetMapDrawMode()=="metal" then -- When metal view or when placing a "SmallBuilding"
		if GeoDrawList==nil then
			GeoDrawList=gl.CreateList(DrawGeosEmplacement)
			TimeOfFirstDrawn=widgetHandler:GetHourTimer()
		end
		if (widgetHandler:GetHourTimer() - TimeOfFirstDrawn)%0.8<0.4 then
			gl.CallList(GeoDrawList)
		end
	else
		if GeoDrawList~=nil then
			gl.DeleteList(GeoDrawList)
			GeoDrawList=nil
		end
	end
end

-- Draw Mini Map Geos Highlight
local function MiniMapDrawGeosEmplacement()
	gl.PushMatrix()
	gl.LoadIdentity()
	gl.Translate(0,1,0)
	gl.Scale(1/Game.mapSizeX,-1/Game.mapSizeZ,1)
	for _,geo in ipairs(GeoSpots) do
		gl.PolygonMode(GL.FRONT_AND_BACK, GL.FILL) -- default
		gl.Rect(geo.x+32,geo.z+32,geo.x-32,geo.z-32)
		-- because rectangles disappear when smaller than one pixel, also draw a point
		gl.PointSize(1.0) -- default
		gl.BeginEnd(GL.POINTS,function()gl.Vertex(geo.x,geo.z)end)
	end
	gl.PopMatrix()
end

function widget:DrawInMiniMap(sx, sz)
	local isPlayerPlacingBuilding=false
	local _,cmd=Spring.GetActiveCommand()
	if cmd and cmd<0 then
		for _,udid in ipairs(SmallBuilding) do
			if udid==-cmd then
				isPlayerPlacingBuilding=true
			end
		end
	end
	if isPlayerPlacingBuilding or Spring.GetMapDrawMode()=="metal" then -- When metal view or when placing a "SmallBuilding"
		if GeoMiniMapDrawList==nil then
			GeoMiniMapDrawList=gl.CreateList(MiniMapDrawGeosEmplacement)
			-- TimeOfFirstDrawn=widgetHandler:GetHourTimer()
		end
		if (widgetHandler:GetHourTimer() - TimeOfFirstDrawn)%0.8<0.4 then
			gl.Color(0.3,1,0.4,1)
			gl.CallList(GeoMiniMapDrawList)
		else
			gl.Color(0.15,0.5,0.2,1)
			gl.CallList(GeoMiniMapDrawList)
		end
		gl.Color(1,1,1,1)
	else
		if GeoMiniMapDrawList~=nil then
			gl.DeleteList(GeoMiniMapDrawList)
			GeoMiniMapDrawList=nil
		end
	end
end

function widget:Shutdown()
	if GeoDrawList~=nil then
		gl.DeleteList(GeoDrawList)
		GeoDrawList=nil
	end
	if GeoMiniMapDrawList~=nil then
		gl.DeleteList(GeoMiniMapDrawList)
		GeoMiniMapDrawList=nil
	end
end

