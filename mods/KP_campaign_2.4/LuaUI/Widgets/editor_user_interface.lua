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

-------------------------------------
-- Use this widget only in the editor
-------------------------------------
function hideInRegularMission()
	if (Spring.GetModOptions()["editor"] ~= "yes" or Spring.GetModOptions()["editor"]  == nil) then
		widgetHandler:DisableWidget(self)
	end
end

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
function addButton(_parent, _x, _y, _w, _h, imagePath, onClickFunction, name)
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
-- BUGGED
-------------------------------------
function selectBit()
	Script.LuaUI.stateBit()
	buttons["byte"]:RemoveChild(images["selectionType"])
	addImage(buttons["bit"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionType')
end

function selectByte()
	Script.LuaUI.stateByte()
	buttons["bit"]:RemoveChild(images["selectionType"])
	addImage(buttons["byte"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionType')
end

function selectPlayer()
	Script.LuaUI.statePlayer()
	buttons["ally"]:RemoveChild(images["selectionTeam"])
	buttons["enemy"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["player"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

function selectAlly()
	Script.LuaUI.stateAlly()
	buttons["player"]:RemoveChild(images["selectionTeam"])
	buttons["enemy"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["ally"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

function selectEnemy()
	Script.LuaUI.stateEnemy()
	buttons["ally"]:RemoveChild(images["selectionTeam"])
	buttons["player"]:RemoveChild(images["selectionTeam"])
	addImage(buttons["enemy"], '-1%', '-1%', '102%', '102%', "bitmaps/editor/selection.png", 'selectionTeam')
end

-------------------------------------
-- Initialize the widget
-------------------------------------
function widget:Initialize()
	hideInRegularMission()
	initChili()
	
	-- Left Panel
	addWindow(Screen0, '0%', '5%', '15%', '80%', 'mainWindow')
	
	-- Unit buttons
	addLabel(windows["mainWindow"], '5%', '5%', '90%', '5%', "Units", 'unitLabel')
	addButton(windows["mainWindow"], '5%', '10%', '42.5%', '15%', "bitmaps/editor/bit.png", selectBit, 'bit')
	addButton(windows["mainWindow"], '52.5%', '10%', '42.5%', '15%', "bitmaps/editor/byte.png", selectByte, 'byte')
	
	-- Team buttons
	addLabel(windows["mainWindow"], '5%', '87%', '90%', '5%', "Team", 'teamLabel')
	addButton(windows["mainWindow"], '5%', '92%', '30%', '5%', "bitmaps/editor/player.png", selectPlayer, 'player')
	addButton(windows["mainWindow"], '35%', '92%', '30%', '5%', "bitmaps/editor/ally.png", selectAlly, 'ally')
	addButton(windows["mainWindow"], '65%', '92%', '30%', '5%', "bitmaps/editor/enemy.png", selectEnemy, 'enemy')
	
	-- Selection image
	addImage(buttons["bit"], '-10', '-10', '101%', '101%', "bitmaps/editor/selection.png", 'selectionType')
	addImage(buttons["player"], '-10', '-10', '101%', '101%', "bitmaps/editor/selection.png", 'selectionTeam')
end