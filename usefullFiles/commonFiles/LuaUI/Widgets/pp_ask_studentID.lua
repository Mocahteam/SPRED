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
local okBut = nil
local duoButton = nil
local firstEditBox = nil
local secondEditBox = nil

function initChili() -- Initialize Chili variables
	if (not WG.Chili) then -- If chili widget is not loaded, we enable it
		widgetHandler:EnableWidget("Chili Framework")
	end
	if (not WG.Chili) then -- If chili widget is still not loaded, we disable this widget
		widgetHandler:RemoveWidget() -- remove self
	end
end

local function storePlayerId()
	WG.StudentId = "" -- set global value for all widgets
	if firstEditBox and firstEditBox.text and firstEditBox.text~="" then
		WG.StudentId = firstEditBox.text
		if secondEditBox and secondEditBox.text and secondEditBox.text~="" then
			WG.StudentId = WG.StudentId.."###"
		end
	end
	if secondEditBox and secondEditBox.text and secondEditBox.text~="" then
		WG.StudentId = WG.StudentId..secondEditBox.text
	end
	-- store this default students id in config file
	Spring.SetConfigString("StudentsId", WG.StudentId)
	
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

-- Exemples of use:
-- splitString("Hello || everybody | nice day", "||")
--       "Hello "
--       " everybody | nice day"
-- splitString("Hello || everybody | nice day", "|")
--       "Hello "
--       ""
--       " everybody "
--       " nice day"
function splitString(inputstr, sep)
	local str = inputstr
	tokens = {}
	while str ~= "" do
		if string.find(str, sep) == nil then
			table.insert(tokens, str)
			str = ""
		else
			begin = string.gsub(str, "^(.-)"..sep..".*", "%1")
			finish = string.gsub(str, "^.-"..sep.."(.*)", "%1")
			table.insert(tokens, begin)
			str = finish 
		end
	end 
	return tokens
end

function showSecondField(studentId)
	-- The second EditBox
	secondEditBox = WG.Chili.EditBox:New {
		parent = AskIdWindow,
		x = "5%",
		y = "50%",
		width = "70%",
		height = "20%",
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
		y = "35%",
		width  = "60%",
		height = "30%",
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
		height = '20%',
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
	okBut = WG.Chili.Button:New{
		parent = AskIdWindow,
		x = "80%",
		y = "75%",
		width = "15%",
		height = "20%",
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
	local studentId1 = ""
	local studentId2 = ""
	local content = Spring.GetConfigString("StudentsId", "") -- Get students id from springrc / springsettings.cfg file.
	local studentsId = splitString(content, "###")
	if studentsId[1] then
		studentId1 = studentsId[1]
	end
	if studentsId[2] then
		studentId2 = studentsId[2]
	end
	-- The EditBox
	firstEditBox = WG.Chili.EditBox:New {
		parent = AskIdWindow,
		x = "5%",
		y = "25%",
		width = "70%",
		height = "20%",
		align = "left",
		text = studentId1,
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
	
	if studentId2 ~= "" then
		showSecondField(studentId2)
	else
		--The duo button
		duoButton = WG.Chili.Button:New{
			parent = AskIdWindow,
			x = "5%",
			y = "50%",
			width = "15%",
			height = "15%",
			caption = "Duo",
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
			focusColor = { 0, 0.6, 1, 1 },
			OnClick = {
				function()
					showSecondField(studentId2)
					duoButton:Dispose()
				end
			},
			OnKeyPress = {
				function (self, key)
					if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
						showSecondField(studentId2)
						duoButton:Dispose()
						return true
					end
				end
			}
		}
	end
	
	-- Add events on OK button
	okBut.OnClick = {
			function()
				if (firstEditBox and firstEditBox.text and firstEditBox.text~="") or (secondEditBox and secondEditBox.text and secondEditBox.text~="") then
					storePlayerId()
				end
			end
		}
	okBut.OnKeyPress = {
			function (self, key)
				if key == Spring.GetKeyCode("enter") or key == Spring.GetKeyCode("numpad_enter") then
					if (firstEditBox and firstEditBox.text and firstEditBox.text~="") or (secondEditBox and secondEditBox.text and secondEditBox.text~="") then
						storePlayerId()
					end
					return true
				end
			end
		}
	
	WG.Chili.Screen0:FocusControl(firstEditBox)
end

function widget:Initialize()
	initChili()
	displayUI()
end

function widget:Shutdown()
	clearUI()
end
