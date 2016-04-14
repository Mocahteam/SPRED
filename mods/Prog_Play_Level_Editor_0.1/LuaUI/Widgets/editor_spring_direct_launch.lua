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
VFS.Include("LuaUI/Widgets/editor/EditorStrings.lua")

local Chili, Screen0
local IsActive = false
local HideView = false
local vsx, vsy

function InitializeChili() 
	if not WG.Chili then
		widgetHandler:RemoveWidget()
		return
	end
	Chili = WG.Chili
	Screen0 = Chili.Screen0
end

function InitializeWindows()
	local window = Chili.Window:New{
		parent = Screen0,
		x = "0%",
		y = "0%",
		width  = "100%",
		height = "100%",
		draggable = false,
		resizable = false
	}
	local label = Chili.Label:New{
		parent = window,
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
	local newMissionButton = Chili.Button:New{
		parent = window,
		x = "30%",
		y = "30%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_NEW,
		OnClick = { function() NewMission("Marble_Madness_Map") end },
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = {0.2,1,0.8,1}
		}
	}
	local editMissionButton = Chili.Button:New{
		parent = window,
		x = "30%",
		y = "40%",
		width = "40%",
		height = "10%",
		caption = LAUNCHER_EDIT_MISSION,
		OnClick = {},
		font = {
			font = "LuaUI/Fonts/Asimov.otf",
			size = 40,
			color = {0.2,1,0.8,1}
		}
	}
	local editScenarioButton = Chili.Button:New{
		parent = window,
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

function NewMission(name)
	local operations = {
		["MODOPTIONS"] = {
			["language"] = "fr",
			["scenario"] = "noScenario"
		},
		["GAME"] = { -- FIXME doesn't seem to work
			["Mapname"] = name
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
	if not vsx or not vsy or not IsActive then
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
	IsActive = false
	if not Spring.GetModOptions().hidemenu then
		Spring.SendCommands({"NoSound 1"})
		HideView = true
		IsActive = true
		RemoveOtherWidgets()
		InitializeWindows()
	else
		widgetHandler:EnableWidget("Chili Framework")
		widgetHandler:EnableWidget("Hide commands")
		widgetHandler:EnableWidget("Editor Widget List")
		widgetHandler:EnableWidget("Editor User Interface")
		widgetHandler:DisableWidget("Spring Direct Launch 2 for Prog&Play Level Editor")
	end
end

function widget:Update(delta)

end

function widget:Shutdown()

end