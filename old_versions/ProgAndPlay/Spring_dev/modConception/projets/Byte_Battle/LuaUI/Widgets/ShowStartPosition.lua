-- $Id: mission_gui.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Set Camera to Start Position",
    desc      = "",
    author    = "muratet",
    date      = "Jan 15, 2009",
    license   = "GPL v2 or later",
    layer     = 91,
    enabled   = true --  loaded by default?
  }
end

-- You must import the KEYSYM table if you want to access keys by name
include('keysym.h.lua')

-----------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:KeyPress(key, mods, isRepeat, label, unicode)
	-- intercept TAB pressure
	if key == KEYSYMS.TAB then
		local state = Spring.GetCameraState()
		if state.mode == 7 then
			state.mode=1
			Spring.SetCameraState(state, 1)
			widgetHandler:RemoveWidget()
		end
		return true
	end
end

function widget:GameStart()
	-- point camera to the player start position...
	local x, y, z = Spring.GetTeamStartPosition(Spring.GetMyTeamID())
	local state = Spring.GetCameraState()
	state.px = x
	state.py = Spring.GetGroundHeight(x, z)
	state.pz = z+200
	state.height = 2300
	Spring.SetCameraState(state, 2)
	-- ... and put it in overview mode
	state.mode = 7
	Spring.SetCameraState(state, 2)
	-- for index,value in pairs(Spring.GetCameraState()) do
		-- Spring.Echo(index,value)
	-- end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------