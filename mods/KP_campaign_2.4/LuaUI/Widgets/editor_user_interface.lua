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
VFS.Include("LuaUI/Widgets/editor/MouseHandler.lua")

local Chili, Screen0
local windows, buttons, teamButtons, unitButtons, labels, images, scrollPanels = {}, {}, {}, {}, {}, {}, {}
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
		fontsize = 20
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
end

function unitFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.UNIT)
	unitStateMachine:setCurrentState(unitStateMachine.states.DEFAULT)
	teamStateMachine:setCurrentState(teamStateMachine.states.PLAYER)
	
	windows['mainWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	scrollPanels['unitScrollPanel'] = addScrollPanel(windows['mainWindow'], '0%', '5%', '100%', '80%')
	
	-- Unit buttons
	labels['unitLabel'] = addLabel(windows['mainWindow'], '0%', '1%', '90%', '5%', "Units")
	local button_size = 40
	local y = 0
	for k,u in pairs(unitStateMachine.states) do
		if (k ~= "DEFAULT") then
			unitButtons[u] = addButton(scrollPanels['unitScrollPanel'], 0, y, '100%', button_size, u, unitFunctions[u])
			y = y + button_size
		end
	end
	
	--[[ OLD BUTTONS
	unitButtons['bit'] = addImageButton(scrollPanels['unitScrollPanel'], '5%', 0, '42.5%', '15%', "bitmaps/editor/bit.png", selectBit)
	unitButtons['byte'] = addImageButton(scrollPanels['unitScrollPanel'], '52.5%', 0, '42.5%', '15%', "bitmaps/editor/byte.png", selectByte)
	]]
	
	-- Team buttons
	labels['teamLabel'] = addLabel(windows["mainWindow"], '5%', '87%', '90%', '5%', "Team")
	teamButtons['player'] = addImageButton(windows["mainWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", selectPlayer)
	teamButtons['ally'] = addImageButton(windows["mainWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", selectAlly)
	teamButtons['enemy'] = addImageButton(windows["mainWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", selectEnemy)
	
	-- Selection image
	images['selectionType'] = addImage(unitButtons[unitStateMachine.states.DEFAULT], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
	images['selectionTeam'] = addImage(teamButtons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectionFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.SELECTION)
end

function eventFrame()
	removeWindows()
	globalStateMachine:setCurrentState(globalStateMachine.states.EVENT)
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
	buttons['selection'] = addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Selection', selectionFrame)
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
	Spring.Echo("STATE:"..teamStateMachine.states.PLAYER)
end