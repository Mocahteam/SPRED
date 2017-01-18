function widget:GetInfo()
	return {
		name = "Editor Widget List",
		desc = "Returns the list of known widgets",
		author = "mocahteam",
		date = "June 24, 2016",
		license = "GNU GPL v2",
		layer = -900,
		enabled = true,
		handler = true
	}
end

function widget:Initialize()
	WG.widgetList = widgetHandler.knownWidgets
end