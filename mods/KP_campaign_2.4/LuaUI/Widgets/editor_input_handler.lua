function widget:GetInfo()
	return {
		name = "Editor Input Handler",
		desc = "Handle inputs (keyboard, mouse) in the level editor",
		author = "zigaroula",
		date = "02/05/2016",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()

end

---------------------------------------------------------------------------------------------------------------

local mouseMove = false

-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-- TOFIX : problem with interacting with briefing message
-------------------------------------
function widget:MousePress(mx, my, button)
	-- Raycasts
	local kind,var = Spring.TraceScreenRay(mx,my)
	local kind2, var2 = Spring.TraceScreenRay(mx,my,true)
	-- If ground is selected and we can place a unit, send a message to the gadget to create the unit
	if kind == "ground" and Script.LuaUI.getCurrentUnitState() ~= "idle" then
		local xUnit, yUnit, zUnit = unpack(var)
		local msg = "Create Unit".."++"..Script.LuaUI.getCurrentUnitState().."++"..Script.LuaUI.getCurrentTeamState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
		Spring.SendLuaRulesMsg(msg)
	-- If unit is selected, send a message to the gadget to store the unit and its position
	elseif kind == "unit" then
		local newX, newY, newZ = unpack(var2)
		local msg = "Select Unit".."++"..var.."++"..newX.."++"..newY.."++"..newZ
		Spring.SendLuaRulesMsg(msg)
		mouseMove = true
		return true
	end
end

-------------------------------------
-- Handle mouse button releases
-------------------------------------
function widget:MouseRelease(mx, my, button)
	-- Raycast
	local kind,var = Spring.TraceScreenRay(mx,my)
	-- Deselect selected unit
	if kind == "unit" then
		local msg = "Deselect Unit"
		Spring.SendLuaRulesMsg(msg)
		mouseMove = false
	end
	return true
end

-------------------------------------
-- Handle mouse movements
-------------------------------------
function widget:MouseMove(mx, my, dmx, dmy, button)
	-- Raycast
	local kind, var = Spring.TraceScreenRay(mx,my,true)
	-- If a unit is selected, send a message to the gadget to move it
	if mouseMove and var ~= nil then
		local newX, newY, newZ = unpack(var)
		local msg = "Move Unit".."++"..newX.."++"..newY.."++"..newZ
		Spring.SendLuaRulesMsg(msg)
	end
end
