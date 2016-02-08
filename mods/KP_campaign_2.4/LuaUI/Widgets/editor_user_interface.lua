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

VFS.Include("StateMachine.lua")

---------------------------------------------------------------------------------------------------------------
--
-- USER INTERFACE PART
--
---------------------------------------------------------------------------------------------------------------

local Chili, Screen0
local windows, buttons, labels, images = {}, {}, {}, {}

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
function addWindow(_parent, _x, _y, _w, _h, name)
	local window = Chili.Window:New{
		parent = _parent,
		x = _x,
		y = _y,
		width  = _w,
		height = _h,
		draggable = false,
		resizable = false
	}
	windows[name] = window
end

-------------------------------------
-- Add an ImageButton to a specific parent
-------------------------------------
function addImageButton(_parent, _x, _y, _w, _h, imagePath, onClickFunction, name)
	local button = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = false,
		OnClick = {onClickFunction}
	}
	buttons[name] = button
end

-------------------------------------
-- Add an Button to a specific parent
-------------------------------------
function addButton(_parent, _x, _y, _w, _h, text, onClickFunction, name)
	local button = Chili.Button:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		OnClick = {onClickFunction}
	}
	buttons[name] = button
end

-------------------------------------
-- Add a label to a specific parent
-------------------------------------
function addLabel(_parent, _x, _y, _w, _h, text, name)
	local label = Chili.Label:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		caption = text,
		fontsize = 20
	}
	labels[name] = label
end

-------------------------------------
-- Add an Image to a specific parent
-------------------------------------
function addImage(_parent, _x, _y, _w, _h, imagePath, name)
	local image = Chili.Image:New {
		parent = _parent,
		x = _x,
		y = _y,
		width = _w,
		height = _h,
		file = imagePath,
		keepAspect = false
	}
	images[name] = image
end

-------------------------------------
-- Select button
-- TODO : CODE INFAME, a changer au plus vite sinon se pendre
-------------------------------------
function selectBit()
	stateMachine:setCurrentUnitState(stateMachine.states.BIT)
	Spring.Echo("SELECTBIT:"..stateMachine:getCurrentUnitState())
	buttons["byte"]:RemoveChild(images["selectionType"])
	addImage(buttons["bit"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionType')
end

function selectByte()
	stateMachine:setCurrentUnitState(stateMachine.states.BYTE)
	Spring.Echo("SELECTBYTE:"..stateMachine:getCurrentUnitState())
	buttons["bit"]:RemoveChild(images["selectionType"])
	addImage(buttons["byte"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionType')
end

function selectPlayer()
	stateMachine:setCurrentTeamState(stateMachine.states.PLAYER)
	buttons["ally"]:RemoveChild(images["selectionTeam"])
	buttons["enemy"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

function selectAlly()
	stateMachine:setCurrentTeamState(stateMachine.states.ALLY)
	buttons["player"]:RemoveChild(images["selectionTeam"])
	buttons["enemy"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["ally"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

function selectEnemy()
	stateMachine:setCurrentTeamState(stateMachine.states.ENEMY)
	buttons["ally"]:RemoveChild(images["selectionTeam"])
	buttons["player"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["enemy"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

-------------------------------------
-- Show/Hide panels
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
end

function unitFrame()
	removeWindows()
	addWindow(Screen0, '0%', '5%', '15%', '80%', 'mainWindow')
	
	-- Unit buttons
	addLabel(windows["mainWindow"], '5%', '5%', '90%', '5%', "Units", 'unitLabel')
	addImageButton(windows["mainWindow"], '5%', '10%', '42.5%', '15%', "bitmaps/editor/bit.png", selectBit, 'bit')
	addImageButton(windows["mainWindow"], '52.5%', '10%', '42.5%', '15%', "bitmaps/editor/byte.png", selectByte, 'byte')
	
	-- Team buttons
	addLabel(windows["mainWindow"], '5%', '87%', '90%', '5%', "Team", 'teamLabel')
	addImageButton(windows["mainWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", selectPlayer, 'player')
	addImageButton(windows["mainWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", selectAlly, 'ally')
	addImageButton(windows["mainWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", selectEnemy, 'enemy')
	
	-- Selection image
	addImage(buttons["bit"], '-10', '-10', '101%', '101%', "bitmaps/editor/selection.png", 'selectionType')
	addImage(buttons["player"], '-10', '-10', '101%', '101%', "bitmaps/editor/selection.png", 'selectionTeam')
end

function selectionFrame()
	removeWindows()
end

-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
	-- get rid of engine UI
	Spring.SendCommands("resbar 0", "tooltip 0","fps 0","console 0","info 0")
	-- leaves rendering duty to widget (we won't)
	gl.SlaveMiniMap(true)
	-- a hitbox remains for the minimap, unless you do this
	gl.ConfigMiniMap(0,0,0,0)
  
	initChili()
	
	-----------------
	-- Top bar
	addWindow(Screen0, '0%', '0%', '100%', '5%', 'topBar')
	
	-- Menu buttons
	addButton(windows["topBar"], '0%', '0%', '5%', '100%', 'File', fileFrame, 'file')
	addButton(windows["topBar"], '5%', '0%', '5%', '100%', 'Units', unitFrame, 'units')
	addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Selection', selectionFrame, 'units')
	-----------------
end

---------------------------------------------------------------------------------------------------------------
--
-- MOUSE PART
--
---------------------------------------------------------------------------------------------------------------

local mouseMove = false

-------------------------------------
-- Handle mouse button pressures
-- TODO : don't handle pressures when they occur on an UI element
-- TOFIX : problem with interacting with briefing message
-------------------------------------
function widget:MousePress(mx, my, button)
	Spring.Echo("MOUSEPRESS:"..stateMachine:getCurrentUnitState())
	-- Raycasts
	local kind,var = Spring.TraceScreenRay(mx,my)
	local kind2, var2 = Spring.TraceScreenRay(mx,my,true)
	-- If ground is selected and we can place a unit, send a message to the gadget to create the unit
	if kind == "ground" and stateMachine:getCurrentUnitState() ~= "idle" then
		local xUnit, yUnit, zUnit = unpack(var)
		local msg = "Create Unit".."++"..stateMachine:getCurrentUnitState().."++"..stateMachine:getCurrentTeamState().."++"..tostring(xUnit).."++"..tostring(yUnit).."++"..tostring(zUnit)
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