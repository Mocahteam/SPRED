function widget:GetInfo()
  return {
    name      = "Ask Student ID",
    desc      = "Ask a student ID",
    author    = "muratet",
    date      = "November 07, 2017",
    license   = "GPL v2 or later",
    layer     = 1,
    enabled   = true
  }
end

local lang = Spring.GetModOptions()["language"] -- get the language

local ENTER_USER_ID = ""
local function updateLanguage ()
	ENTER_USER_ID = "Enter your student ID:"
	if lang == "fr" then
		ENTER_USER_ID = "Entrer votre numéro d'étudiant :"
	end
end

local AskIdWindow = nil
local FilterBackground = nil

function initChili() -- Initialize Chili variables
	if (not WG.Chili) then -- If chili widget is not loaded, we enable it
		widgetHandler:EnableWidget("Chili Framework")
	end
	if (not WG.Chili) then -- If chili widget is still not loaded, we disable this widget
		widgetHandler:RemoveWidget() -- remove self
	end
end

local function storePlayerId(newStudentId)
	WG.StudentId = newStudentId -- set global value for all widgets
	local file = io.open("studentId.ini", "w")
	if file ~= nil then
		file:write(newStudentId)
		file:close()
	end
	widgetHandler:RemoveWidget() -- remove self
end

local function clearUI()
	if AskIdWindow ~= nil then
		AskIdWindow:Dispose()
		AskIdWindow = nil
	end
	if FilterBackground ~= nil then
		FilterBackground:Dispose()
		FilterBackground = nil
	end
end

function displayUI()
	clearUI()
	updateLanguage ()
	
	-- Display background
	FilterBackground = WG.Chili.Image:New {
		parent = WG.Chili.Screen0,
		x = "0%",
		y = "0%",
		width = "100%",
		height = "100%",
		file = "bitmaps/editor/blank.png",
		keepAspect = false
	}
	FilterBackground.color = {0, 0, 0, 0.9}
	FilterBackground.OnClick = {
		function()
			return true -- Stop Clic event
		end
	}
	
	-- Create main window
	AskIdWindow = WG.Chili.Window:New{
		parent = WG.Chili.Screen0,
		x = "20%",
		y = "40%",
		width  = "60%",
		height = "20%",
		minWidth = 0,
		minHeight = 0,
		draggable = false,
		resizable = false
	}
	
	FilterBackground:BringToFront()
	AskIdWindow:BringToFront()
	
	WG.Chili.Label:New{
		parent = AskIdWindow,
		x = '5%',
		y = '5%',
		width = '90%',
		height = '40%',
		minWidth = 0,
		minHeight = 0,
		align = "left",
		valign = "linecenter",
		caption = ENTER_USER_ID,
		fontsize = 20,
		padding = {8, 2, 8, 2},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 20,
			autoAdjust = true,
			maxSize = 20,
			shadow = false
		}
	}
	
	-- OK Button
	local okBut = WG.Chili.Button:New{
		parent = AskIdWindow,
		x = "80%",
		y = "55%",
		width = "15%",
		height = "40%",
		caption = "OK",
		minWidth = 0,
		minHeight = 0,
		padding = {8, 0, 8, 0},
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 15,
			autoAdjust = true,
			maxSize = 15,
			shadow = false,
		},
		backgroundColor = { 0, 0.2, 0.6, 1 },
		focusColor = { 0, 0.6, 1, 1 }
	}
	
	-- Look for an existing student ID
	local file = io.open("studentId.ini", "r")
	local studentId = ""
	if file ~= nil then
		studentId = file:read("*all")
		file:close()
	end
	-- The EditBox
	local editBox = WG.Chili.EditBox:New {
		parent = AskIdWindow,
		x = "5%",
		y = "55%",
		width = "70%",
		height = "40%",
		align = "left",
		text = studentId,
		font = {
			font = "LuaUI/Fonts/TruenoRg.otf",
			size = 16,
			autoAdjust = true,
			maxSize = 16,
			shadow = false
		},
		OnKeyPress = {
			function (self, key)
				if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
					WG.Chili.Screen0:FocusControl(okBut)
					return true
				end
			end
		}
	}
	
	-- Add events on OK button
	okBut.OnClick = {
			function()
				storePlayerId(editBox.text)
			end
		}
	okBut.OnKeyPress = {
			function (self, key)
				if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
					storePlayerId(editBox.text)
					return true
				end
			end
		}
	
	WG.Chili.Screen0:FocusControl(editBox)
end

function widget:Initialize()
	initChili()
	displayUI()
end

function widget:Shutdown()
	clearUI()
end
