local mouseMove = false

-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-------------------------------------
function widget:MousePress(mx, my, button)
	-- Left click
	if (button == 1) then
		-- STATE UNIT : place units on the field
		if globalStateMachine:getCurrentState() == "unit" then
			-- raycast
			local kind,var = Spring.TraceScreenRay(mx,my)
			-- If ground is selected and we can place a unit, send a message to the gadget to create the unit
			if kind == "ground" then
				local xUnit, yUnit, zUnit = unpack(var)
				local msg = "Create Unit".."++"..unitStateMachine:getCurrentState().."++"..teamStateMachine:getCurrentState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
				Spring.SendLuaRulesMsg(msg)
			end
		-- STATE SELECTION : select and move units on the field
		elseif globalStateMachine:getCurrentState() == "selection" then
			-- raycasts
			local kind,var = Spring.TraceScreenRay(mx,my)
			local kind2, var2 = Spring.TraceScreenRay(mx,my,true)
			-- If unit is selected, send a message to the gadget to store the unit and its position
			if kind == "unit" then
				local newX, newY, newZ = unpack(var2)
				local msg = "Select Unit".."++"..var.."++"..newX.."++"..newY.."++"..newZ
				Spring.SendLuaRulesMsg(msg)
				mouseMove = true -- proceed movement
				return true -- required to use MouseRelease and MouseMove
			end
		end
	-- Right click
	elseif (button == 3) then
		for key, ub in pairs(getUnitButtons()) do
			ub:RemoveChild(getImages()["selectionType"])
		end
		globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
	end
end

-------------------------------------
-- Handle mouse button releases
-------------------------------------
function widget:MouseRelease(mx, my, button)
	if globalStateMachine:getCurrentState() == "selection" then
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
end

-------------------------------------
-- Handle mouse movements
-------------------------------------
function widget:MouseMove(mx, my, dmx, dmy, button)
	if globalStateMachine:getCurrentState() == "selection" then
		-- Raycast
		local kind, var = Spring.TraceScreenRay(mx,my,true)
		-- If a unit is selected, send a message to the gadget to move it
		if mouseMove and var ~= nil then
			local newX, newY, newZ = unpack(var)
			local msg = "Move Unit".."++"..newX.."++"..newY.."++"..newZ
			Spring.SendLuaRulesMsg(msg)
		end
	end
end