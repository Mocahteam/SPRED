-- $Id: mission_gui.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Camera Auto",
    desc      = "",
    author    = "muratet",
    date      = "Jul 15, 2012",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true --  loaded by default?
  }
end

local level = Spring.GetModOptions()["level"] -- get the level
local cameraAutoEnabled = false
local specialPositions = {}

function abs(num)
	if num < 0 then
		return -num
	else
		return num
	end
end

function CameraAuto (enable, specialPos)
	cameraAutoEnabled = enable
	specialPositions = specialPos
end

function widget:GameFrame( frameNumber )
	if frameNumber%4 == 0 and cameraAutoEnabled then
		local state = Spring.GetCameraState()
		if state.mode == 1 then
			local xMin, zMin, xMax, zMax = Game.mapSizeX, Game.mapSizeZ, 0, 0
			local cpt = 0
			-- compute all visible units
			for _,u in ipairs(Spring.GetAllUnits()) do
				local x, y, z = Spring.GetUnitPosition(u)
				if cpt == 0 then
					xMin, zMin, xMax, zMax = x-20, z-20, x+20, z+20
					cpt = cpt + 1
				else
					if x-20 < xMin then xMin = x-20 end
					if x+20 > xMax then xMax = x+20 end
					if z-20 < zMin then zMin = z-20 end
					if z+20 > zMax then zMax = z+20 end
				end
			end
			-- compute all special positions
			for _,p in ipairs(specialPositions) do
				local x, z = p[1], p[2]
				if x-100 < xMin then xMin = x-100 end
				if x+100 > xMax then xMax = x+100 end
				if z-100 < zMin then zMin = z-100 end
				if z+100 > zMax then zMax = z+100 end
			end
				
			-- set camera position to the middle of all units
			state.px = xMin+(xMax-xMin)/2
			state.pz = zMin+(zMax-zMin)/2
			state.py = Spring.GetGroundHeight(state.px, state.pz)
			
			-- Warning : map origin is the upper left corner, camera origin is the lower left corner => proj_xMin, proj_yMax = projection(xMin, zMin)
			local proj_xMin, proj_yMax = Spring.WorldToScreenCoords(xMin, Spring.GetGroundHeight(xMin, zMin), zMin)
			local proj_xMax, proj_yMin = Spring.WorldToScreenCoords(xMax, Spring.GetGroundHeight(xMax, zMax), zMax)
			
			local xView, yView = Spring.GetViewGeometry()
			
			-- compute camera height
			if proj_xMin < 0 or proj_yMin < 0 or proj_xMax > xView or proj_yMax > yView then
				-- move back camera because some units aren't in view
				local maxDist = abs(proj_xMin)
				if maxDist < abs(proj_yMin) then
					maxDist = abs(proj_yMin)
				end
				if maxDist < proj_xMax then
					maxDist = proj_xMax
				end
				if maxDist < proj_yMax then
					maxDist = proj_yMax
				end
				state.height = state.height + maxDist/100*state.height/100
			else
				-- check if camera must be closer
				if proj_xMin > xView/5 and proj_yMin > yView/5 and proj_xMax < xView-xView/5 and proj_yMax < yView-yView/5 then
					if state.height >= 400 then
						-- compute minimal distance
						local minDist = proj_xMin
						if minDist > proj_yMin then
							minDist = proj_yMin
						end
						if minDist > proj_xMax then
							minDist = proj_xMax
						end
						if minDist > proj_yMax then
							minDist = proj_yMax
						end
						-- move camera closer
						state.height = state.height - minDist/50*state.height/100
					end
				end
			end
			Spring.SetCameraState(state, 2)
		end
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("CameraAuto", CameraAuto)
end


function widget:Shutdown()
	widgetHandler:DeregisterGlobal("CameraAuto")
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------