
function widget:GetInfo()
	return {
		name = "Presentation Direct Launch",
		desc = "Desactive un ensemble de Widget",
		author = "muratet",
		version = "1.0",
		date = "26 mai 2013",
		license = "Public Domain",
		layer = 209,
		enabled = true,
		handler = true, -- To see the real widgetHandler
	}
end

function widget:Initialize()
	Spring.SendCommands({'NoSound 1'}) -- Disable sound when menu pops up straight after running Spring.exe
	
	-- disable a set of widgets
	-- widget named : Kernel Panic Mission Briefing
	widgetHandler:DisableWidget("Kernel Panic Mission Briefing")
	-- widget named : Kernel Panic Automatic Tip Dispenser
	widgetHandler:DisableWidget("Kernel Panic Automatic Tip Dispenser")
	-- widget named : Spring Direct Launch 2
	widgetHandler:DisableWidget("Spring Direct Launch 2")
	
	-- disable console
	Spring.SendCommands("console 0")
	-- minimize minimap
	Spring.SendCommands("minimap min")
end

