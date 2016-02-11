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
--VFS.Include("LuaUI/Widgets/editor/MouseHandler.lua")

local Chili, Screen0
local windows, buttons, teamButtons, unitButtons, labels, images, scrollPanels, editBoxes = {}, {}, {}, {}, {}, {}, {}, {}
local globalFunctions, unitFunctions, teamFunctions = {}, {}, {}

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
function addWindow(_parent, _x, _y, _w, _h)
	local window = Chili.Window:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _w,
		height = _h,
		draggable = false,
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
-- Getters for MouseHandler
-------------------------------------
function getUnitButtons() return unitButtons end
function getImages() return images end

-------------------------------------
-- Select button functions
-------------------------------------
function selectPlayer()
	teamStateMachine:setCurrentState(teamStateMachine.states.PLAYER)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectAlly()
	teamStateMachine:setCurrentState(teamStateMachine.states.ALLY)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["ally"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectEnemy()
	teamStateMachine:setCurrentState(teamStateMachine.states.ENEMY)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["enemy"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
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
	labels['fileLabel'] = addLabel(windows['fileWindow'], '0%', '1%', '90%', '5%', "File")
end

function unitFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
	unitStateMachine:setCurrentState(unitStateMachine.states.DEFAULT)
	teamStateMachine:setCurrentState(teamStateMachine.states.PLAYER)
	
	windows['unitWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	scrollPanels['unitScrollPanel'] = addScrollPanel(windows['unitWindow'], '0%', '5%', '100%', '80%')
	
	-- Unit buttons
	labels['unitLabel'] = addLabel(windows['unitWindow'], '0%', '1%', '100%', '5%', "Units")
	local button_size = 40
	local y = 0
	for k,u in pairs(unitStateMachine.states) do
		if (k ~= "DEFAULT") then
			unitButtons[u] = addButton(scrollPanels['unitScrollPanel'], 0, y, '100%', button_size, UnitDefNames[u].humanName, unitFunctions[u])
			y = y + button_size
		end
	end
	
	-- Team buttons
	labels['teamLabel'] = addLabel(windows["unitWindow"], '0%', '87%', '100%', '5%', "Team")
	teamButtons['player'] = addImageButton(windows["unitWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", selectPlayer)
	teamButtons['ally'] = addImageButton(windows["unitWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", selectAlly)
	teamButtons['enemy'] = addImageButton(windows["unitWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", selectEnemy)
	
	-- Selection image
	images['selectionType'] = addImage(unitButtons[unitStateMachine.states.DEFAULT], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
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
			unitStateMachine:setCurrentState(unitStateMachine.states[u])
			for key, ub in pairs(unitButtons) do
				ub:RemoveChild(images["selectionType"])
			end
			images['selectionType'] = addImage(unitButtons[u], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
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
	--Spring.SendCommands("GodMode 1")
end

-------------------------------------
-- Draw selection tools
-------------------------------------
local selectionStartX, selectionStartY, selectionEndX, selectionEndY, gameSizeX, gameSizeY = 0, 0, 0, 0, 0, 0
local plotSelection = false
function widget:DrawScreenEffects(dse_vsx, dse_vsy) gameSizeX, gameSizeY = dse_vsx, dse_vsy end

-------------------------------------
-- Update function
-------------------------------------
local x1, x2, y1, y2 = 0, 0, gameSizeY, gameSizeY -- coordinates of the selection box

function widget:Update(delta)
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
	
	
	-- Tell the gadget which units are selected
	local msg = "Select Units"
	for i, u in ipairs(Spring.GetSelectedUnits()) do
		msg = msg.."++"..u
	end
	Spring.SendLuaRulesMsg(msg)
end







----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------





local mouseMove = false
-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-------------------------------------
function widget:MousePress(mx, my, button)
	-- Left click
	if (button == 1) then
		-- STATE UNIT : place units on the field
		if globalStateMachine:getCurrentState() == globalStateMachine.states.UNIT then
			-- raycast
			local kind,var = Spring.TraceScreenRay(mx,my)
			-- If ground is selected and we can place a unit, send a message to the gadget to create the unit
			if kind == "ground" then
				local xUnit, yUnit, zUnit = unpack(var)
				local msg = "Create Unit".."++"..unitStateMachine:getCurrentState().."++"..teamStateMachine:getCurrentState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
				Spring.SendLuaRulesMsg(msg)
			end
		-- STATE SELECTION : select and move units on the field
		elseif globalStateMachine:getCurrentState() == globalStateMachine.states.SELECTION then
			-- raycasts
			local kind,var = Spring.TraceScreenRay(mx,my)
			-- If unit is pointed, check if it is selected and in that case, send a message to move all selected units
			if kind == "unit" then
				for i, u in ipairs(Spring.GetSelectedUnits()) do
					if var == u then
						mouseMove = true -- proceed movement
						return true -- required to use MouseRelease and MouseMove
					end
				end
				Spring.SelectUnitArray({var}) -- if the unit was not selected, select it and proceed movement
				mouseMove = true
				return true
			-- start a box selection
			elseif kind == "ground" then
				Spring.SelectUnitArray({})
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
	if button == 1 and globalStateMachine:getCurrentState() == "selection" then
		plotSelection = false
		mouseMove = false
		return true
	end
end

-------------------------------------
-- Handle mouse movements
-------------------------------------
function widget:MouseMove(mx, my, dmx, dmy, button)
	if button == 1 and globalStateMachine:getCurrentState() == "selection" then
		-- If a unit is selected, send a message to the gadget to move it
		if mouseMove and not plotSelection then
			--[[
			local kind, var = Spring.TraceScreenRay(mx - dmx, my - dmy, true)
			local kind2, var2 = Spring.TraceScreenRay(mx, my, true)
			local Ax1, Ay1, Az1 = unpack(var)
			local Bx1, By1, Bz1 = unpack(var2)
			local dX, dZ = Bx1-Ax1, By1-Ay1
			local msg = "Move Units".."++"..dX.."++"..dZ
			]]
			local msg = "Move Units".."++"..dmx.."++"..dmy -- TODO : compute world's dx and dz
			Spring.SendLuaRulesMsg(msg)
		end
		-- update selection box
		if plotSelection then
			selectionEndX = mx
			selectionEndY = my
			-- Select all units in the rectangle
			local unitSelection = GetUnitsInScreenRectangle(selectionStartX, selectionStartY, selectionEndX, selectionEndY)
			Spring.SelectUnitArray(unitSelection)
		end
	end
end