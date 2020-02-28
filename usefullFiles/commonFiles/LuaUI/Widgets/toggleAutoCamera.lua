function widget:GetInfo()
	return {
		name = "Toggle auto camera",
		desc = "Enable/Disable auto camera",
		author = "muratet",
		date = "March 18, 2019",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true
	}
end

local Chili, Screen0
local ReplayButton = nil -- the button to toggle camera


function initChili() -- Initialize Chili variables
	
	if (not WG.Chili) then -- If the widget is not loaded, we try to load it
		widgetHandler:EnableWidget("Chili Framework")
	end
	if (not WG.Chili) then -- If the widget is still not loaded, we disable this widget
		widgetHandler:RemoveWidget()
	else
		-- Get ready to use Chili
		Chili = WG.Chili
		Screen0 = Chili.Screen0
	end
end

function toggleCamera()
	if (WG.ToggleCamera ~= nil) then
		WG.ToggleCamera() -- Defined in pp_cameraAuto.lua
	end
end

function widget:Initialize()
	initChili()
	
	if Chili ~= nil then
		local toggleTitle
		if Spring.GetModOptions()["language"] == "en" then
			toggleTitle = "Toggle Auto Camera"
		else
			toggleTitle = "(Dés)activer Caméra Auto"
		end
	
		ToggleButton = Chili.Button:New{
			parent = Screen0,
			x = "80%",
			y = "95%",
			width = "20%",
			height = "5%",
			caption = toggleTitle,
			OnClick = { toggleCamera },
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

function widget:Shutdown()
	if window ~= nil then
		window:Dispose()
		window = nil
	end
end
