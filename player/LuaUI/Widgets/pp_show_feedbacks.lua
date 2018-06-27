function widget:GetInfo()
  return {
    name      = "PP Show Feedbacks",
    desc      = "Used to display an help button in UI when trace module is on",
    author    = "meresse, mocahteam",
    date      = "Jun 20, 2016",
    license   = "GPL v2 or later",
    layer     = 211,
    enabled   = true
  }
end

local lang = Spring.GetModOptions()["language"] -- get the language

local HELP_LABEL = "Help"
if lang == "fr" then
	HELP_LABEL = "Aide"
end

local feedbackOn = Spring.GetModOptions()["activefeedbacks"] ~= nil and Spring.GetModOptions()["activefeedbacks"] == "1"
local testMap = Spring.GetModOptions()["testmap"] ~= nil

local HelpButton = nil -- the button to ask an help notification

function askHelp()
	Spring.SetConfigString("helpPlease", "enabled", true) -- inform the game engine that we want a feedback
	if Script.LuaUI.TraceAction then
		Script.LuaUI.TraceAction("ask_help") -- registered by pp_meta_trace_manager.lua
	end
end

function toggleHelpButton ()
	if HelpButton then
		HelpButton:ToggleVisibility()
	end
end

function widget:GameStart()
	if feedbackOn and not testMap then -- Traces are on => we display the button
		if (not WG.Chili) then -- If the chili widget is not found, remove this widget
			Spring.Echo("PP Show Feedbacks: Chili is not defined, remove himself")
			return
		end
		
		HelpButton = WG.Chili.Button:New{
			parent = WG.Chili.Screen0,
			x = "85%",
			y = "0%",
			width = "15%",
			height = "5%",
			caption = HELP_LABEL,
			OnClick = { askHelp },
			font = {
				font = "LuaUI/Fonts/Asimov.otf",
				size = 30,
				autoAdjust = true,
				maxSize = 30,
				color = { 0.2, 1, 0.8, 1 }
			}
		}
	end
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("ToggleHelpButton", toggleHelpButton)
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal("ToggleHelpButton")
	
	if HelpButton then
		HelpButton:Dispose()
	end
end
