function widget:GetInfo()
	return {
		name = "Spring Direct Launch 2 for Prog&Play Level Editor",
		desc = "Show some P&P menu when Spring.exe is run directly.",
		author = "zwzsg, muratet, zigaroula",
		version = "0.1",
		date = "Apr 14, 2016",
		license = "Public Domain",
		layer = 250,
		enabled = true,
		handler = true
	}
end

VFS.Include("LuaUI/Widgets/libs/RestartScript.lua")
VFS.Include("LuaUI/Widgets/editor/LauncherStrings.lua")

local Chili, Screen0
local IsActive = false
local HideView = false
local vsx, vsy
local UI = {}

function InitializeChili() 
	if not WG.Chili then
		widgetHandler:RemoveWidget()
		return
	end
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function InitializeLauncher()
	UI.MainWindow = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width  = "100%",
		height = "100%",
		draggable = false,
		resizable = false
	}
	UI.Title = Chili.Label:New{
		parent = UI.MainWindow,
		x = '0%',
		y = '0%',
		width = '100%',
		height = '10%',
		align = "center",
		valign = "center",
		caption = LAUNCHER_TITLE,
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 60,
			color = {0.2,0.6,0.8,1}
		}
	}
	UI.NewMissionButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "30%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_NEW_MISSION,
		OnClick = { function() NewMission("ByteBattleMap") end },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = {0.2,1,0.8,1}
		}
	}
	UI.EditMissionButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "40%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_EDIT_MISSION,
		OnClick = { function() ChangeLanguage("fr") end },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = {0.2,1,0.8,1}
		}
	}
	UI.EditScenarioButton = Chili.Button:New{
		parent = UI.MainWindow,
		x = "30%",
		y = "50%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_EDIT_SCENARIO,
		OnClick = {},
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = {0.2,1,0.8,1}
		}
	}
end

function UpdateCaption(element, text)
	if UI[element] then
		UI[element]:SetCaption(text)
	end
end

function UpdateText(element, text)
	if UI[element] then
		UI[element]:SetText(text)
	end
end

function ChangeLanguage(lang)
	GetLauncherStrings(lang)
	UpdateCaption("Title", LAUNCHER_TITLE)
	UpdateCaption("NewMissionButton", LAUNCHER_NEW_MISSION)
	UpdateCaption("EditMissionButton", LAUNCHER_EDIT_MISSION)
	UpdateCaption("EditScenarioButton", LAUNCHER_EDIT_SCENARIO)
end

function InitializeEditor()
	widgetHandler:EnableWidget("Chili Framework")
	widgetHandler:EnableWidget("Hide commands")
	widgetHandler:EnableWidget("Editor Widget List")
	widgetHandler:EnableWidget("Editor User Interface")
end

function NewMission(map)
	local operations = {
		["MODOPTIONS"] = {
			["language"] = "fr",
			["scenario"] = "noScenario"
		},
		["GAME"] = {
			["Mapname"] = map
		}
	}
	DoTheRestart("LevelEditor.txt", operations)
end

function RemoveOtherWidgets()
	for name, w in pairs(widgetHandler.knownWidgets) do
		if w.active and name ~= "Spring Direct Launch 2 for Prog&Play Level Editor" and name ~= "Chili Framework" then
			widgetHandler:DisableWidget(name)
		end
	end
end

function EitherDrawScreen(self)
	if not vsx or not vsy then
		return
	end
	
	if HideView then
		local bgText = "bitmaps/editor/blank.png"
		gl.Blending(false)
		gl.Color(0, 0, 0, 0)
		gl.Texture(bgText)
		gl.TexRect(vsx, vsy, 0, 0, 0, 0, 1, 1)
		gl.Texture(false)
	end
end

function SwitchOn()
	Spring.SendCommands({"NoSound 1"})
	HideView = true
	RemoveOtherWidgets()
	InitializeLauncher()
end

function SwitchOff()
	HideView = false
	RemoveOtherWidgets()
	InitializeEditor()
end

function widget:DrawScreenEffects(dse_vsx, dse_vsy)
	vsx, vsy = dse_vsx, dse_vsy
	if Spring.IsGUIHidden() then
		EitherDrawScreen(self)
	end
end

function widget:DrawScreen()
	if not Spring.IsGUIHidden() then
		EitherDrawScreen(self)
	end
end

function widget:Initialize()
	InitializeChili()
	ChangeLanguage("en")
	if not Spring.GetModOptions().hidemenu then
		SwitchOn()
	else
		SwitchOff()
	end
end