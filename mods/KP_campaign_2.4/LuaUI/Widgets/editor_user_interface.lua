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
local x1, x2, y1, y2 = 0, 0, gameSizeY, gameSizeY -- coordinates of the selection box

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
function addLabel(_parent, _x, _y, _w, _h, text)
	local label = Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		fontsize = 20,
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
function addEditBox(_parent, _x, _y, _w, _h)
	local editBox = Chili.EditBox:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h
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
-- Initialize the widget
-------------------------------------
function widget:Initialize()
	hideDefaultGUI()
	initChili()
	initTopBar()
	initUnitFunctions()
	initTeamFunctions()
end

-------------------------------------
-- Draw things on the screen
-------------------------------------
function widget:DrawScreen()
	showInformation()
	hideMouseCursor()
end

-------------------------------------
-- Draw things in the world
-------------------------------------
function widget:DrawWorld()
	previewUnit()
end


-------------------------------------
-- Update function
-------------------------------------
function widget:Update(delta)
	drawSelectionRect()
	
	-- Tell the gadget which units are selected (might be improved in terms of performance)
	local msg = "Select Units"
	for i, u in ipairs(Spring.GetSelectedUnits()) do
		msg = msg.."++"..u
	end
	Spring.SendLuaRulesMsg(msg)
	
	-- Double click timer
	if doubleClick < 0.3 then
		doubleClick = doubleClick + delta
	end
end

-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-------------------------------------
function widget:MousePress(mx, my, button)
	-- Left click
	if (button == 1) then
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
		
	-- Right click : enable selection / disable unit placement
	elseif (button == 3 and globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT) then
		for key, ub in pairs(unitButtons) do
			ub:RemoveChild(images["selectionType"])
		end
		globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
	end
end

-------------------------------------
-- Handle mouse button releases
-------------------------------------
function widget:MouseRelease(mx, my, button)
	-- raycast
	local kind, var = Spring.TraceScreenRay(mx, my)
	
	if kind == "unit" then
		if clickToSelect and doubleClick > 0.3 then -- isolate one unit if the mouse did not move during the process
			proceedSelection({var})
		end
	end

	if button == 1 and globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then -- return in idle state
		plotSelection = false
		mouseMove = false
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
	
	if button == 1 and globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
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
	end
	return true
end