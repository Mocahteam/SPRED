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
local windows, buttons, teamButtons, unitButtons, labels, images = {}, {}, {}, {}, {}, {}

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
-- Select button
-- TODO : CODE INFAME, a changer au plus vite sinon se pendre
-- WAY TOO HARDCODED
-------------------------------------
function selectBit()
	stateMachine:setCurrentUnitState(stateMachine.states.BIT)
	for key, button in pairs(unitButtons) do
		button:RemoveChild(images["selectionType"])
	end
	images['selectionType'] = addImage(unitButtons["bit"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectByte()
	stateMachine:setCurrentUnitState(stateMachine.states.BYTE)
	for key, button in pairs(unitButtons) do
		button:RemoveChild(images["selectionType"])
	end
	images['selectionType'] = addImage(unitButtons["byte"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectPlayer()
	stateMachine:setCurrentTeamState(stateMachine.states.PLAYER)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectAlly()
	stateMachine:setCurrentTeamState(stateMachine.states.ALLY)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["ally"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectEnemy()
	stateMachine:setCurrentTeamState(stateMachine.states.ENEMY)
	for key, button in pairs(teamButtons) do
		button:RemoveChild(images["selectionTeam"])
	end
	images['selectionTeam'] = addImage(teamButtons["enemy"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

-------------------------------------
-- Top bar functions (show/hide panels)
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
	stateMachine:setCurrentGlobalState(stateMachine.states.FILE)
end

function unitFrame()
	removeWindows()
	stateMachine:setCurrentGlobalState(stateMachine.states.UNIT)
	stateMachine:setCurrentUnitState(stateMachine.states.BIT)
	stateMachine:setCurrentTeamState(stateMachine.states.PLAYER)
	
	windows['mainWindow'] = addWindow(Screen0, '0%', '5%', '15%', '80%')
	
	-- Unit buttons
	labels['unitLabel'] = addLabel(windows["mainWindow"], '5%', '5%', '90%', '5%', "Units")
	unitButtons['bit'] = addImageButton(windows["mainWindow"], '5%', '10%', '42.5%', '15%', "bitmaps/editor/bit.png", selectBit)
	unitButtons['byte'] = addImageButton(windows["mainWindow"], '52.5%', '10%', '42.5%', '15%', "bitmaps/editor/byte.png", selectByte)
	
	-- Team buttons
	labels['teamLabel'] = addLabel(windows["mainWindow"], '5%', '87%', '90%', '5%', "Team")
	teamButtons['player'] = addImageButton(windows["mainWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", selectPlayer)
	teamButtons['ally'] = addImageButton(windows["mainWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", selectAlly)
	teamButtons['enemy'] = addImageButton(windows["mainWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", selectEnemy)
	
	-- Selection image
	images['selectionType'] = addImage(unitButtons["bit"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
	images['selectionTeam'] = addImage(teamButtons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png")
end

function selectionFrame()
	removeWindows()
	stateMachine:setCurrentGlobalState(stateMachine.states.SELECTION)
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
	windows['topBar'] = addWindow(Screen0, '0%', '0%', '100%', '5%')
	
	-- Menu buttons
	buttons['file'] = addButton(windows["topBar"], '0%', '0%', '5%', '100%', 'File', fileFrame)
	buttons['units'] = addButton(windows["topBar"], '5%', '0%', '5%', '100%', 'Units', unitFrame)
	buttons['selection'] = addButton(windows["topBar"], '10%', '0%', '5%', '100%', 'Selection', selectionFrame)
	-----------------
end