function widget:GetInfo()
	return {
		name = "Editor User Interface",
		desc = "User interface of the level editor",
		author = "zigaroula",
		date = "02/05/2016",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

VFS.Include("LuaUI/Widgets/editor/StateMachine.lua")
VFS.Include("LuaUI/Widgets/editor/Misc.lua")

-------------------------------------
-- UI Variables
-------------------------------------
local Chili, Screen0
local windows, buttons, teamButtons, unitButtons, fileButtons, labels, images, scrollPanels, editBoxes = {}, {}, {}, {}, {}, {}, {}, {}, {}
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {}

-------------------------------------
-- Draw selection tools
-------------------------------------
local selectionStartX, selectionStartY, selectionEndX, selectionEndY, gameSizeX, gameSizeY = 0, 0, 0, 0, 0, 0
local plotSelection = false
function widget:DrawScreenEffects(dse_vsx, dse_vsy) gameSizeX, gameSizeY = dse_vsx, dse_vsy end

-------------------------------------
-- Zone tools
-------------------------------------
local plotZone = false
local rValue, gValue, bValue = 0, 0, 0
local xA, xB, zA, zB = 0, 0, 0, 0
local zoneAnchorX, zoneAnchorZ = 0, 0
local zoneList = {}
local selectedZone = nil

-------------------------------------
-- Mouse tools
-------------------------------------
local mouseMove = false
local clickToSelect = false
local doubleClick = 0

-------------------------------------
-- Initialize ChiliUI
-------------------------------------
function initChili()
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end

	-- Get ready to use Chili
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

-------------------------------------
-- Add a window to a specific parent
-------------------------------------
function addWindow(_parent, _x, _y, _w, _h, _draggable)
	local window = Chili.Window:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _w,
		height = _h,
		draggable = _draggable or false,
		resizable = false
	}
	return window
end

-------------------------------------
-- Add an ImageButton to a specific parent
-------------------------------------
function addImageButton(_parent, _x, _y, _w, _h, imagePath, onClickFunction)
	local imageButton = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = false,
		OnClick = {onClickFunction}
	}
	return imageButton
end

-------------------------------------
-- Add an Button to a specific parent
-------------------------------------
function addButton(_parent, _x, _y, _w, _h, text, onClickFunction)
	local button = Chili.Button:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		OnClick = {onClickFunction}
	}
	return button
end

-------------------------------------
-- Add a label to a specific parent
-------------------------------------
function addLabel(_parent, _x, _y, _w, _h, text, size)
	local label = Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		fontsize = size or 20,
		align = "center"
	}
	return label
end

-------------------------------------
-- Add an Image to a specific parent
-------------------------------------
function addImage(_parent, _x, _y, _w, _h, imagePath)
	local image = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = false
	}
	return image
end

-------------------------------------
-- Add a colored Rectangle to a specific parent
-------------------------------------
function addRect(_parent, x1, y1, x2, y2, _color)
	local rect = Chili.Image:New {
		parent = _parent,
		x = x1,
		y = y1,
		width = x2 - x1,
		height = y2 - y1,
		file = "bitmaps/editor/blank.png",
		color = _color,
		keepAspect = false
	}
	return rect
end

-------------------------------------
-- Add a ScrollPanel to a specific parent
-------------------------------------
function addScrollPanel(_parent, _x, _y, _w, _h)
	local scrollPanel = Chili.ScrollPanel:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h
	}
	return scrollPanel
end

-------------------------------------
-- Add an EditBox to a specific parent
-------------------------------------
function addEditBox(_parent, _x, _y, _w, _h, _align, _text)
	local editBox = Chili.EditBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		align = _align or "left",
		text = _text or ""
	}
	return editBox
end

-------------------------------------
-- Top bar functions (show/hide panels)
-- TODO : Visual feedback for topBar buttons
-------------------------------------
function removeWindows()
	for key, w in pairs(windows) do
		if (key ~= "topBar") then
			Screen0:RemoveChild(w)
			windows.key = nil
		end
	end
end

function fileFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.FILE)
	
	windows['fileWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	labels['fileLabel'] = addLabel(windows['fileWindow'], '0%', '1%', '100%', '5%', "File")
	fileButtons['new'] = addButton(windows['fileWindow'], '0%', '10%', '100%', '10%', "New Map", function() newMap() end)
	fileButtons['load'] = addButton(windows['fileWindow'], '0%', '20%', '100%', '10%', "Load Map", function() loadMap("Missions/jsonFiles/Mission3.json") end)
end

function zoneFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.ZONE)
	zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAW)
	
	windows['zoneWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	labels['zoneLabel'] = addLabel(windows['zoneWindow'], '0%', '1%', '100%', '5%', "Zone")
	fileButtons['newZone'] = addButton(windows['zoneWindow'], '0%', '10%', '100%', '10%', "Draw new Zone", function() zoneStateMachine:setCurrentState(zoneStateMachine.states.DRAW) end)
end

function unitFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
	unitStateMachine:setCurrentState(unitStateMachine.states.DEFAULT)
	teamStateMachine:setCurrentState(teamStateMachine:getCurrentState())
	
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	scrollPanels['unitScrollPanel'] = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')

	-- Put unit states in an array to sort them alphabetically
	local unitStates = {}
	for k, u in pairs(unitStateMachine.states) do
		if k ~= "DEFAULT" then
			table.insert(unitStates, u)
		end
	end
	table.sort(unitStates)
	
	-- Unit buttons
	labels['unitLabel'] = addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', "Units")
	local button_size = 40
	local y = 0
	for i,u in ipairs(unitStates) do
		unitButtons[u] = addButton(scrollPanels['unitScrollPanel'], 0, y, '100%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
		y = y + button_size
	end
	
	-- Team buttons
	-- TODO : may require refactor (TBD)
	labels['teamLabel'] = addLabel(windows["unitWindow"], '0%', '87%', '100%', '5%', "Team")
	teamButtons[teamStateMachine.states.PLAYER] = addImageButton(windows["unitWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", teamFunctions[teamStateMachine.states.PLAYER])
	teamButtons[teamStateMachine.states.ALLY] = addImageButton(windows["unitWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", teamFunctions[teamStateMachine.states.ALLY])
	teamButtons[teamStateMachine.states.ENEMY] = addImageButton(windows["unitWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", teamFunctions[teamStateMachine.states.ENEMY])
	
	-- Selection image
	images['selectionType'] = addImage(unitButtons[unitStateMachine.states.DEFAULT], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
	images['selectionTeam'] = addImage(teamButtons[teamStateMachine:getCurrentState()], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function eventFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.EVENT)
	
	windows['editBoxWindow'] = addWindow(Screen0, '30%', '30%', '30%', '30%')
	labels['editBoxLabel'] = addLabel(windows['editBoxWindow'], '5%', '1%', '90%', '5%', "EditBox")
	editBoxes["editBox"] = addEditBox(windows['editBoxWindow'], '0%', '10%', '100%', 20)
end

function actionFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.ACTION)
end

function linkFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.LINK)
end

-----------------------
-- Tell the gadget to apply changes to units attributes
-----------------------
function applyChanges()
	local msg = "Change HP".."++"..editBoxes["unitAttributesHpField"].text
	Spring.SendLuaRulesMsg(msg)
end

-------------------------------------
-- Hide default GUI
-------------------------------------
function hideDefaultGUI()
	-- get rid of engine UI
	Spring.SendCommands("resbar 0", "tooltip 0","fps 0","console 0","info 0")
	-- leaves rendering duty to widget (we won't)
	gl.SlaveMiniMap(true)
	-- a hitbox remains for the minimap, unless you do this
	gl.ConfigMiniMap(0,0,0,0)
end

-------------------------------------
-- Top bar generation
-------------------------------------
function initTopBar()
	-- Top bar
	windows['topBar'] = addWindow(Screen0, '0%', '0%', '100%', '5%')
	
	-- Menu buttons
	buttons['file'] = addButton(windows["topBar"], '0%', '0%', '5%', '100%', 'File', fileFrame)
	buttons['units'] = addButton(windows["topBar"], '5%', '0%', '5%', '100%', 'Units', unitFrame)
	buttons['zones'] = addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Zones', zoneFrame)
	buttons['events'] = addButton(windows["topBar"], '15%', '0%', '5%', '100%', 'Events', eventFrame)
	buttons['actions'] = addButton(windows["topBar"], '20%', '0%', '5%', '100%', 'Actions', actionFrame)
	buttons['links'] = addButton(windows["topBar"], '25%', '0%', '5%', '100%', 'Links', linkFrame)
end

-------------------------------------
-- Generate functions for every units
-- Creates a function for every unitState to change state and handle selection feedback
-------------------------------------
function initUnitFunctions()
	for k, u in pairs(unitStateMachine.states) do
		unitFunctions[u] = function()
			globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
			unitStateMachine:setCurrentState(u)
			for key, ub in pairs(unitButtons) do
				ub:RemoveChild(images["selectionType"])
			end
			images['selectionType'] = addImage(unitButtons[u], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
		end
	end
end

-------------------------------------
-- Generate functions for every teams
-- Creates a function for every teamState to change state and handle selection feedback
-------------------------------------
function initTeamFunctions()
	for k, t in pairs(teamStateMachine.states) do
		teamFunctions[t] = function()
			teamStateMachine:setCurrentState(t)
			for _, tb in pairs(teamButtons) do
				tb:RemoveChild(images["selectionTeam"])
			end
			images['selectionTeam'] = addImage(teamButtons[t], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
			local msg = "Transfer Units".."++"..t
			Spring.SendLuaRulesMsg(msg)
		end
	end
end

-------------------------------------
-- Draw the selection feedback rectangle
-------------------------------------
function drawSelectionRect()
	if images["selectionRect"] ~= nil then
		Screen0:RemoveChild(images["selectionRect"])
	end
	if plotSelection then
		-- compute good values for x1, x2, y1, y2
		local x1, x2, y1, y2 = 0, 0, gameSizeY, gameSizeY
		if (selectionStartX <= selectionEndX and selectionStartY <= selectionEndY) then
			x1 = selectionStartX
			y1 = gameSizeY - selectionEndY
			x2 = selectionEndX
			y2 = gameSizeY - selectionStartY
		elseif (selectionStartX <= selectionEndX and selectionStartY >= selectionEndY) then
			x1 = selectionStartX
			y1 = gameSizeY - selectionStartY
			x2 = selectionEndX
			y2 = gameSizeY - selectionEndY
		elseif (selectionStartX >= selectionEndX and selectionStartY <= selectionEndY) then
			x1 = selectionEndX
			y1 = gameSizeY - selectionEndY
			x2 = selectionStartX
			y2 = gameSizeY - selectionStartY
		elseif (selectionStartX >= selectionEndX and selectionStartY >= selectionEndY) then
			x1 = selectionEndX
			y1 = gameSizeY - selectionStartY
			x2 = selectionStartX
			y2 = gameSizeY - selectionEndY
		end
		-- draw the rectangle
		images["selectionRect"] = addRect(Screen0, x1, y1, x2, y2, {0, 1, 1, 0.3})
	end
end

-------------------------------------
-- Draw the zone feedback rectangle
-------------------------------------
function drawZoneRect()
	if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAW then
		local _, _, leftPressed = Spring.GetMouseState()
		if leftPressed then
			local _,varA = Spring.TraceScreenRay(selectionStartX, selectionStartY, true, true)
			local _, varB = Spring.TraceScreenRay(selectionEndX, selectionEndY, true, true)
			if varA ~= nil and varB ~= nil then
				xA, _, zA = unpack(varA)
				xB, _, zB = unpack(varB)
			end
			xA, xB = sort(xA, xB)
			zA, zB = sort(zA, zB)
			if plotZone then
				gl.Color(rValue, gValue, bValue, 0.5)
				gl.DrawGroundQuad(xA, zA, xB, zB)
			end
		end
	end
	
	for i, z in ipairs(zoneList) do
		gl.Color(z.red, z.green, z.blue, 0.5)
		gl.DrawGroundQuad(z.x1, z.z1, z.x2, z.z2)
	end
	if selectedZone ~= nil then
		--gl.Color(0, 1, 0, 1)
		--gl.DrawGroundQuad(selectedZone.x1, selectedZone.z1, selectedZone.x1+1, selectedZone.z2)
	end
end

-------------------------------------
-- Show zone position
-------------------------------------
function showZonePosition()
	if selectedZone ~= nil then
		gl.BeginText()
		local x, y = Spring.WorldToScreenCoords(selectedZone.x1, Spring.GetGroundHeight(selectedZone.x1, selectedZone.z1) + 10, selectedZone.z1)
		local text =  "x:"..tostring(selectedZone.x1).." z:"..tostring(selectedZone.z1)
		gl.Text(text, x, y, 15, "s")
		x, y = Spring.WorldToScreenCoords(selectedZone.x2, Spring.GetGroundHeight(selectedZone.x2, selectedZone.z2) - 10, selectedZone.z2)
		text =  "x:"..tostring(selectedZone.x2).." z:"..tostring(selectedZone.z2)
		gl.Text(text, x, y, 15, "s")
		gl.EndText()
	end
end

-------------------------------------
-- Returns the clicked zone if it exists, else nil
-------------------------------------
function clickedZone(mx, my)
	local kind, var = Spring.TraceScreenRay(mx, my, true, true)
	local clickedZone = nil
	if var ~= nil then
		local x, _, z = unpack(var)
		for i, zone in ipairs(zoneList) do
			if x >= zone.x1 and x <= zone.x2 and z >= zone.z1 and z <= zone.z2 then
				clickedZone = zone
			end
		end
	end
	return clickedZone
end

-------------------------------------
-- Show information about specific units
-------------------------------------
function showInformation()
	-- Draw information about selected units (id, position)
	-- May be useful to replace markers in mission 3
	local unitSelection = Spring.GetSelectedUnits()
	gl.BeginText()
	for i, u in ipairs(unitSelection) do
		showUnitInformation(u)
	end
	gl.EndText()
	
	-- Draw information above hovered unit
	local mx, my = Spring.GetMouseState()
	local kind, var = Spring.TraceScreenRay(mx, my)
	if kind == "unit" then
		local isUnitSelected = false
		for _, u in ipairs(unitSelection) do
			if var == u then
				isUnitSelected = true
				break
			end
		end
		if not isUnitSelected then
			gl.BeginText()
			showUnitInformation(var)
			gl.EndText()
		end
	end
end

-------------------------------------
-- Hide mouse cursor in unit state and during movement, show another cursor in other states
-------------------------------------
function hideMouseCursor()
	local mouseCursor = Spring.GetMouseCursor()
	if mouseCursor ~= "none" then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and Screen0.hoveredControl == false then
			Spring.SetMouseCursor("none")
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION and mouseMove then
			Spring.SetMouseCursor("none")
		end
	elseif mouseCursor ~= "cursornormal" then
		Spring.SetMouseCursor("cursornormal") -- cursornormal, Guard, Move
	end
end

-------------------------------------
-- Draw units before placing them
-------------------------------------
function previewUnit()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT and Screen0.hoveredControl == false then
		local mx, my = Spring.GetMouseState()
		local kind, coords = Spring.TraceScreenRay(mx, my)
		if kind == "ground" then
			local x, _, z = unpack(coords)
			local unitDefID = UnitDefNames[unitStateMachine:getCurrentState()].id
			gl.DepthTest(GL.LEQUAL)
			gl.DepthMask(true)
			gl.PushMatrix()
			gl.Color(1, 1, 1, 0.7)
			gl.Translate(x, Spring.GetGroundHeight(x,z), z)
			gl.UnitShape(unitDefID, teamStateMachine:getCurrentState())
			gl.PopMatrix()
		end
	end
end

-------------------------------------
-- Show a window to edit unit's instance attributes
-------------------------------------
function showUnitAttributes(unitSelection)
	if #unitSelection > 0	and windows["unitAttributes"] == nil then
		windows["unitAttributes"] = addWindow(Screen0, gameSizeX - 200, "50%", 200, 200, true)
		labels["unitAttributesTitle"] = addLabel(windows["unitAttributes"], 0, 0, "100%", 20, "Attributes", 20)
		labels["unitAttributesHp"] = addLabel(windows["unitAttributes"], "70%", 50, "30%", 20, "%HP", 20)
		if #unitSelection == 1 then
			local h, mh = Spring.GetUnitHealth(unitSelection[1])
			editBoxes["unitAttributesHpField"] = addEditBox(windows["unitAttributes"], 0, 50, "65%", 20, "right", tostring(100*round(h/mh)))
		else
			editBoxes["unitAttributesHpField"] = addEditBox(windows["unitAttributes"], 0, 50, "65%", 20, "right")
		end
		buttons["unitAttributesApply"] = addButton(windows["unitAttributes"], 0, "85%", "100%", "15%", "Apply", applyChanges)
	elseif #unitSelection == 0 then
		Screen0:RemoveChild(windows["unitAttributes"])
		windows["unitAttributes"] = nil
	end
end

-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
	hideDefaultGUI()
	initChili()
	initTopBar()
	initUnitFunctions()
	initTeamFunctions()
	fileFrame()
end

-------------------------------------
-- Draw things on the screen
-------------------------------------
function widget:DrawScreen()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
		showInformation()
		hideMouseCursor()
		drawSelectionRect()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		showZonePosition()
	end
end

-------------------------------------
-- Draw things in the world
-------------------------------------
function widget:DrawWorld()
	if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
		previewUnit()
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		drawZoneRect()
	end
end

-------------------------------------
-- Update function
-------------------------------------
function widget:Update(delta)
	-- Tell the gadget which units are selected (might be improved in terms of performance)
	local unitSelection = Spring.GetSelectedUnits()
	local msg = "Select Units"
	for i, u in ipairs(unitSelection) do
		msg = msg.."++"..u
	end
	Spring.SendLuaRulesMsg(msg)
	
	-- Double click timer
	if doubleClick < 0.3 then
		doubleClick = doubleClick + delta
	end
	
	showUnitAttributes(unitSelection)
end

-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-------------------------------------
function widget:MousePress(mx, my, button)
	-- Left click
	if button == 1 then
		-- raycast
		local kind,var = Spring.TraceScreenRay(mx,my)
		
		-- STATE UNIT : place units on the field
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then			
			-- If ground is selected and we can place a unit, send a message to the gadget to create the unit
			if kind == "ground" then
				local xUnit, yUnit, zUnit = unpack(var)
				xUnit, yUnit, zUnit = round(xUnit), round(yUnit), round(zUnit)
				local msg = "Create Unit".."++"..unitStateMachine:getCurrentState().."++"..teamStateMachine:getCurrentState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
				Spring.SendLuaRulesMsg(msg)
			elseif kind == "unit" then
				for key, ub in pairs(unitButtons) do
					ub:RemoveChild(images["selectionType"])
				end
				globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
			end
		end
		
		-- STATE SELECTION : select and move units on the field
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
			if kind == "unit" then -- handle movement / selection
				if doubleClick < 0.3 then -- multiple selection of units of same type using double click
					local unitArray = Spring.GetTeamUnitsByDefs(Spring.GetUnitTeam(var), Spring.GetUnitDefID(var)) -- get units of same type and same team
					proceedSelection(unitArray)
					doubleClick = 0.3
					return true
				else
					if Spring.IsUnitSelected(var) then
						if proceedDeselection(var) then -- deselect the unit if shift is pressed
							return false
						else
							clickToSelect = true -- if the unit is already selected and shift is not pressed, allow isolation
						end
					else
						proceedSelection({var}) -- if the unit was not selected, select it and proceed movement
					end
					mouseMove = true
					Spring.SendLuaRulesMsg("Anchor".."++"..var)
					return true
				end
			else -- start a box selection
				proceedSelection({})
				plotSelection = true
				selectionStartX, selectionEndX = mx, mx
				selectionStartY, selectionEndY = my, my
				return true
			end
		end
		
		-- STATE ZONE : draw, move and rename logical zones
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAW then
				rValue, gValue, bValue = math.random(), math.random(), math.random()
				plotZone = true
				selectionStartX, selectionEndX = mx, mx
				selectionStartY, selectionEndY = my, my
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.SELECTION then
				if selectedZone ~= clickedZone(mx, my) then
					selectedZone = clickedZone(mx, my)
				end
				local _, var = Spring.TraceScreenRay(mx, my, true, true)
				local x, _, z = unpack(var)
				zoneAnchorX, zoneAnchorZ = x, z
				mouseMove = true
			end
			clickToSelect = true
			return true
		end
		
	-- Right click : enable selection / disable unit placement
	elseif button == 3 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
			for key, ub in pairs(unitButtons) do
				ub:RemoveChild(images["selectionType"])
			end
			globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
		end
	end
end

-------------------------------------
-- Handle mouse button releases
-------------------------------------
function widget:MouseRelease(mx, my, button)
	if button == 1 then
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
			-- raycast
			local kind, var = Spring.TraceScreenRay(mx, my)
			if kind == "unit" then
				if clickToSelect and doubleClick > 0.3 then -- isolate one unit if the mouse did not move during the process
					proceedSelection({var})
					clickToSelect = false
				end
			end
			-- return in idle state
			plotSelection = false
			mouseMove = false
		end
		
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if clickToSelect then
				selectedZone = clickedZone(mx, my)
				zoneStateMachine:setCurrentState(zoneStateMachine.states.SELECTION)
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAW then
				local zone = { red = rValue, green = gValue, blue = bValue, x1 = round(xA), x2 = round(xB), z1 = round(zA), z2 = round(zB) }
				table.insert(zoneList, zone)
			end
			plotZone = false
			mouseMove = false
		end
	end
	doubleClick = 0 -- reset double click timer
	return true
end

-------------------------------------
-- Handle mouse movements
-------------------------------------
function widget:MouseMove(mx, my, dmx, dmy, button)	
	-- disable click to select and double click if mousemove
	clickToSelect = false
	doubleClick = 0.3
	
	if button == 1 then
		-- STATE SELECTION
		if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
			-- If a unit is selected, send a message to the gadget to move it
			if mouseMove and not plotSelection then
				local _, pos = Spring.TraceScreenRay(mx, my, true)
				if pos ~=nil then
					local x, _, z = unpack(pos)
					x, z = round(x), round(z)
					local msg = "Move Units".."++"..x.."++"..z
					Spring.SendLuaRulesMsg(msg)
				end
			end
			-- update selection box
			if plotSelection then
				selectionEndX = mx
				selectionEndY = my
				-- Select all units in the rectangle
				local unitSelection = GetUnitsInScreenRectangle(selectionStartX, selectionStartY, selectionEndX, selectionEndY)
				proceedSelection(unitSelection)
			end
		end
		
		-- STATE ZONE
		if globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
			if zoneStateMachine:getCurrentState() == zoneStateMachine.states.DRAW then
				-- update zone
				if plotZone then
					selectionEndX = mx
					selectionEndY = my
				end
			elseif zoneStateMachine:getCurrentState() == zoneStateMachine.states.SELECTION then
				if mouseMove and selectedZone ~= nil then
					local _, var = Spring.TraceScreenRay(mx, my, true, true)
					if var ~= nil then
						local x, _, z = unpack(var)
						x, z = round(x), round(z)
						local dx, dz = round(x - zoneAnchorX), round(z - zoneAnchorZ)
						selectedZone.x1 = selectedZone.x1 + dx
						selectedZone.x2 = selectedZone.x2 + dx
						selectedZone.z1 = selectedZone.z1 + dz
						selectedZone.z2 = selectedZone.z2 + dz
						if dx ~= 0 then zoneAnchorX = x end
						if dz ~= 0 then zoneAnchorZ = z end
					end
				end
			end
		end
	end
end

-------------------------------------
-- Shortcuts
-------------------------------------
function widget:KeyPress(key, mods)
	-- Global 
	-- CTRL + S : save the current map
	if key == Spring.GetKeyCode("s") and mods.ctrl then
		saveMap()
	-- CTRL + O : load a map
	elseif key == Spring.GetKeyCode("o") and mods.ctrl then
		loadMap("Missions/jsonFiles/Mission3.json")
	-- CTRL + N : new map
	elseif key == Spring.GetKeyCode("n") and mods.ctrl then
		newMap()
	end
	-- Selection state
	if globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
		-- CTRL + A : select all units
		if key == Spring.GetKeyCode("a") and mods.ctrl then
			Spring.SelectUnitArray(Spring.GetAllUnits())
		-- DELETE : delete selected units
		elseif key == Spring.GetKeyCode("delete") then
			Spring.SendLuaRulesMsg("Delete Selected Units")
		-- ARROWS : move selected units
		elseif key == Spring.GetKeyCode("up") then
			local msg = "Translate Units".."++".."0".."++".."-1"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("down") then
			local msg = "Translate Units".."++".."0".."++".."1"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("left") then
			local msg = "Translate Units".."++".."-1".."++".."0"
			Spring.SendLuaRulesMsg(msg)
		elseif key == Spring.GetKeyCode("right") then
			local msg = "Translate Units".."++".."1".."++".."0"
			Spring.SendLuaRulesMsg(msg)
		end
	elseif globalStateMachine:getCurrentState() == globalStateMachine.states.ZONE then
		if selectedZone ~= nil then
			if key == Spring.GetKeyCode("delete") then
				-- TODO
			elseif key == Spring.GetKeyCode("up") then
				selectedZone.z1 = selectedZone.z1 - 1
				selectedZone.z2 = selectedZone.z2 - 1
			elseif key == Spring.GetKeyCode("down") then
				selectedZone.z1 = selectedZone.z1 + 1
				selectedZone.z2 = selectedZone.z2 + 1
			elseif key == Spring.GetKeyCode("left") then
				selectedZone.x1 = selectedZone.x1 - 1
				selectedZone.x2 = selectedZone.x2 - 1
			elseif key == Spring.GetKeyCode("right") then
				selectedZone.x1 = selectedZone.x1 + 1
				selectedZone.x2 = selectedZone.x2 + 1
			end
		end
	end
	return true
end